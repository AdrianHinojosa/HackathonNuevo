//
//  LogInViewController.swift
//  carpoolApp
//
//  Created by Corde Lopez on 8/25/18.
//  Copyright © 2018 Corde Lopez. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    var newKey: String!
    var newNombre: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInBT(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
                        
            } else{
                print ("Log in successful!")
                self.newKey = Auth.auth().currentUser?.uid
                self.performSegue(withIdentifier: "goToHome2", sender: self)
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toMapVC") {
            let mapVC = segue.destination as! MapViewController
            mapVC.newNombre = newNombre
            mapVC.newKey = newKey
        }
    }
 

}
