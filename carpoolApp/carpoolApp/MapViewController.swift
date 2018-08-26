//
//  MapViewController.swift
//  carpoolApp
//
//  Created by Corde Lopez on 8/25/18.
//  Copyright © 2018 Corde Lopez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate {
    // map view variables
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    // location
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var acceptedRadius = 0.0
    
    // firebase
    var dbReference: DatabaseReference!
    var newNombre = ""
    var loggedUser: Persona!
    
    @IBAction func logOutBT(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            
        }
        catch{
            print("Error signing out")
        }
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else{
                print("No VC to pop off")
                return
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        print("Nombre Login:", newNombre )
        // Permiso para utilizar ubicacion
        locationManager.requestWhenInUseAuthorization()
        startMap()
    }

    // MARK: - Mapa
    // inicializa el mapa y lo demuestra al usuario. Al usuario le aparece su ubicacion actual y agarra sus coordenadas
    func startMap() {
        mapView.delegate = self
        
        if(CLLocationManager.locationServicesEnabled()) {
            // setup
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // cases
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("Location access denied")
                break
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Location access allowed")
                
                // coordenadas del usuario
                if let sourceCoor = locationManager.location?.coordinate {
                    let sourcePlacemark = MKPlacemark(coordinate: sourceCoor)
                    let sourceItem = MKMapItem(placemark: sourcePlacemark)
                    
                    // view del mapa
                    latitude = (sourceCoor.latitude)
                    longitude = (sourceCoor.longitude)
                    // tamano de la ventana
                    let lanDelta: CLLocationDegrees = 0.05
                    let lonDelta: CLLocationDegrees = 0.05
                    let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
                    let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let region = MKCoordinateRegion(center: coordinates, span: span)
                    mapView.setRegion(region, animated: true)
                    
                    mapView.showsUserLocation = true
                    uploadUserCoordinates()
                    
                }
                
                break
            }
            
        } else {
            print("Location services are not enabled")
            // avisa al usuario que no tiene activado la ubicacion
            let alertVC = UIAlertController(title: "Ubicación no activada", message: "No se tiene activada la ubicación", preferredStyle: .alert)
            
            let alertActionOkay = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alertVC.addAction(alertActionOkay)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - RADIUS
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, mapView: MKMapView) {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        let circle = MKCircle(center: coordinate, radius: radius)
        mapView.addOverlays([circle])
    }
    
    
    @IBOutlet weak var UnKmColor: UIButton!
    
    @IBAction func UnKm(_ sender: Any) {
        UnKmColor.backgroundColor = UIColor.blue
        TresKmColor.backgroundColor = nil
        CincoKmColor.backgroundColor = nil
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        acceptedRadius = 1.0
        
        showCircle(coordinate: coordinates, radius: 750, mapView: mapView)
    }
    
    
    @IBOutlet weak var TresKmColor: UIButton!
    
    @IBAction func TresKm(_ sender: Any) {
        TresKmColor.backgroundColor = UIColor.blue
        UnKmColor.backgroundColor = nil
        CincoKmColor.backgroundColor = nil
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        acceptedRadius = 3.0
        
        showCircle(coordinate: coordinates, radius: 2250, mapView: mapView)
    }
    
    
    @IBOutlet weak var CincoKmColor: UIButton!
    
    @IBAction func CincoKm(_ sender: Any) {
        CincoKmColor.backgroundColor = UIColor.blue
        UnKmColor.backgroundColor = nil
        TresKmColor.backgroundColor = nil
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        acceptedRadius = 5.0
        
        showCircle(coordinate: coordinates, radius: 3750, mapView: mapView)
    }
    
    // MARK: - Firebase
    
    // funcion que sube la coordenadas del usuario a la base de datos si es la primera vez
    func uploadUserCoordinates() {
        print("Uploading user coordinates...")
        self.dbReference = Database.database().reference().child("locations")
        
        if let userId = Auth.auth().currentUser?.uid  {
            // sube el objeto con su informacion, hace una key automatica
            let key = userId
            let location = ["latitude": String(self.latitude), "longitude": String(self.longitude), "description": "Direccion", "name": newNombre]
            let childUpdates = ["/\(key)": location]
            self.dbReference.updateChildValues(childUpdates)
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToMatches") {
            let matchesTableVC = segue.destination as! MatchesTableViewController
            matchesTableVC.acceptedRadius = acceptedRadius
            matchesTableVC.loggedUser = loggedUser
        }
    }
 

}

// EXTENSION RADIUS

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // If you want to include other shapes, then this check is needed. If you only want circles, then remove it.
        let circleOverlay = overlay as? MKCircle
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay!)
        circleRenderer.fillColor = UIColor.blue
        circleRenderer.alpha = 0.1
        
        return circleRenderer
        
    }
}
