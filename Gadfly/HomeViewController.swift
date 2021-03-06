//
//  HomeViewController.swift
//  Gadfly
//
//  Created by Ziwen Chen on 1/5/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class HomeViewController: UIViewController {
    
    var readyForRep : Bool = false
    var readyForScript : Bool = false
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var lowerButton: UIButton!
    @IBOutlet weak var cleanButton: UIButton!
    @IBOutlet weak var qrcodeButton: UIBarButtonItem!
    
    func enterLoadingMode() {
        searchButton.isEnabled = false
        lowerButton.isEnabled = false
        cleanButton.isEnabled = false
        qrcodeButton.isEnabled = false
        centerLabel.text = "Loading... Please be patient..."
    }
    
    func enterNormalMode() {
        searchButton.isEnabled = true
        lowerButton.isEnabled = true
        cleanButton.isEnabled = true
        qrcodeButton.isEnabled = true
        centerLabel.text = "GET YOUR REPS!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GFTag.initTags()
        
        lowerButton.layer.cornerRadius = 5
        cleanButton.layer.borderColor = UIColor(red: CGFloat(115/255.0), green: CGFloat(93/255.0), blue: CGFloat(136/255.0), alpha: 1).cgColor
        cleanButton.layer.borderWidth = 2
        cleanButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if readyForRep {
            enterLoadingMode()
            if GFUser.getAddress() == nil {
                print("nil!!!!!!")
                self.enterNormalMode()
                return
            }
            
            let address = GFUser.getAddress()
            
            GFPoli.fetch(withAddress: address, completionHandler: { (result : [Any]?) in
                if (result?.count)! < 2 {
                    let error : String = result![0] as! String
                    print(error)
                    let alert : UIAlertController = UIAlertController(title: "FAIL",
                                                                       message: "Failed at fetching reps. Please check your internet connection, try with another address nearby or try with a slightly more numerical address.\n\nServer: "+error, preferredStyle: UIAlertControllerStyle.alert)
                    let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        self.enterNormalMode()
                        self.readyForRep = false
                    })
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let polis : [GFPoli] = result as! [GFPoli]
                    GFUser.cachePolis(polis)
                    self.readyForRep = false
                    DispatchQueue.main.sync {
                        self.performSegue(withIdentifier: "showRepTableView", sender: self)
                    }
                }
            })

        } else if readyForScript {
            enterLoadingMode()
            let ID = GFScript.getID()
            
            GFScript.fetch(withID: ID, completionHandler: { (script) in
                if (script?.content == "") {
                    let error : String = (script?.title)!
                    let alert : UIAlertController = UIAlertController(title: "FAIL",
                                                                      message: error, preferredStyle: UIAlertControllerStyle.alert)
                    let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        self.enterNormalMode()
                        self.readyForScript = false
                    })
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    GFScript.cacheScript(script)
                    self.readyForScript = false
                    DispatchQueue.main.sync {
                        self.performSegue(withIdentifier: "showSplitView", sender: self)
                    }
                }
            })
            
        } else {
            enterNormalMode()
        }
    }
    
    @IBAction func lowerButtonIsTapped(_ sender: Any) {
        enterLoadingMode()
        
        if GFUser.getPolis() != nil {
            self.performSegue(withIdentifier: "showRepTableView", sender: self)
        } else if GFUser.getAddress() != nil {
            let address = GFUser.getAddress()
            GFPoli.fetch(withAddress: address, completionHandler: { (result : [Any]?) in
                if (result?.count)! < 2 {
                    let error : String = result![0] as! String
                    print(error)
                    let alert : UIAlertController = UIAlertController(title: "FAIL",
                                                                      message: "Failed at fetching reps. Please check your internet connection, try with another address nearby or try with a slightly less detailed address.\n\nServer: "+error, preferredStyle: UIAlertControllerStyle.alert)
                    let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        self.enterNormalMode()
                    })
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let polis : [GFPoli] = result as! [GFPoli]
                    GFUser.cachePolis(polis)
                    DispatchQueue.main.sync {
                        self.performSegue(withIdentifier: "showRepTableView", sender: self)
                    }
                }
            })
        } else {
            enterNormalMode()
            let alert : UIAlertController = UIAlertController(title: "NO CACHED INFO",
                                                              message: "There is not information stored in this phone yet. Please tap the icon above to input the address.", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in })
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cleanButtonTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "address")
        GFUser.reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
     
    @IBAction func unwindToHome(segue:UIStoryboardSegue) {
        if segue.identifier == "unwindToHome" {
            readyForRep = true
        }
    }
    
    @IBAction func unwindToHome2(segue:UIStoryboardSegue) {
        if segue.identifier == "unwindToHome2" {
            readyForScript = true
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRepTableView" {
        }
    }
 

}
