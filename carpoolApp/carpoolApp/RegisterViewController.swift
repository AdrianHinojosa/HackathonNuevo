//
//  RegisterViewController.swift
//  carpoolApp
//
//  Created by Corde Lopez on 8/25/18.
//  Copyright © 2018 Corde Lopez. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passTF: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerBT(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTF.text!, password: passTF.text!) { (user, error) in
            if error != nil{
                print("error!")
            }
            else{
                print("registration successful")
                self.performSegue(withIdentifier: "goToSettings1", sender: self)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
