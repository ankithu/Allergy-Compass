//
//  CameraViewController.swift
//  Allergy Compass
//
//  Created by Ankith Udupa on 10/12/19.
//  Copyright © 2019 Ankith Udupa. All rights reserved.
//

//
//  CameraController.swift
//  CameraTest2
//
//  Created by Ankith Udupa on 10/11/19.
//  Copyright © 2019 Ankith Udupa. All rights reserved.
//
import AVKit
import UIKit

import Foundation
extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}
extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
extension CameraViewController : AVCapturePhotoCaptureDelegate{
   
    

    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
    resolvedSettings: AVCaptureResolvedPhotoSettings,
    bracketSettings: AVCaptureBracketedStillImageSettings?,
    error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil,
        let photoSampleBuffer = photoSampleBuffer else {
        print("Error capturing photo: \(String(describing: error))")
        return
        }
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard let imageData =
        AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
        return
        }
        // Initialise a UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
    
        if let image = capturedImage {
        // Save our captured image to photos album
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
//        DispatchQueue.main.async { // Correct
//            self.flexLabel.text = ""
//        }
        loadingSign.startAnimating();
        uploadImage(image: image)
        }
        
      
        
        
    }
}
class CameraViewController: UIViewController {
   
    @IBOutlet weak var loadingSign: UIActivityIndicatorView!
    
    @IBOutlet weak var allergyNotify: UILabel!
    var capturePhotoOutput: AVCapturePhotoOutput?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
   
    @IBOutlet weak var previewView: UIView!
    
    @IBAction func onTapTakePhoto(_ sender: Any) {
        guard let capturePhotoOutput = self.capturePhotoOutput else{ return}
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = false
        photoSettings.flashMode = .auto
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        loadingSign.stopAnimating()
        loadingSign.transform = CGAffineTransform(scaleX: 5, y: 5)
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity =  AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            previewView.layer.addSublayer(videoPreviewLayer!)
            captureSession?.startRunning()
            
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = false
            captureSession?.addOutput(capturePhotoOutput!)
        }
        catch{
            print(error)
        }
        
        
    }
    func uploadImage(image: UIImage){
        //convert the image to NSData first
        let imageData: Data? = image.jpegData(compressionQuality: 0.4)
        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
         let url = URL(string: "https://api.imgbb.com/1/upload")!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
        
       //print("hi")
       //print(image.toBase64())
      // print("bye")
         let parameters: [String: Any] = [
           "key": "468dde3a7f26b8d24f05ceefa1c2050b",
           "image":imageStr
         ]
         request.httpBody = parameters.percentEscaped().data(using: .utf8)
         let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
           guard let dataResponse = data,
                    error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
              do{
                  //here dataResponse received from a network request
                 // let jsonResponse = try JSONSerialization.jsonObject(with:dataResponse, options: [])
                //print(jsonResponse)
                if let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    // try to read out a string array
                    if let data = jsonResponse["data"] as? [String: Any]{
                        if let urlToSend = data["url"] as? String{
                            print(urlToSend)
                            self.sendToServer(urlToSend: urlToSend)
                        }
                    }
                    
                }
                else{
                    print("oof")
                }
               } catch let parsingError {
                  print("Error", parsingError)
             }
         }
         task.resume()
    }
    func sendToServer(urlToSend:String){
        let serverURL = URL(string: "https://python-server-test-69.herokuapp.com/images")
        var request = URLRequest(url: serverURL!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(urlToSend)
        var explicit = "{\"image_url\": \""
        explicit += urlToSend
        explicit += "\"}"
        request.httpBody = explicit.data(using: String.Encoding.utf8)!
        //parameters.percentEscaped().data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
              print(error!)
              print("")
            } else {
              if let returnData = String(data: data!, encoding: .utf8) {
                
                let cleanedReturn = String(returnData.filter { !" \n\t\r".contains($0) })
                print(cleanedReturn)
                //DataStorage
                DispatchQueue.main.async {
                    self.loadingSign.stopAnimating()
                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pop") as! Popup
                    popOverVC.allergyStringRaw = cleanedReturn
                    self.addChild(popOverVC)
                    popOverVC.view.frame = self.view.frame
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParent: self)
                }
               
            }
        }
        }
        task.resume()
    }
}
    


