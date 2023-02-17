//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
    
}



//MARK: - CoinManagerDelegate
extension ViewController:CoinManagerDelegate{
    
    
    func didUpdateCoinManager(price:String, currency:String){
        
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    //將錯誤管理器中傳遞出去
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - UIPickerViewDataSource & delegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    //pickerView的標題
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    //選中時需要做什麼
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //取得是哪一種幣值
        let selectCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectCurrency)
    }
}


