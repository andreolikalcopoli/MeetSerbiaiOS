//
//  TableViewCell.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 24.3.23..
//

import UIKit

class TableViewCell: UITableViewCell,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var imageHolder: UIImageView!
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var hidencell: UILabel!
    @IBOutlet weak var holderTView: UITableView!
    @IBOutlet weak var testLabel: UILabel!
    var data = [String]()
    var imageData = [String]()
    var vc = UIViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hidencell.isHidden = true
        // Configure the tableView
        holderTView.delegate = self
        holderTView.dataSource = self
        holderTView.register(UINib(nibName: "HomePageTableViewCell", bundle: nil), forCellReuseIdentifier: "homePageCell")
     }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = holderTView.dequeueReusableCell(withIdentifier: "homePageCell", for: indexPath) as! HomePageTableViewCell
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.font = UIFont(name:"Arial",size: 32)
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        let backgroundImageView = UIImageView(image: UIImage(named: imageData[indexPath.row]))
        backgroundImageView.contentMode = .scaleAspectFill
        cell.contentView.addSubview(backgroundImageView)
        cell.contentView.sendSubviewToBack(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController =  UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FMT") as? FilteredMapViewController
        viewController?.subCategory = data[indexPath.row]
        vc.navigationController?.pushViewController(viewController!, animated: true)
    }
   
}
