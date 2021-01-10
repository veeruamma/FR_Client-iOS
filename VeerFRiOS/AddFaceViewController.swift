//
//  AddFaceViewController.swift
//  VeerFRiOS
//
//  Created by Veeresh Ittangihal on 07/01/21.
//

import UIKit

class AddFaceViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var capturedImageView: UIImageView!
    
    @IBAction func homeBtnClicked(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddFaceToHomeSegue", sender: self)
    }
    
    @IBOutlet weak var enterNameFiled: UITextField!
  
    @IBOutlet weak var notifyLabel: UILabel!
    
    //1. define image picker
    let imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        dismiss keyboard when clicking on background
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        enterNameFiled.delegate = self
        
        //set delegate for imagepicker
        imagePicker.delegate = self
        imagePicker.sourceType = .camera //reads the image from camera
        imagePicker.allowsEditing = false //to allow editing the picked image
        
    }
    
    @objc func handleTap(){
        enterNameFiled.resignFirstResponder()
    }
    
    // hide keyboard on pressing return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    @IBAction func regBtnClicked(_ sender: UIButton) {
        let cvMat = OpenCVWrapper.makeImage(toMat: capturedImageView.image)
        let rows = OpenCVWrapper.getRows(capturedImageView.image)!
        let cols = OpenCVWrapper.getCols(capturedImageView.image)!
        let name = enterNameFiled.text!
        print(name)
        sendToWebServer(name: name, cvData: (cvMat?.base64EncodedString())!, rows: rows, cols: cols, endpoint: "train_ios")
        enterNameFiled.text = " "
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
            notifyLabel.text = dataString!
        }
    }
    
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//extension AddFaceViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
//

