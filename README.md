# Interswitch Payment SDK

This library aids in processing payment through the following channels
- [x] Card
- [x] Verve Wallet
- [x] QR Code
- [x] USSD


# Usage
There are three steps you would have to complete to set up the SDK and perform transaction
 - Install the SDK as a dependency
 - Configure the SDK with Merchant Information
 - Initiate payment with customer details



#### Installation
1. Go to releases and download the zip of the latest [release](https://google.com)
2. Unzip to find the `IswMobileSdk.xcframework`, and move it to your project folder
3. Open your project in Xcode, and navigate to the `General` settings of your project
4. Choose your app in `TARGETS`, then in `General` settings, under `Framework, Libraries and Embeded Content`, click the `+` sign to add library
5. In the popup window, click `Add Other` -> `Add Files`, and navigate to the foler where you have the `IswMobileSdk.xcframework` folder and choose it
6. Now build the project

Add the following import statment to the file where you want to use the library:

````Swift 

    import IswMobileSdk
````



#### Configuration
You would also need to configure the project with your merchant credentials. Which could be done in your AppDelegate or your root ViewController.

````Swift 

    let merchantCode = "<your merchantCode>"
    let clientSecret = "<your clientSecret>"
    let clientId = "<your clientId>"
    let currencyCode = "566"
    let env: Environment = .test

    // create merchant configuration
    let config = IswSdkConfig(
        clientId: clientId, 
        clientSecret: clientSecret,
        currencyCode: currencyCode, 
        merchantCode: merchantCode
    )

    // initialize sdk
    IswMobileSdk.intialize(config: config, env: env)

````

Once the SDK has been initialized, you can then perform transactions.


#### Performing Transactions
You can perform a transaction, once the SDK is configured, like so:

1. First you would need to have you view controller implement the `IswPaymentDelegate` protocol

````Swift 


extension ViewController: IswPaymentDelegate {
    // user cancelled payment with out completion
    func onUserDidCancel() {
        // handle cancellation
    }
    
    // user completed the payment
    func onUserDidCompletePayment(result: IswPaymentResult) {
        // handle payment result
    }
}


````

2. Once you have the setup the delegate, you can trigger payments

````Swift

    @IBAction func onPayTapped(_ sender: Any) {
    
        let customerId = "<customer-id>",
            customerName = "<customer-name>",
            customerEmail = "<customer.email@domain.com>",
            customerMobile = "<customer-phone>",
            // generate a unique random
            // reference for each transaction
            reference = "<your-unique-ref>";
                        
        // amount in kobo e.g. "N500.00" -> 50000
        let amount = providedAmount; // e.g. 50000

        // create payment info
        let info = IswPaymentInfo(
            customerId: customerId,
            customerName: customerName,
            customerEmail: customerEmail, 
            customerMobile: customerMobile,
            reference: reference, 
            amount: amount
        )
    
        // trigger payment
        // parameters
        // -- on: the UIViewController triggering payment
        // -- with: the payment information to be processed
        // -- call: the IswPaymentDelegate that receives the result
        IswMobileSdk.pay(on: self, with: info, call: self)
    }
````


#### Handling Result
To process the result received `onUserDidCompletePayment` callback, here are the fields' attributes of the `IswPaymentResult`

| Field                 | Type          | meaning  |   
|-----------------------|---------------|----------|
| responseCode          | String        | txn response code  |
| responseDescription   | String        | txn response code description |
| isSuccessful          | boolean       | flag indicates if txn is successful  |
| transactionReference  | String        | reference for txn  |
| amount                | int           | txn amount  |
| channel               | PaymentChannel| channel used to make payment: one of `card`, `wallet`, `qr`, or `ussd` |


And that is it you can start processing payment in your iOS app.


