//
//  ManageScriptViewController.swift
//  Gadfly
//
//  Created by Ziwen Chen on 1/11/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

import UIKit

class ManageScriptViewController: UIViewController {

    @IBOutlet weak var allScriptButton: UIButton!
    @IBOutlet weak var composeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allScriptButton.layer.cornerRadius = 5
        composeButton.layer.borderColor = UIColor(red: CGFloat(115/255.0), green: CGFloat(93/255.0), blue: CGFloat(136/255.0), alpha: 1).cgColor
        composeButton.layer.borderWidth = 3
        composeButton.layer.cornerRadius = 5
        deleteButton.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
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
