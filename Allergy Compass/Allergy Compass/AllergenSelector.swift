//
//  AllergenSelector.swift
//  Allergy Compass
//
//  Created by Ankith Udupa on 10/12/19.
//  Copyright © 2019 Ankith Udupa. All rights reserved.
//

import UIKit
import M13Checkbox


class AllergenSelector: UIViewController {
    
     
   
    @IBOutlet weak var soybean: M13Checkbox!
    @IBOutlet weak var seafood: M13Checkbox!
    @IBOutlet weak var dairy: M13Checkbox!
    @IBOutlet weak var nuts: M13Checkbox!
    let defaults = UserDefaults.standard
    @IBAction func sendData(_ sender: Any) {
        defaults.set((soybean.checkState == .checked),forKey: "soy");
        defaults.set((dairy.checkState == .checked),forKey: "dairy");
        defaults.set((seafood.checkState == .checked),forKey: "seafood");
        defaults.set((nuts.checkState == .checked),forKey: "nuts");
        sendToServer(name: defaults.string(forKey: "username")!, nuts: defaults.bool(forKey: "nuts"), dairy: defaults.bool(forKey: "dairy"), seafood: defaults.bool(forKey: "seafood"), soybeans: defaults.bool(forKey: "soy"))
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        if let username = defaults.string(forKey: "username"){
            querryServer(name: username, request: "getSoy", table:"soy")
            querryServer(name: username, request: "getDairy", table:"dairy")
            querryServer(name: username, request: "getSeafood", table:"seafoood")
            querryServer(name: username, request: "getNuts", table:"nuts")
            
        }
        if defaults.bool(forKey: "soy"){
            soybean.setCheckState(.checked, animated: false)
        }
        if defaults.bool(forKey: "dairy"){
            dairy.setCheckState(.checked, animated: false)
        }
        if defaults.bool(forKey: "seafood"){
            seafood.setCheckState(.checked, animated: false)
        }
        if defaults.bool(forKey: "nuts"){
            nuts.setCheckState(.checked, animated: false)
        }
        
    }
    func querryServer(name:String, request:String, table:String){
           let serverURL = URL(string: "https://python-server-test-69.herokuapp.com/"+request)
           var request = URLRequest(url: serverURL!)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           var explicit = "{\"name\": \""
           explicit += name
        explicit += "\"}";
        request.httpBody = explicit.data(using: String.Encoding.utf8)
        print(request.httpBody)
        
           //parameters.percentEscaped().data(using: .utf8)
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
              if let returnData = String(data: data!, encoding: .utf8) {
                 let cleanedReturn = String(returnData.filter { !" \n\t\r".contains($0) })
                self.defaults.set(cleanedReturn.contains("true"), forKey: table)
                
            }
           }
           task.resume()
       }
    func sendToServer(name:String, nuts:Bool, dairy:Bool, seafood:Bool, soybeans:Bool){
        let serverURL = URL(string: "https://python-server-test-69.herokuapp.com/preferenceUpdate")
        var request = URLRequest(url: serverURL!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        var explicit = "{\"name\": \""
        explicit += name
        explicit += "\",\"Nuts\": \""
        explicit += String(nuts)
        explicit += "\",\"Seafood\": \""
        explicit += String(seafood)
        explicit += "\",\"Dairy\": \""
        explicit += String(dairy)
        explicit += "\",\"Soy\": \""
        explicit += String(soybeans)
        explicit += "\",\"password\": \""
        explicit += defaults.string(forKey: "password")!
        explicit += "\"}"
        print(explicit)
        request.httpBody = explicit.data(using: String.Encoding.utf8)!
        //parameters.percentEscaped().data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil){
                print(error)
            }
            else{
                print(response)
            }
        }
        task.resume()
    }
   
}
