//
//  MatchesTableViewController.swift
//  carpoolApp
//
//  Created by Corde Lopez on 8/25/18.
//  Copyright © 2018 Corde Lopez. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase

class MatchesTableViewController: UITableViewController, CLLocationManagerDelegate {

    // location and distance variables
    let acceptedRadius: Double = 20047.722
    var locations = [LocationObj]()
    var matchLocations = [LocationObj]()
    var selectedLocation: LocationObj!
    
    // firebase
    var databaseRef: DatabaseReference!
    
    // table view
    var selectedIndex = 0
    
    // test variables
    let testUserCoordinates = CLLocation(latitude: 25.649058688015778, longitude: -100.28982410127462)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        // connects to database and retrieves data
        getLocations()
        
    }
    
    // MARK: - Firebase
    func getLocations() {
        databaseRef = Database.database().reference().child("Locations")
        databaseRef.observe(DataEventType.value) { (snapshot) in
            var newLocations = [LocationObj]()
        
            for snapshot in snapshot.children {
                let newLocation = LocationObj(snapshot: snapshot as! DataSnapshot)
                newLocations.append(newLocation)
            }
            self.locations = newLocations
            
            // gets matches
            self.getMatches()
        }
    }
    
    // MARK: - Distance
    
    // gets the locations that are close to the user
    func getMatches() {
        var distanceInKiloMeters = 0.0
        var auxLocation: CLLocation!
        // for loop to loop through all radius...
        for location in locations {
            auxLocation = CLLocation(latitude: location.lat, longitude: location.lon)
            distanceInKiloMeters = testUserCoordinates.distance(from: auxLocation) / 1000
            distanceInKiloMeters = Double(distanceInKiloMeters).roundTo(places: 3)
            print("Distance: ", distanceInKiloMeters)

            // agrega las ubicaciones que estan dentro del rango
            if(distanceInKiloMeters <= acceptedRadius) {
                matchLocations.append(location)
            }
        }
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    // number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchLocations.count
    }

    // name at row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = matchLocations[indexPath.row].name

        return cell
    }
    
    // index tapped by the user
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        selectedLocation = matchLocations[selectedIndex]
        performSegue(withIdentifier: "toMatchInfo", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toMatchInfo") {
            let matchInfoVC = segue.destination as! MatchInfoViewController
            matchInfoVC.location = selectedLocation
        }
    }
 

}

// redondea las decimales de un double
extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
