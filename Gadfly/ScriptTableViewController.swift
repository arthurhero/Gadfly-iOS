//
//  ScriptTableViewController.swift
//  Gadfly
//
//  Created by Ziwen Chen on 1/9/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

import UIKit

class ScriptTableViewController: UITableViewController {
    
    var deleteMode : Bool = false

    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if deleteMode {
            (sender as! UIBarButtonItem).title = "Edit"
            deleteMode = false
        } else {
            (sender as! UIBarButtonItem).title = "Done"
            deleteMode = true
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if GFUser.getScripts() != nil {
            return GFUser.getScripts().count
        } else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scriptCell", for: indexPath) as! ScriptTableViewCell
        
        if GFUser.getScripts() != nil {
            let script = GFUser.getScripts()[indexPath.row] as! GFScript
            cell.titleLabel.text = script.title
            cell.contentTextField.text = script.content
            cell.contentTextField.isEditable = false
            cell.contentTextField.isScrollEnabled = false
            cell.contentTextField.isSelectable = false
            cell.contentTextField.isUserInteractionEnabled = false
            return cell
        } else {
            cell.titleLabel.text = "No scripts stored."
            cell.contentTextField.text = ""
            cell.contentTextField.isEditable = false
            cell.contentTextField.isScrollEnabled = false
            cell.contentTextField.isSelectable = false
            cell.contentTextField.isUserInteractionEnabled = false
            cell.titleLabel.textColor = UIColor.lightGray
            cell.titleLabel.textAlignment = .center
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if GFUser.getScripts() != nil {
            let script = GFUser.getScripts()[indexPath.row] as! GFScript
            GFScript.cacheScript(script)
            performSegue(withIdentifier: "ShowScriptDetail", sender: self)
        }
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return deleteMode
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            GFUser.removeScript(Int32(indexPath.row))
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowScriptDetail" {
            let destinationVC = segue.destination as! SplitViewController
            destinationVC.navigationItem.rightBarButtonItem = nil
        }
    }
    

}
