//
//  HomeViewController.swift
//  VeerFRiOS
//
//  Created by Veeresh Ittangihal on 07/01/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBAction func addFaceBtnClicked(_ sender: UIButton) {
        print("Add Face button clicked !!!")
        self.performSegue(withIdentifier:"AddFaceSegue", sender: self)
    }
    @IBAction func RecogniseBtnClicked(_ sender: UIButton) {
        print("Recognise Button clicked !!!")
        self.performSegue(withIdentifier: "RecogniseSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


