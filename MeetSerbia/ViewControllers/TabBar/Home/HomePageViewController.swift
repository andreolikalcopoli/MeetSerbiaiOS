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
        if logedInCheck() == true{
            initSetup()
        } else {
            let onboardingController =  UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "onbord") as? OnboardingViewControllerMain
            self.dismiss(animated: true)
            onboardingController?.modalPresentationStyle = .fullScreen
            present(onboardingController!, animated: true, completion: nil)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isExpanded = [Bool](repeating: false, count: 12)
        homePageTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        homePageTableView.reloadData()
    
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
        
        if Constants().userDefKey == "cir" {
            cell?.testLabel.text = itemsArray[indexPath.row].category.uppercased()
            cell?.data = itemsArray[indexPath.row].subcategory
        } else if Constants().userDefKey == "lat" {
            cell?.testLabel.text = itemsArray[indexPath.row].categoryLat.uppercased()
            cell?.data = itemsArray[indexPath.row].subcategoryLat
        } else if Constants().userDefKey == "eng" {
            cell?.testLabel.text = itemsArray[indexPath.row].categoryEng.uppercased()
            cell?.data = itemsArray[indexPath.row].subcategoryEng
        }else {
            cell?.testLabel.text = itemsArray[indexPath.row].category.uppercased()
            cell?.data = itemsArray[indexPath.row].subcategory
        }
        cell?.imageHolder.image = UIImage(named: itemsArray[indexPath.row].categoryImageData)
        

        
        cell?.vc = self
        cell?.allData = itemsArray
        cell?.holderTView.isHidden = !itemsArray[indexPath.row].expanded
        cell?.hidencell.text = itemsArray[indexPath.row].categoryLat
        cell?.selectionStyle = .none
        
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
            self.dismiss(animated: true)
            navigationController?.pushViewController(viewController!, animated: true)
        }
    }
    private func logedInCheck()->Bool {
        if Constants().userDefLoginKey == true {
            return true
        } else {
            return false
        }
    }
    
}
