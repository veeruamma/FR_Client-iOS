//
//  RecogniseViewController.swift
//  VeerFRiOS
//
//  Created by Veeresh Ittangihal on 07/01/21.
//

import UIKit


class RecogniseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var recResultLabel: UILabel!
    @IBOutlet weak var capturedImageView: UIImageView!
    
    @IBAction func homeBtnClicked(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "RecToHomeSegue", sender: self)
    }
    
    //1. define image picker
    let imagePicker = UIImagePickerController()
    
//    let apiRequest = APIRequest(endpoint: "rec_ios")
    
    func printRecResult(result:String){
        recResultLabel.text = result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegate for imagepicker
        imagePicker.delegate = self
        imagePicker.sourceType = .camera //reads the image from camera
        imagePicker.allowsEditing = false //to allow editing the picked image
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let fixedImage = pickedImage.fixedOrientation()
            capturedImageView.image = fixedImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func camBtnTapped(_ sender: UIBarButtonItem) {
        print("Camera button tapped !!!!")
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func recBtnTapped(_ sender: UIButton) {
//        capturedImageView.image = OpenCVWrapper.makeGrayScale(capturedImageView.image)
        let cvMat = OpenCVWrapper.makeImage(toMat: capturedImageView.image)
        let rows = OpenCVWrapper.getRows(capturedImageView.image)!
        let cols = OpenCVWrapper.getCols(capturedImageView.image)!
//        apiRequest.sendToWebServer(name: "Veeresh", cvData: (cvMat?.base64EncodedString())!, rows: rows, cols: cols)
        sendToWebServer(name: "Veeresh", cvData: (cvMat?.base64EncodedString())!, rows: rows, cols: cols, endpoint: "rec_ios")
    }
    
    func getURL(endpoint : String) -> URL {
//        let resourceString = "http://192.168.56.227:5000/\(endpoint)"
        let resourceString = "http://192.168.0.136:5000/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        return resourceURL
    }
    
    func sendToWebServer(name: String, cvData: String, rows: String, cols: String, endpoint: String){
        do{
            let resourceURL = getURL(endpoint: endpoint)
            let parameterDictionary = ["name" : name, "cvData": cvData, "rows" : rows, "cols": cols]
            let httpBody = try JSONSerialization.data(withJSONObject: parameterDictionary, options: [])
            
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = httpBody
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: handle(data: response: error: ))
            
            dataTask.resume()
                
        } catch{
            print(error)
        }
                
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?){
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
            recResultLabel.text = dataString!
        }
    }
    
}


extension UIImage {
    func fixedOrientation() -> UIImage {
        if imageOrientation == .up { return self }

        var transform:CGAffineTransform = .identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height).rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0).rotated(by: .pi/2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height).rotated(by: -.pi/2)
        default: break
        }

        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0).scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0).scaledBy(x: -1, y: 1)
        default: break
        }

        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                       bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: cgImage!.colorSpace!, bitmapInfo: cgImage!.bitmapInfo.rawValue)!
        ctx.concatenate(transform)

        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height,height: size.width))
        default:
            ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width,height: size.height))
        }
        return UIImage(cgImage: ctx.makeImage()!)
    }
}

