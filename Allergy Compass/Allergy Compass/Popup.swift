//
//  Popup.swift
//  Allergy Compass
//
//  Created by Ankith Udupa on 10/13/19.
//  Copyright © 2019 Ankith Udupa. All rights reserved.
//

import UIKit
class Popup: ViewController{
    var allergyStringRaw:String=""
    @IBOutlet var background: UIView!
    @IBOutlet weak var allergyLabel: UILabel!
    @IBOutlet weak var popupbox: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
            showAnimate()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.background.addGestureRecognizer(gesture)
         let gesture2 = UISwipeGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.popupbox.addGestureRecognizer(gesture2)
        let components = allergyStringRaw.components(separatedBy: ":")
        let sep = components[1].components(separatedBy: "~")
        let des = sep[0].dropFirst()
        let allergenString = sep[1].dropLast()
        let allergies = ["nuts","dairy","seafood","soy"]
        var warningString = "Oh No! Contains "
        var count = 0
        let defaults = UserDefaults.standard
        for char in allergenString{
            if (char == "1" && defaults.bool(forKey: allergies[count])){
                warningString += allergies[count]
                warningString += ", "
            }
            count = count + 1
        }
        
        if (warningString == "Oh No! Contains "){
            warningString = "Yay! No Allergens!"
            popupbox.backgroundColor = UIColor.green
        }
        else{
            popupbox.backgroundColor = UIColor.red
            warningString = String(warningString.dropLast(2))+".";
        }
        var desc = String(des)
        var copy = desc
        var counter = 0
        var numSpaces = 0
        for char in copy{
            if (char.isUppercase && counter < copy.count && counter != 0){
                copy.insert(" ", at: copy.index(copy.startIndex, offsetBy: counter + numSpaces))
                numSpaces = numSpaces + 1
            }
            counter = counter + 1;
        }
        allergyLabel.text = warningString
        descriptionLabel.text = String(copy)
    }
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        removeAnimate()
    }


    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        })
    }
    
    
}
