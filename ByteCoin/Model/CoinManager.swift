//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Peiyun.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation


protocol CoinManagerDelegate {
    func didUpdateCoinManager(price:String, currency:String)
    //將錯誤管理器中傳遞出去
    func didFailWithError(error: Error)
}


struct CoinManager {
    
    var delegate:CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "your api key"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    

    func getCoinPrice(for currency:String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {
                data, response, error in
                if let error = error {
                    self.delegate?.didFailWithError(error: error)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData){
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdateCoinManager(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    
    
    
    func parseJSON(_ data:Data)->Double?{
        //建立解碼器
        let decoder = JSONDecoder()
        do{
            //從CoinData分解資料
            let decodedData = try decoder.decode(CoinData.self, from: data)
            //取得匯率
            let lastPrice = decodedData.rate
            
            return lastPrice
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
