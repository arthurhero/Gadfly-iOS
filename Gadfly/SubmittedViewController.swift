//
//  SubmittedViewController.swift
//  Gadfly
//
//  Created by Ziwen Chen on 1/5/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

import UIKit

class SubmittedViewController: UIViewController {
    
    var ticket : String = ""
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
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(SubmittedViewController.longPressed(sender:)))
        longPressRecognizer.minimumPressDuration = 0.5

        QRImageView.addGestureRecognizer(longPressRecognizer)
        
        ticketLabel.isUserInteractionEnabled = true
        let longPressRecognizer2 = UILongPressGestureRecognizer(target: self, action: #selector(SubmittedViewController.longPressed2(sender:)))
        longPressRecognizer2.minimumPressDuration = 0.2
        
        ticketLabel.addGestureRecognizer(longPressRecognizer2)
        // Do any additional setup after loading the view.
    }
    
    func longPressed(sender: UILongPressGestureRecognizer) {
        UIImageWriteToSavedPhotosAlbum(QRImageView.image!, self, #selector(SubmittedViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
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
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func twitterButtonTapped(_ sender: Any) {
        
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
