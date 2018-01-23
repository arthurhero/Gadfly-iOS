//
//  DeleteViewController.swift
//  Gadfly
//
//  Created by Ziwen Chen on 1/11/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

import UIKit

class DeleteViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    func enterLoadingMode() {
        submitButton.isEnabled = false
        cancelButton.isEnabled = false
    }
    
    func enterNormalMode() {
        submitButton.isEnabled = true
        cancelButton.isEnabled = true
    }
    
    @IBOutlet weak var ticketTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        enterNormalMode()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        enterLoadingMode()
        
        let ticket : String = ticketTextField.text!
        print(ticket)
        
        GFScript.delete(withTicket: ticket) { (result) in
            let status : String = result?["Status"] as! String
            if (status != "OK") {
                DispatchQueue.main.sync {
                    let alert : UIAlertController = UIAlertController(title: "FAIL",
                                                                      message: "Fail to delete this script\n\nServer: " + status, preferredStyle: UIAlertControllerStyle.alert)
                    let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        self.enterNormalMode()
                    })
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
            } else {
                DispatchQueue.main.sync {
                    let alert : UIAlertController = UIAlertController(title: "SUCCESS",
                                                                      message: "Deleted Successfully!", preferredStyle: UIAlertControllerStyle.alert)
                    let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        self.enterNormalMode()
                    })
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
