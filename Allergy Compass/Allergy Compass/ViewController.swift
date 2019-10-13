//
//  ViewController.swift
//  Allergy Compass
//
//  Created by Ankith Udupa on 10/12/19.
//  Copyright © 2019 Ankith Udupa. All rights reserved.
//

import UIKit
extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
class ViewController: UIViewController {
    
    @IBOutlet weak var userlabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "username"){
            print(name)
            if let _ = self.userlabel{
                self.userlabel.text = "Hello, " + name
            }
            //self.userlabel.text = ("Hello, " + (name))
        }
        else{
            if let _ = self.userlabel{
                self.userlabel.text = ""
            }
            //userlabel.text = ""
        }
        //userlabel.text = ""
        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if !(defaults.bool(forKey: "setup")){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "signUp")
            self.present(newViewController, animated: true, completion: nil)

        }
    }


}

