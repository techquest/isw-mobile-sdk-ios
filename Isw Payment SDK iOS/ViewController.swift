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
    let clientId: String
    let clientSecret: String
    let merchantCode: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var resultContainer: UIStackView!
    @IBOutlet weak var resultAmount: UILabel!
    @IBOutlet weak var resultChannel: UILabel!
    @IBOutlet weak var resultCode: UILabel!
    @IBOutlet weak var resultDescription: UILabel!
    @IBOutlet weak var resultSuccessStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 5
        
        amountInput.addTarget(self, action: #selector(didTypeAmount), for: .editingChanged)
        // hide result
        toggleResult(show: false)
    }
    
    @IBAction func onPayTapped(_ sender: Any) {
        
        let date = Int64((Date().timeIntervalSince1970 * 1000.0).rounded())
        let customerId = "your+customer+id",
        customerName = "James Emmanuel",
        customerEmail = "ken@gmail.com",
        customerMobile = "08031149929",
        reference = "payment-" + String(date)
        
        let hasText = amountInput.text != nil && amountInput.text!.count > 0
        let amountString: String = hasText ? amountInput.text! : "2500"
        let amount = Int(amountString)! * 100
        let info = IswPaymentInfo(
            customerId: customerId,
            customerName: customerName,
            customerEmail: customerEmail,
            customerMobile: customerMobile,
            reference: reference,
            amount: amount
        )
        
        
        IswMobileSdk.pay(on: self, with: info, call: self)
    }
    
    
    @objc func didTypeAmount() {
        // hide the result
        toggleResult(show: false)
    }
    
    
    private func showResult(title: String, result: IswPaymentResult?) {
        // show result
        toggleResult(show: true)
        resultTitle.text = title
        let hasValue = result != nil
        resultTitle.textColor = !hasValue ? .red : .blue
        
        resultAmount.isHidden = !hasValue
        resultCode.isHidden = !hasValue
        resultDescription.isHidden = !hasValue
        resultSuccessStatus.isHidden = !hasValue
        resultChannel.isHidden = !hasValue
        
        guard let result = result else { return }
        
        resultAmount.text = "\(result.amount / 100)"
        resultCode.text = result.responseCode
        resultDescription.text = result.responseDescription
        resultSuccessStatus.text = "\(result.isSuccessful)"
        resultChannel.text = "\(result.channel)"
    }
    
    private func toggleResult(show: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.resultContainer.alpha = show ? 1 : 0
            self.resultContainer.isHidden = !show
        }
    }
}



extension ViewController: IswPaymentDelegate {
    func onUserDidCancel() {
        let title = "You cancelled payment"
        showResult(title: title, result: nil)
    }
    
    func onUserDidCompletePayment(result: IswPaymentResult) {
        let title = "Payment Result"
        showResult(title: title, result: result)
    }
}
