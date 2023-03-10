//
//  RegisterViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import Foundation
import UIKit

class RegisterViewController:UIViewController{
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
    }
    
    private func uiSetup(){
        nameTextField.setupImageRight(image: "checkmark")
        emailTextField.setupImageRight(image: "checkmark")
        passwordTextField.setupImageRightLong(image: "eye")
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toMain", sender: nil)
    }
    
}
extension UITextField {
    func setupImageRight(image:String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: image)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        container.addSubview(imageView)
        rightView = container
        rightViewMode = .always
        self.tintColor = .lightGray
    }
    func setupImageRightLong(image:String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 20))
        imageView.image = UIImage(named: image)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        container.addSubview(imageView)
        rightView = container
        rightViewMode = .always
        self.tintColor = .lightGray
    }
    
    
}
