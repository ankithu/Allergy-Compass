//
//  SignUp.swift
//  Allergy Compass
//
//  Created by Ankith Udupa on 10/12/19.
//  Copyright © 2019 Ankith Udupa. All rights reserved.
//

import UIKit
class SignUp: UIViewController {
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    let defaults = UserDefaults.standard
    @IBAction func submit(_ sender: Any) {
        defaults.set(true, forKey: "setup")
        defaults.set(user.text, forKey:"username")
        //HASHSHSHSHSHSH
        defaults.set(password.text, forKey:"password")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "allergySelector")
        sendToServer(name: user.text!, password: password.text!)
        
        
        self.present(newViewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        password.isSecureTextEntry = true
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func sendToServer(name:String, password:String) {
        let serverURL = URL(string: "https://python-server-test-69.herokuapp.com/addUser")
        var request = URLRequest(url: serverURL!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        var explicit = "{\"name\": \""
        explicit += name
        explicit += "\",\"password\": \""
        explicit += password
        explicit += "\"}"
        request.httpBody = explicit.data(using: String.Encoding.utf8)!
        //parameters.percentEscaped().data(using: .utf8)
    
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
   
        }
        task.resume()
    }
}
