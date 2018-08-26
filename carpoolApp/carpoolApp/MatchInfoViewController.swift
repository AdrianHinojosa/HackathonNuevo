//
//  MatchInfoViewController.swift
//  carpoolApp
//
//  Created by Fernando Carrillo on 8/25/18.
//  Copyright © 2018 Corde Lopez. All rights reserved.
//

import UIKit

class MatchInfoViewController: UIViewController {
    // variables passed from past view controller
    var location: LocationObj!
    
    // view variables
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // loads the view with the data
        loadData()
    }

    
    func loadData() {
        descriptionLabel.text = location.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
