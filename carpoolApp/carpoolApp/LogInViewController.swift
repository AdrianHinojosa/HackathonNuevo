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
    
    // nombre es pasado al siguiente segue para que se guarde el dato en LocationObj
    var newNombre: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.retrieveUserName()
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    

    func retrieveUserName() {
        let databaseRef = Database.database().reference().child("usuarios")
        let userID = Auth.auth().currentUser?.uid
        print("Checking user...")
        databaseRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let currentUser = Persona(snapshot: snapshot)
            self.newNombre = currentUser.nombre!
            print("Nombre Login:", self.newNombre!)
            self.performSegue(withIdentifier: "goToHome2", sender: self)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToHome2") {
            let mapVC = segue.destination as! MapViewController
            mapVC.newNombre = newNombre
        }
    }
 

}
