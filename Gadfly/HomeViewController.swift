//
//  HomeViewController.swift
//  Gadfly
//
//  Created by Ziwen Chen on 1/5/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var readyForRep : Bool = false
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var lowerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GFTag.initTags()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if readyForRep {
            searchButton.isEnabled = false
            lowerButton.isEnabled = false
            centerLabel.text = "Loading... Please be patient..."
            let address = GFUser.getAddress()
            print("ADDRESS!!!!!!!!" + address!)
            
            GFPoli.fetch(withAddress: address, completionHandler: { (result : [Any]?) in
                if (result?.count)! < 2 {
                    let error : String = result![0] as! String
                    print(error)
                    let alert : UIAlertController = UIAlertController(title: "FAIL",
                                                                       message: "Failed at fetching reps. Please check your internet connection, try with another address nearby or try with a slightly less detailed address.", preferredStyle: UIAlertControllerStyle.alert)
                    let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        self.centerLabel.text = "GET YOUR REPS!"
                        self.searchButton.isEnabled = true
                        self.lowerButton.isEnabled = true
                        self.readyForRep = false
                    })
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let polis : [GFPoli] = result as! [GFPoli]
                    GFUser.cachePolis(polis)
                    self.centerLabel.text = "Done!"
                    self.readyForRep = false
                    self.performSegue(withIdentifier: "showRepTableView", sender: self)
                }
            })

        } else {
            self.centerLabel.text = "GET YOUR REPS!"
            self.searchButton.isEnabled = true
            self.lowerButton.isEnabled = true
        }
    }
    
    @IBAction func lowerButtonIsTapped(_ sender: Any) {
        
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRepTableView" {
        }
    }
 

}
