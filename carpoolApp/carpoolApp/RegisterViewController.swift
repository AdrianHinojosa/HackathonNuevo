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
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
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
                self.handleError(error: error! as NSError)
            }
            else{
                print("registration successful")
                self.performSegue(withIdentifier: "goToSettings1", sender: self)
            }
        }
    }
    
    // error handling
    func handleError(error: NSError) {
        print(error.debugDescription)
        //SVProgressHUD.dismiss()
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch (errorCode) {
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential:
                self.errorLabel.text = "El email ya está registrado"
                print("email already in use")
                break
            case .invalidEmail:
                errorLabel.text = "El email ingresado es inválido, verifique que su email este escrito correctamente"
                print("invalid email")
                break
            case .wrongPassword, .weakPassword:
                errorLabel.text = "Contraseña inválida, use 6 caracteres o más"
                print("invalid or weak password")
                break
            default:
                errorLabel.text = "Error"
                print("Unknown error")
                break
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
