//
//  SubmittedViewController.swift
//  Gadfly
//
//  Created by Ziwen Chen on 1/5/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

import UIKit
import FacebookShare
import TwitterKit

class SubmittedViewController: UIViewController {
    
    var ID : String = ""
    var ticket : String = ""
    var descrip: String = ""
    var qrcodeImage : UIImage!
    
    @IBOutlet weak var QRImageView: UIImageView!
    @IBOutlet weak var ticketLabel: UILabel!
    
    
    @IBAction func OkButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticketLabel.text = ticket
        QRImageView.image = qrcodeImage

        QRImageView.isUserInteractionEnabled = true
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(SubmittedViewController.tapped(sender:)))

        QRImageView.addGestureRecognizer(tapRec)
        
        ticketLabel.isUserInteractionEnabled = true
        let longPressRecognizer2 = UILongPressGestureRecognizer(target: self, action: #selector(SubmittedViewController.longPressed2(sender:)))
        longPressRecognizer2.minimumPressDuration = 0.2
        
        ticketLabel.addGestureRecognizer(longPressRecognizer2)
        // Do any additional setup after loading the view.
    }
    
    func tapped(sender: UITapGestureRecognizer) {
        let image = edit(image: QRImageView.image!, ID: self.ID, description: self.descrip)
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(SubmittedViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func longPressed2(sender: UILongPressGestureRecognizer) {
        UIPasteboard.general.string = ticketLabel.text!
        ticketLabel.textColor = UIColor.darkGray
        let alert : UIAlertController = UIAlertController(title: "COPIED",
                                                          message: "Ticket number copied to clipboard successfully.", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func image(image: UIImage!, didFinishSavingWithError error: NSError!, contextInfo: AnyObject!) {
        if (error != nil) {
            let alert : UIAlertController = UIAlertController(title: "FAIL",
                                                              message: "Fail to save this QR code.", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in })
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert : UIAlertController = UIAlertController(title: "SUCCESS",
                                                              message: "Saved this QR code successfully!", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction : UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in })
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func edit(image : UIImage!, ID : String, description : String) -> UIImage! {
        
        if (description == "") {
            let newSize = CGSize(width: 140, height: 160)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            
            image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: 140, height: 140)))
            
            let textFontAttributes = [
                NSFontAttributeName: UIFont(name: "Copperplate", size: 10)!,
                NSForegroundColorAttributeName: UIColor(red: CGFloat(115/255.0), green: CGFloat(93/255.0), blue: CGFloat(136/255.0), alpha: 1),
                ]
            
            let text : NSString = "Gadfly Call Script " + ID as NSString
            
            text.draw(in: CGRect(origin: CGPoint(x: 3, y: 140) , size: CGSize(width: 140, height: 20)), withAttributes: textFontAttributes)
            
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return result
        } else if (description.count <= 25){
            let newSize = CGSize(width: 140, height: 170)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            
            image.draw(in: CGRect(origin: CGPoint(x : 0,y : 10), size: CGSize(width: 140, height: 140)))
            
            let textFontAttributes = [
                NSFontAttributeName: UIFont(name: "Copperplate", size: 10)!,
                NSForegroundColorAttributeName: UIColor(red: CGFloat(115/255.0), green: CGFloat(93/255.0), blue: CGFloat(136/255.0), alpha: 1),
                ]
            
            let text : NSString = "Gadfly Call Script " + ID as NSString
            
            description.draw(in: CGRect(origin: CGPoint(x: 3, y: 1) , size: CGSize(width: 140, height: 9)), withAttributes: textFontAttributes)
            
            text.draw(in: CGRect(origin: CGPoint(x: 3, y: 150) , size: CGSize(width: 140, height: 20)), withAttributes: textFontAttributes)
            
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return result
        } else {
            let newSize = CGSize(width: 140, height: 180)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            
            image.draw(in: CGRect(origin: CGPoint(x : 0,y : 20), size: CGSize(width: 140, height: 140)))
            
            let textFontAttributes = [
                NSFontAttributeName: UIFont(name: "Copperplate", size: 10)!,
                NSForegroundColorAttributeName: UIColor(red: CGFloat(115/255.0), green: CGFloat(93/255.0), blue: CGFloat(136/255.0), alpha: 1),
                ]
            
            let text : NSString = "Gadfly Call Script " + ID as NSString
            
            text.draw(in: CGRect(origin: CGPoint(x: 3, y: 160) , size: CGSize(width: 140, height: 20)), withAttributes: textFontAttributes)

            let index = description.index(description.startIndex, offsetBy: 25)
            
            if (description[index] == " " || description[description.index(index, offsetBy: -1)] == " ") {
                let substring1 = description.substring(to: index)
                substring1.draw(in: CGRect(origin: CGPoint(x: 3, y: 1) , size: CGSize(width: 140, height: 9)), withAttributes: textFontAttributes)

                let substring2 = description.substring(from: index)
                
                if (substring2.count > 25) {
                    let index2 = substring2.index(substring2.startIndex, offsetBy: 22)
                    let substring3 = substring2.substring(to: index2) + "..."
                    substring3.draw(in: CGRect(origin: CGPoint(x: 3, y: 11) , size: CGSize(width: 140, height: 9)), withAttributes: textFontAttributes)
                } else {
                    substring2.draw(in: CGRect(origin: CGPoint(x: 3, y: 11) , size: CGSize(width: 140, height: 9)), withAttributes: textFontAttributes)
                }
            } else {
                let substring1 = description.substring(to: index) + "-"
                substring1.draw(in: CGRect(origin: CGPoint(x: 3, y: 1) , size: CGSize(width: 140, height: 9)), withAttributes: textFontAttributes)
                
                let substring2 = description.substring(from: index)
                if (substring2.count > 25) {
                    let index2 = substring2.index(substring2.startIndex, offsetBy: 22)
                    let substring3 = substring2.substring(to: index2) + "..."
                    substring3.draw(in: CGRect(origin: CGPoint(x: 3, y: 11) , size: CGSize(width: 140, height: 9)), withAttributes: textFontAttributes)
                } else {
                    substring2.draw(in: CGRect(origin: CGPoint(x: 3, y: 11) , size: CGSize(width: 140, height: 9)), withAttributes: textFontAttributes)
                }
            }
            
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return result
        }
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        if (qrcodeImage != nil) {
            let image = edit(image: qrcodeImage!, ID: self.ID, description: self.descrip)
            let photo = Photo(image: image!, userGenerated: true)
            let content = PhotoShareContent(photos: [photo])
            
            let shareDialog = ShareDialog(content: content)
            shareDialog.presentingViewController = self
            shareDialog.mode = .shareSheet
            shareDialog.failsOnInvalidData = true
            do {
                try shareDialog.show()
            } catch {
                print("Error showing facebook dialog")
            }
        }
    }
    
    @IBAction func twitterButtonTapped(_ sender: Any) {
        if (qrcodeImage != nil) {
            let image = edit(image: qrcodeImage!, ID: self.ID, description: self.descrip)
            let composer = TWTRComposer()
            
            composer.setText("I've composed a Gadfly Call Script!")
            composer.setImage(image)
            
            composer.show(from: self, completion: { (result) in
                if (result == .done) {
                    print("Successfully composed Tweet")
                } else {
                    print("Cancelled composing")
                }
            })
        }
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
