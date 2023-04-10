//
//  MemmoriesViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import Foundation
import UIKit
import Firebase
import SDWebImage
import Kingfisher
import FirebaseStorage

class MemmoriesViewController : UIViewController,UITableViewDelegate,UITableViewDataSource {
    let dateArray = ["23. МАЈ 2023 - БАЊСКА СТЕНА"]
    let descArray = ["Прелепо дружење са пријатељима и породицом!"]
    let profileImages = [UIImage(named: "placeholder_profile")]
    let memmoryImages = [UIImage(named: "holder_memmory")]
    private let refrence = Database.database().reference()
    private let storageRef = Storage.storage().reference().child("images/memories")
    let id = UserDefaults.standard.string(forKey: "uid")
    private var memoriesArray = [MemoryModel()]
    @IBOutlet weak var memmoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }
    private func initSetup(){
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onBackPressed))
        memmoriesTableView.register(UINib(nibName: "MemmoryTableViewCell", bundle: nil), forCellReuseIdentifier: "memmoryCell")
        memmoriesTableView.delegate = self
        memmoriesTableView.dataSource = self
        getYourMemories()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memmoriesTableView.dequeueReusableCell(withIdentifier: "memmoryCell", for: indexPath) as! MemmoryTableViewCell
        cell.memmoryImageView.sd_setImage(with: URL(string: memoriesArray[indexPath.row].id))
        storageRef.child(memoriesArray[indexPath.row].id).getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                // Handle error
                print("Error downloading image: \(error.localizedDescription)")
            } else {
                // Load image into UIImageView or other UI element
                if let imageData = data, let image = UIImage(data: imageData) {
                    cell.memmoryImageView.image = image
                    print(image)
                } else {
                    print("Error loading image data")
                }
            }
        }
        cell.desriptionLabel.text = memoriesArray[indexPath.row].description
        cell.dateAndLocationLabel.text = memoriesArray[indexPath.row].location


        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    private func getYourMemories(){
        refrence.child("users").child(id!).child("memories").observe(.value,with: { snap in
            self.memoriesArray.removeAll()
            
            for (_,val) in snap.value as? [String: Any] ?? [:] {
                
                if let memoryData = val as? [String: Any] {
                    
                    let description = memoryData["description"] as? String ?? ""
                    let location = memoryData["location"] as? String ?? ""
                    let id = memoryData["uid"] as? String ?? ""
                    
                    let memoryModel = MemoryModel(description: description,location: location,id: id+".jpg" )
                  self.memoriesArray.append(memoryModel)
                    self.memmoriesTableView.reloadData()
                    
                }
            }
        })
    }
    @objc func onBackPressed(){
        self.dismiss(animated: true)
    }
}
