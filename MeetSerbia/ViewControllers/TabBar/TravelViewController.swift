//
//  TravelViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import Foundation
import UIKit

class TravelViewController:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func click(_ sender: Any) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ldscVC") as! LocationDescriptionViewController

        navigationController?.pushViewController(next, animated: true)
    }
}
