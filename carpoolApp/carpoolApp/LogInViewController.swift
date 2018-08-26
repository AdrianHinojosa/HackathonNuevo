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
    
    // view Variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    // nombre es pasado al siguiente segue para que se guarde el dato en LocationObj
    var newNombre: String!
    var loggedUser: Persona!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hides error label
        errorLabel.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // buttons
    @IBAction func logInBT(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
                self.handleError(error: error! as NSError)
                        
            } else{
                print ("Log in successful!")
                self.retrieveUserName()
            }
        }
    }
    
    // forgot password button
    @IBAction func forgotPasssword(_ sender: Any) {
        if(emailTextField.text == "") {
            errorLabel.text = "Agregue su email en espacio indicado"
            //SVProgressHUD.dismiss()
            print("Missing email value")
        } else {
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
                if(error != nil) {
                    self.handleError(error: error! as NSError)
                } else {
                    self.passwordResetAlert()
                }
            }
        }
    }
    
    // MARK: - Errors
    // error handling for login
    func handleError(error: NSError) {
        //SVProgressHUD.dismiss()
        //print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch (errorCode) {
            case .userNotFound:
                errorLabel.text = "No se encontro el usuario, verifique que su email este escrito correctamente"
                print("user not found")
                break
            case .invalidEmail:
                errorLabel.text = "El email ingresado es inválido, verifique que su email este escrito correctamente"
                print("invalid email")
                break
            case .wrongPassword:
                errorLabel.text = "Contraseña incorrecta"
                print("wrong password")
            default:
                errorLabel.text = "Error"
                print("Unknown error")
                break
            }
        }
    }
    
    // alert to request password reset
    func passwordResetAlert() {
        //SVProgressHUD.dismiss()
        // password reset sent successfully alert
        let alertVC = UIAlertController(title: "Email enviado", message: "Se envió el mail para recuperar la contraseña a \(self.emailTextField.text ?? "---").", preferredStyle: .alert)
        
        let alertActionOkay = UIAlertAction(title: "Ok", style: .default) {
            (_) in
            Auth.auth().currentUser?.sendEmailVerification(completion: nil)
        }
        
        alertVC.addAction(alertActionOkay)
        self.present(alertVC, animated: true, completion: nil)
        print("Password reset sent")
    }

    // retrieves user data
    func retrieveUserName() {
        let databaseRef = Database.database().reference().child("usuarios")
        let userID = Auth.auth().currentUser?.uid
        print("Retrieving user...")
        databaseRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let currentUser = Persona(snapshot: snapshot)
            self.loggedUser = currentUser
            self.newNombre = currentUser.nombre!
            self.performSegue(withIdentifier: "goToHome2", sender: self)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToHome2") {
            let mapVC = segue.destination as! MapViewController
            mapVC.newNombre = newNombre
            mapVC.loggedUser = loggedUser
        }
    }
 

}
