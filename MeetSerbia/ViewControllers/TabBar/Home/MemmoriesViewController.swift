//
//  MemmoriesViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import Foundation
import UIKit

class MemmoriesViewController : UIViewController,UITableViewDelegate,UITableViewDataSource {
    let dateArray = ["23. МАЈ 2023 - БАЊСКА СТЕНА"]
    let descArray = ["Прелепо дружење са пријатељима и породицом!"]
    let profileImages = [UIImage(named: "placeholder_profile")]
    let memmoryImages = [UIImage(named: "holder_memmory")]
    @IBOutlet weak var memmoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }
    private func initSetup(){
        memmoriesTableView.register(UINib(nibName: "MemmoryTableViewCell", bundle: nil), forCellReuseIdentifier: "memmoryCell")
        memmoriesTableView.delegate = self
        memmoriesTableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memmoriesTableView.dequeueReusableCell(withIdentifier: "memmoryCell", for: indexPath) as! MemmoryTableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}
