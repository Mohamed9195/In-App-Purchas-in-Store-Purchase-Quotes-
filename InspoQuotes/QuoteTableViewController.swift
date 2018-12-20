// not work because i not have
/*
 1- developer account
 2- id for app in store
 3- setupp sandbox to run in test
 */

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController , SKPaymentTransactionObserver{
 
    
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let ID = "When use it"
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self)
        if isPurchas() {
            runAfterPremium()
        }
        
    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchas(){
            return quotesToShow.count
        }else{
            return quotesToShow.count + 1
        }
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)

        if indexPath.row < quotesToShow.count {
        cell.textLabel?.text = quotesToShow[indexPath.row]
        cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            cell.accessoryType = .none
        }else{
            cell.textLabel?.text = "get More"
            cell.textLabel?.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
  


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
  


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
   

  
    
    
    // MARK: - Table view Deleget
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            BuyPrimary()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Buy
    func BuyPrimary()  {
        if  SKPaymentQueue.canMakePayments() {
            print("A")
            
            let payment = SKMutablePayment()
            payment.productIdentifier = ID
            SKPaymentQueue.default().add(payment)
            
        }else{
            print("B")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for i in transactions {
            if  i.transactionState == .purchased {
                // success
                
                runAfterPremium()
                UserDefaults.standard.set(true, forKey: ID)
                SKPaymentQueue.default().finishTransaction(i)
                
                
            }else if i.transactionState == .failed {
                // faild
                if  i.error != nil {
                    
                }
                
                SKPaymentQueue.default().finishTransaction(i)
                
            }else if i.transactionState == .restored {
                // restor
                runAfterPremium()
                navigationItem.setRightBarButton(nil, animated: true)
                SKPaymentQueue.default().finishTransaction(i)
            }
        }
        
    }
    
    func runAfterPremium() {
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    
    func isPurchas() -> Bool {
        let purchasStatus = UserDefaults.standard.bool(forKey: ID)
        if purchasStatus{
            // stile  in purchase
            return true
        }else{
            return false
        }
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }


}
