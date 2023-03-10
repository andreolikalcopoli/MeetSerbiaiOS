//
//  HomePage.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import Foundation
import UIKit

class HomePageViewController:UIViewController,UITableViewDelegate,UITableViewDataSource {

    let stringArray = ["Градови","Природa","Религија","Традиција","Историја","Храна","Гостољубивост"]
    let imageArray = [UIImage(named: "cities"),UIImage(named: "nature"),UIImage(named: "religion"),UIImage(named: "tradition"),UIImage(named: "history"),UIImage(named: "foodCell"),UIImage(named: "hospitality")]
    
    @IBOutlet weak var homePageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }
    private func initSetup(){
        homePageTableView.dataSource = self
        homePageTableView.delegate = self
        homePageTableView.register(UINib(nibName: "HomePageTableViewCell", bundle: nil), forCellReuseIdentifier: "homePageCell")

        
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homePageTableView.dequeueReusableCell(withIdentifier: "homePageCell", for: indexPath) as! HomePageTableViewCell
        cell.selfImage.image = imageArray[indexPath.row]
        cell.stringLabel.text = stringArray[indexPath.row]
        return cell
    }
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
