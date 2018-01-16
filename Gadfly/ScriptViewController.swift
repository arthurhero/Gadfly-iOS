//
//  ScriptViewController.swift
//  Gadfly
//
//  Created by Ziwen Chen on 1/5/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

import UIKit

class ScriptViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var tagPickerView: UIPickerView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    let pickerDataSource = [["Federal","State"],["Senator","Representative"]]
    var tagsSelected : NSMutableArray = ["1","3"]
    
    var ticket : String = ""
    var ID : String = ""
    var qrcodeImage : UIImage!
    
    func generateQRImage(with string : String) -> UIImage!{
        let data = string.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        let resultCIImage : CIImage! = filter?.outputImage
        
        let scaleX = 140 / resultCIImage.extent.size.width
        let scaleY = 140 / resultCIImage.extent.size.height
        
        let transformedImage = resultCIImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        let context = CIContext()
        let cgimg = context.createCGImage(transformedImage, from: transformedImage.extent)
        
        let resultUIImage : UIImage! = UIImage(cgImage: cgimg!)
        
        return resultUIImage
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.cornerRadius = 5.0
        
        tagPickerView.delegate = self
        tagPickerView.dataSource = self
        
        submitButton.layer.cornerRadius = 5
        clearButton.layer.borderColor = UIColor(red: CGFloat(115/255.0), green: CGFloat(93/255.0), blue: CGFloat(136/255.0), alpha: 1).cgColor
        clearButton.layer.borderWidth = 1
        clearButton.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        contentTextView.text = ""
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if (titleTextField.text! != "" && contentTextView.text! != "") {
            let dict = ["title":titleTextField.text!,"content":contentTextView.text!,"tag1":tagsSelected[0],"tag2":tagsSelected[1]]
            
            GFScript.submitScript(with: dict, completionHandler: { (result) in
                let status : String = result?["Status"] as! String
                if (status != "OK") {
                    let alert : UIAlertController = UIAlertController(title: "FAIL",
                                                                      message: "Upload failed for some reason.\n\nServer: " + status, preferredStyle: UIAlertControllerStyle.alert)
                    let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in })
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    var script : GFScript! = GFScript()
                    script.title = dict["title"] as! String
                    script.content =  dict["content"] as! String
                    script.tags = self.tagsSelected as! NSMutableArray
                    GFUser.add(script)
                    DispatchQueue.main.sync {
                        self.ticket = result?["ticket"] as! String
                        self.ID = String(format: "%@", result?["id"] as! NSNumber)
                        self.qrcodeImage = self.generateQRImage(with: "http://gadfly.mobi/services/v1/script?id=" + self.ID)
                        self.performSegue(withIdentifier: "showSubmittedView", sender: self)
                    }
                }
            })
        } else {
            let alert : UIAlertController = UIAlertController(title: "ERROR",
                                                              message: "Please fill in both the title part and the content part", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in })
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Copperplate", size: 17.0)
            pickerLabel?.textAlignment = .center
            pickerLabel?.textColor = UIColor.darkGray
        }
        pickerLabel?.text = pickerDataSource[component][row]
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0 && row == 0) {
            tagsSelected[0] = "1"
        } else if (component == 0 && row == 1) {
            tagsSelected[0] = "2"
        } else if (component == 1 && row == 0) {
            tagsSelected[1] = "3"
        } else {
            tagsSelected[1] = "4"
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSubmittedView" {
            let destinationVC = segue.destination as! SubmittedViewController
            destinationVC.ID = self.ID
            destinationVC.ticket = self.ticket
            destinationVC.qrcodeImage = self.qrcodeImage
        }
    }
    

}
