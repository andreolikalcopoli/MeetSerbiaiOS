//
//  HomePage.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import Foundation
import UIKit
class HomePageViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    
    var isExpanded: [Bool] = [Bool](repeating: false, count: 12)
    var itemsArray = [DataModel]()
  
    @IBOutlet weak var homePageTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
        
    }
    private func initSetup(){
        getData()
        homePageTableView.dataSource = self
        homePageTableView.delegate = self
        
        homePageTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homePageTableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell
        cell?.imageHolder.image = UIImage(named: itemsArray[indexPath.row].categoryImageData) 
        cell?.testLabel.text = itemsArray[indexPath.row].category
        cell?.vc = self
        cell?.holderTView.isHidden = !itemsArray[indexPath.row].expanded
        cell?.hidencell.text = itemsArray[indexPath.row].categoryLat
        cell?.selectionStyle = .none
        cell?.data = itemsArray[indexPath.row].subcategory
        cell?.imageData = itemsArray[indexPath.row].imageData
        return cell!
    }
    
    func getData() {
        itemsArray = Data().items
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return isExpanded[indexPath.row] ? 1870 : 187
        } else if indexPath.row == 1 {
            return isExpanded[indexPath.row] ? 187 : 187
        } else if indexPath.row == 2 {
            return isExpanded[indexPath.row] ? 187 : 187
        } else if indexPath.row == 3 {
            return isExpanded[indexPath.row] ? 1870 : 187
        } else if indexPath.row == 4 {
            return isExpanded[indexPath.row] ? 2057 : 187
        } else if indexPath.row == 5 {
            return isExpanded[indexPath.row] ? 1496 : 187
        } else if indexPath.row == 6 {
            return isExpanded[indexPath.row] ? 2431 : 187
        } else if indexPath.row == 7 {
            return isExpanded[indexPath.row] ? 187 : 187
        } else if indexPath.row == 8 {
            return isExpanded[indexPath.row] ? 1309 : 187
        } else if indexPath.row == 9 {
            return isExpanded[indexPath.row] ? 1309 : 187
        } else if indexPath.row == 10 {
            return isExpanded[indexPath.row] ? 748 : 187
        } else if indexPath.row == 11 {
            return isExpanded[indexPath.row] ? 2805 : 187
        }   else {
            return isExpanded[indexPath.row] ? 250 : 187
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isExpanded[indexPath.row] = !isExpanded[indexPath.row]
        homePageTableView.reloadRows(at: [indexPath], with: .automatic)
        let selectedCell = homePageTableView.cellForRow(at: indexPath) as! TableViewCell
        selectedCell.holderTView.reloadData()
        if selectedCell.holderTView.isHidden == true {
            selectedCell.holderTView.isHidden = false
        } else {
            selectedCell.holderTView.isHidden = true
        }
            
            if isExpanded[indexPath.row] {
                selectedCell.arrowImage.transform = CGAffineTransform(rotationAngle: .pi/2)
            } else {
                selectedCell.arrowImage.transform = CGAffineTransform.identity
            }
        if(indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 7){
            let viewController =  UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FMT") as? FilteredMapViewController
            viewController?.category = selectedCell.hidencell.text!
            navigationController?.pushViewController(viewController!, animated: true)
        }
    }

}
