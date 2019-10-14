//
//  Login.swift
//  Allergy Compass
//
//  Created by Ankith Udupa on 10/12/19.
//  Copyright © 2019 Ankith Udupa. All rights reserved.
//

import UIKit
class Login: ViewController{
    var loginGood = false
   
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBAction func submit(_ sender: Any) {
        sendToServer(name: username.text!, password: password.text!)
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        password.isSecureTextEntry = true
    }
    override func viewDidAppear(_ animated: Bool)  {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func sendToServer(name:String, password:String){
           let serverURL = URL(string: "https://python-server-test-69.herokuapp.com/login")
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
            if (error != nil){
               
            }
            if let returnData = String(data: data!, encoding: .utf8) {
                           
                let cleanedReturn = String(returnData.filter { !" \n\t\r".contains($0) })
                print(cleanedReturn)
                if (cleanedReturn=="{\"good\":\"good\"}"){
                    self.loginGood = true;
                    let defaults = UserDefaults.standard
                    defaults.set(name, forKey:"username")
                    //HASHSHSHSHSHSH
                    defaults.set(password, forKey:"password")
                    DispatchQueue.main.async { // Correct
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainScreen")
                        self.present(newViewController, animated: true, completion: nil)
                    }
                }
            }
            if (self.loginGood==false){
                 DispatchQueue.main.async { // Correct
                    self.titleLabel.text = "Try Again"
                 }
            }
           }
           task.resume()
    
       }
}
