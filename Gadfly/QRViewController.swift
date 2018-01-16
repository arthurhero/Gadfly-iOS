//
//  QRViewController.swift
//  Gadfly
//
//  Created by Ziwen Chen on 1/5/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBAction func CancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input : AnyObject! = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            captureSession = AVCaptureSession()
            captureSession?.addInput(input as! AVCaptureInput)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = cameraView.layer.bounds
            cameraView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            qrCodeFrameView = UIView()
            qrCodeFrameView?.layer.borderColor = UIColor(red: CGFloat(115/255.0), green: CGFloat(93/255.0), blue: CGFloat(136/255.0), alpha: 1).cgColor
            qrCodeFrameView?.layer.borderWidth = 4
            qrCodeFrameView?.layer.cornerRadius = 5
            cameraView.addSubview(qrCodeFrameView!)
            cameraView.bringSubview(toFront: qrCodeFrameView!)
            qrCodeFrameView?.frame = CGRect(x: cameraView.bounds.midX - 100, y: cameraView.bounds.midY - 100, width: 200, height: 200)

        } catch let error as NSError {
            print(error)
        }

        
        // Do any additional setup after loading the view.
    }

    func captureOutput(_ output: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            
            if metadataObj.stringValue != nil {
                let comp = metadataObj.stringValue.components(separatedBy: "=")
                if (comp.first == "http://gadfly.mobi/services/v1/script?id") {
                    let ID = comp.last
                    GFScript.cacheID(ID)
                    performSegue(withIdentifier: "unwindToHome2", sender: self)
                }
            }
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
