//
//  ProfileViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import Foundation
import UIKit
import FirebaseStorage
import Firebase
class ProfileViewController:UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    private let uuid = UserDefaults.standard.string(forKey: "uid")
    let refrence = Database.database().reference()
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    var imageType: String?
    private var userDef = UserDefaults.standard
    @IBOutlet weak var cirImage: UIImageView!
    @IBOutlet weak var engImage: UIImageView!
    @IBOutlet weak var latImage: UIImageView!
    let vc = HomePageViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
        
    }
    private func uiSetup(){
        if Constants().userDefKey == "eng" {
            cirImage.alpha = 0.7
            latImage.alpha = 0.7
            engImage.alpha = 1
        } else if Constants().userDefKey == "lat"{
            cirImage.alpha = 0.7
            latImage.alpha = 1
            engImage.alpha = 0.7
        }
        else if Constants().userDefKey == "cir"{
            cirImage.alpha = 1
            latImage.alpha = 0.7
            engImage.alpha = 0.7
        } else {
            cirImage.alpha = 1
            latImage.alpha = 0.7
            engImage.alpha = 0.7
        }
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        let cirTap = UITapGestureRecognizer(target: self, action: #selector(cirTapped))
        let latTap = UITapGestureRecognizer(target: self, action: #selector(latTapped))
        let engTap = UITapGestureRecognizer(target: self, action: #selector(engTapped))
        
        profileImageView.addGestureRecognizer(profileTapGesture)
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        let coverTapGesture = UITapGestureRecognizer(target: self, action: #selector(coverImageTapped))
        coverImageView.addGestureRecognizer(coverTapGesture)
        coverImageView.isUserInteractionEnabled = true
        profileImageView.isUserInteractionEnabled = true
        cirImage.addGestureRecognizer(cirTap)
        latImage.addGestureRecognizer(latTap)
        engImage.addGestureRecognizer(engTap)
        cirImage.isUserInteractionEnabled = true
        latImage.isUserInteractionEnabled = true
        engImage.isUserInteractionEnabled = true
        getData()
    }
    
    private func getData() {
        refrence.child("users").child(uuid!).child("data").getData { error, snapshot in
            if let error = error {
                print("Error getting data: \(error.localizedDescription)")
                return
            }
            
            guard let dict = snapshot?.value as? [String: Any] else {
                print("Invalid snapshot data")
                return
            }
            
            if let name = dict["name"] as? String {
                self.nameLabel.text = name
                self.imageSet()
            }
            
        }
    }
    private func imageSet(){
        let profileImageRef = Storage.storage().reference().child("images/\(uuid ?? "")/profile.jpg")
        let coverImageRef = Storage.storage().reference().child("images/\(uuid ?? "")/cover.jpg")
        coverImageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading cover image: \(error.localizedDescription)")
            } else {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    
                    self.coverImageView.image = image
                }
            }
        }
        profileImageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading cover image: \(error.localizedDescription)")
            } else {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    
                    // Set the image to your cover ImageView
                    self.profileImageView.image = image
                }
            }
        }
        
    }
    
    @objc func profileImageTapped() {
        presentImagePicker(for: "profile")
    }
    
    @objc func coverImageTapped() {
        presentImagePicker(for: "cover")
    }
    
    @objc func engTapped() {
        userDef.set("eng", forKey: "Language")
        firstButton.setTitle(Constants().memoriesTabArray[2], for: .normal)
        secondButton.setTitle(Constants().roomsArray[2], for: .normal)
        thirdButton.setTitle(Constants().postsArray[2], for: .normal)
        fourthButton.setTitle(Constants().membershipArray[2], for: .normal)
        cirImage.alpha = 0.7
        latImage.alpha = 0.7
        engImage.alpha = 1
    }
    
    @objc func latTapped() {
        userDef.set("lat", forKey: "Language")
        firstButton.setTitle(Constants().memoriesTabArray[1], for: .normal)
        secondButton.setTitle(Constants().roomsArray[1], for: .normal)
        thirdButton.setTitle(Constants().postsArray[1], for: .normal)
        fourthButton.setTitle(Constants().membershipArray[1], for: .normal)
        cirImage.alpha = 0.7
        latImage.alpha = 1
        engImage.alpha = 0.7
    }
    
    @objc func cirTapped() {
        userDef.set("cir", forKey: "Language")
        firstButton.setTitle(Constants().memoriesTabArray[0], for: .normal)
        secondButton.setTitle(Constants().roomsArray[0], for: .normal)
        thirdButton.setTitle(Constants().postsArray[0], for: .normal)
        fourthButton.setTitle(Constants().membershipArray[0], for: .normal)
        cirImage.alpha = 1
        latImage.alpha = 0.7
        engImage.alpha = 0.7
    }
    func presentImagePicker(for imageType: String) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: {
            self.imageType = imageType // Store the image type in a variable for later use
        })
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage, let imageType = self.imageType else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        if imageType == "profile" {
            profileImageView.image = image
            uploadImage(uid: uuid!, image: image, type: "profile")
        } else if imageType == "cover" {
            coverImageView.image = image
            uploadImage(uid: uuid!, image: image, type: "cover")
        }
        
        dismiss(animated: true, completion: nil)
    }
    private func uploadImage(uid:String,image:UIImage,type:String){
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let storageRef = Storage.storage().reference().child("images/\(uid)/\(type).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                print("Image uploaded successfully")
                
            }
        }
    }
}
