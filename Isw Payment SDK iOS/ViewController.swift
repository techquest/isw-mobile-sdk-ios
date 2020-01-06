//
//  ViewController.swift
//  Isw Payment SDK iOS
//
//  Created by ebi igweze on 01/01/2020.
//  Copyright © 2020 Interswitch. All rights reserved.
//

import UIKit
import IswMobileSdk

struct Config: Decodable {
    let currencyCode: String
    let merchantId: String
    let merchantSecrete: String
    let merchantCode: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 5
    }
    
    @IBAction func onPayTapped(_ sender: Any) {
        guard let preparedConfig = getConfigFromProps() else { return }
        let config = IswSdkConfig(merchantId: preparedConfig.merchantId,
                                  merchantSecrete: preparedConfig.merchantSecrete,
                                  currencyCode: preparedConfig.currencyCode,
                                  merchantCode: preparedConfig.merchantCode)
        
        let date = Int64((Date().timeIntervalSince1970 * 1000.0).rounded())
        let customerId = "your+customer+id",
        customerName = "James Emmanuel",
        customerEmail = "ken@gmail.com",
        customerMobile = "08031149929",
        reference = "payment-" + String(date)
        
        let hasText = amountInput.text != nil && amountInput.text!.count > 0
        let amountString: String = hasText ? amountInput.text! : "2500"
        let amount = Int(amountString)! * 100
        let info = IswPaymentInfo(customerId: customerId, customerName: customerName,
                                  customerEmail: customerEmail, customerMobile: customerMobile,
                                  reference: reference, amount: amount)
        
        IswMobileSdk.intialize(config: config)
        
        IswMobileSdk.pay(on: self, with: info, call: self)
    }

    private func getConfigFromProps() -> Config? {
        // get configuration stored in Preference.plist file
        if  let path = Bundle.main.path(forResource: "Preference", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let config = try? PropertyListDecoder().decode(Config.self, from: xml) {
        
            // return extracted config
            return config
        }
        
        return nil
    }
}



extension ViewController: IswPaymentDelegate {
    func onUserDidCancel() {
        let message = "You cancelled payment, please try again"
        self.toast(message: message)
    }
    
    func onUserDidCompletePayment(result: IswPaymentResult) {
        let message = "You completed payment"
        self.toast(message: message)
    }
    
    func toast(message: String, delay: Double = 3.0) {
        // create toast
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        if let popoverController = alert.popoverPresentationController {
            // to set the source of your alert
            popoverController.sourceView = self.view
            
            // set the toas to show at bottom of screen.
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
            
            // to hide the arrow of any particular direction
            popoverController.permittedArrowDirections = []
            
            // show toast
            self.present(alert, animated: true)
            // dismiss toast after time delay
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                alert.dismiss(animated: true)
            }
        }
    }
}
