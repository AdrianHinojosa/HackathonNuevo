//
//  SettingsViewController.swift
//  carpoolApp
//
//  Created by Fernando Carrillo on 8/26/18.
//  Copyright © 2018 Corde Lopez. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class SettingsViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    // persona data
    var nombre : String!
    var celular: String!
    var numHijos: String!
    var numPas: String!
    var entrada: String!
    var salida: String!
    var dbReference: DatabaseReference!
    
    // informacion que se va a pasar a MapVC
    var newNombre: String!
    var loggedUser: Persona!
    
    var locationManager = CLLocationManager()
    
    // esconde el teclado
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    // adrian adrian
    @IBOutlet weak var UINom: UITextField!
    @IBOutlet weak var UICelular: UITextField!
    @IBOutlet weak var UINumHijos: UITextField!
    @IBOutlet weak var UINumPasajeros: UITextField!
    @IBOutlet weak var UIHoraEntrada: UIDatePicker!
    @IBOutlet weak var UIHoraSalida: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        scrollView.keyboardDismissMode = .onDrag
        // pide acceso a la ubicacion del usuario
        retrieveUsername()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadData(_ sender: Any) {
        if (checkTF()){
            print("text fields ok")
            updateDatabase()
        }
        else{
            print("missing info in text fields")
        }
        
    }
    
    
    func updateDatabase (){
        dbReference = Database.database().reference().child("usuarios")
        
        if let user = Auth.auth().currentUser{
            let key = user.uid
            let persona = ["name": nombre, "celular": celular, "numChildren": numHijos, "numPassengers": numPas, "entryHour": entrada, "outHour": salida]
            newNombre = nombre
            
            let childUpdates = ["/\(key)": persona]
            dbReference.updateChildValues(childUpdates)
            
            self.performSegue(withIdentifier: "toMapVC", sender: self)
            
            print("upload to database complete")
        }
        
        
    }
    
    // checa que este todo completo
    func checkTF()->Bool{
        if(UINom.text! != "" && UICelular.text! != "" && UINumHijos.text! != "" && UINumPasajeros.text! != ""){
            nombre = UINom.text!
            celular = UICelular.text!
            numHijos = UINumHijos.text!
            numPas = UINumPasajeros.text!
            let date = UIHoraEntrada.date
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mma"
            let stringDate = dateformatter.string(from: date)
            entrada = stringDate
            print(stringDate)
            
            let dateS = UIHoraSalida.date
            let dateformatterS = DateFormatter()
            dateformatterS.dateFormat = "hh:mma"
            let stringDateS = dateformatter.string(from: dateS)
            print(stringDateS)
            salida = stringDateS
            
            return true
        }
        
        
        return false
    }
    
    func retrieveUsername() {
        let databaseRef = Database.database().reference().child("usuarios")
        let userID = Auth.auth().currentUser?.uid
        print("Retrieving user...")
        databaseRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let currentUser = Persona(snapshot: snapshot)
            
            self.loggedUser = currentUser
            // self.performSegue(withIdentifier: "goToHome2", sender: self)
            
            self.UINom.text = currentUser.nombre
            self.UICelular.text = currentUser.celular
            self.UINumHijos.text = String(currentUser.numHijos)
            self.UINumPasajeros.text = String(currentUser.numPas)
            //  self.UIHoraEntrada.
            
            // HACER LOS HORARIOS
            // Horario entrada
            let fechaStringEntrada = currentUser.entrada
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mma"
            let fechaEntrada = dateformatter.date(from: fechaStringEntrada!)
            self.UIHoraEntrada.date = fechaEntrada!
            
            // Horario Salida
            let fechaStringSalida = currentUser.salida
            let dateformatterSalida = DateFormatter()
            dateformatterSalida.dateFormat = "hh:mma"
            let fechaSalida = dateformatterSalida.date(from: fechaStringSalida!)
            self.UIHoraSalida.date = fechaSalida!
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toMapVC") {
            let mapVC = segue.destination as! MapViewController
            mapVC.newNombre = newNombre
            mapVC.loggedUser = loggedUser
        }
    }
    
    
}
