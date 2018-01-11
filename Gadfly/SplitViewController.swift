//
//  SplitViewController.swift
//  Gadfly
//
//  Created by Ziwen Chen on 1/8/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

import UIKit

class SplitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var applyLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var repTableView: UITableView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.textAlignment = .center
        contentTextView.isEditable = false
        contentTextView.textContainerInset = UIEdgeInsetsMake(10, 20, 10, 20)
        contentTextView.textAlignment = .left
        
        repTableView.delegate = self
        repTableView.dataSource = self

        
        let script = GFScript.getScript()
        titleLabel.text = script?.title
        contentTextView.text = script?.content
        
        var tagString = "Applies To: "
        let tagDict = GFTag.getTags() as! [String : String]
        for tag in (script?.tags)! {
            let t = String(describing: tag)
            tagString.append(tagDict[t]!.capitalized)
            tagString.append(" ")
        }
        applyLabel.text = tagString

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        GFUser.add(GFScript.getScript())
        let alert : UIAlertController = UIAlertController(title: "Success",
                                                          message: "Saved!", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            (sender as! UIBarButtonItem).isEnabled = false
        })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if GFUser.getPolis() != nil {
            return GFUser.getPolis().count
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "smallRepCell", for: indexPath) as! SmallRepTableViewCell

        if GFUser.getPolis() != nil {
            let rep = GFUser.getPolis()[indexPath.row] as! GFPoli
            
            let imageURL = URL(string: rep.picURL!)
            if imageURL != nil {
                let image_data = try? Data(contentsOf: imageURL!)
                if image_data != nil {
                    cell.photoImageView.image = UIImage(data: image_data!)
                }
            }
            
            var tagString = ""
            let tagDict = GFTag.getTags() as! [String : String]
            for tag in rep.tags {
                let t = String(describing: tag)
                tagString.append(tagDict[t]!)
                tagString.append(" ")
            }
            cell.tagsLabel.text = tagString.capitalized
            
            cell.nameLabel.text = rep.name
            cell.phoneLabel.text = rep.phone
            cell.partyLabel.text = rep.party
            
            return cell
        } else {
            cell.nameLabel.text = ""
            cell.phoneLabel.text = "There are no reps stored in"
            cell.tagsLabel.text = "this phone."
            cell.partyLabel.text = ""
            
            cell.phoneLabel.textColor = UIColor.lightGray
            cell.tagsLabel.textColor = UIColor.lightGray

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if GFUser.getPolis() != nil {
            let rep = GFUser.getPolis()[indexPath.row] as! GFPoli
            
            if (rep.phone != nil) {
                let phoneString = "telprompt://" + rep.phone!
                UIApplication.shared.open((URL(string: phoneString))!, options: [:], completionHandler: nil)
            } else {
                let alert : UIAlertController = UIAlertController(title: "No phone number",
                                                                  message: "This representative does not have a phone number in our database.", preferredStyle: UIAlertControllerStyle.alert)
                let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in })
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
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
