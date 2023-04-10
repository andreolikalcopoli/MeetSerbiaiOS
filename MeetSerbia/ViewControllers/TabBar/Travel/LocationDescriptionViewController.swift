//
//  LocationViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import AVFoundation
import AVKit
import SDWebImage

class LocationDescriptionViewController:UIViewController{
    
    @IBOutlet weak var sampleImageView: UIImageView!
    @IBOutlet weak var sampleTextHolder: UITextView!
    private let refrence = Database.database().reference()
    private let storageRef = Storage.storage().reference()
    private var imageUrls = [URL]()
    @IBOutlet weak var playerViewHolder: UIView!
    var imageNumber = 0
    private var maxNumber = 0
    var id = ""
    var player: AVPlayer?
       var playerLayer: AVPlayerLayer?
       var videoURL: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
        
        
    }
    private func initSetup(){
        let videoGesture = UISwipeGestureRecognizer(target: self, action: #selector(vGesture(_:)))
        videoGesture.direction = . left
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .left
        playerViewHolder.isHidden = true
        sampleTextHolder.isUserInteractionEnabled = false
        refrence.child("locations").child(id).getData { er, snap in
            if er != nil {
                return
            } else {
                guard let values = snap?.value as? [String:Any] else  {return}
                self.sampleTextHolder.text =  values["description"] as? String ?? ""
                let video = values["video"] as? String ?? ""
                let images = values["images"] as? [String]
                self.maxNumber = images!.count
                self.storageRef.child("images/locations/\(self.id)").listAll { res, err in
                    if er != nil {
                        return
                    } else {
                        
                        for item in res!.items {
                            print(res?.items as Any)
                                    item.downloadURL { (url, error) in
                                        if let error = error {
                                            print("Error getting download URL: \(error)")
                                        } else if let url = url {
                                            self.imageUrls.append(url)
                                            self.sampleImageView.sd_setImage(with: self.imageUrls[0])
                                        }
                                    }
                                }
                    }
                }
                
                if video == "novideo" {
                    self.view.addGestureRecognizer(swipeGesture)
                }
                else {
                    self.playerViewHolder.isHidden = false
                    self.imageUrls.insert(URL(fileURLWithPath: video), at: 0)
                    self.view.addGestureRecognizer(videoGesture)
                    self.storageRef.child(video).downloadURL(completion: {[weak self] url, error in
                        if let error = error {
                            print("Error downloading video: \(error)")
                        } else {
                            self?.videoURL = url
                            self?.playVideo()

                        }
                    })
                    
                }

            }
        }
    }
    func playVideo() {
        guard let videoURL = self.videoURL else {
            return
        }
        
        // Create an AVPlayer instance
        self.player = AVPlayer(url: videoURL)
        
        // Create an AVPlayerLayer instance and add it to the player view's layer hierarchy
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.frame = self.playerViewHolder.bounds
        self.playerViewHolder.layer.addSublayer(self.playerLayer!)
        
        // Start playing the video
        self.player?.play()
    }
    private func hasVideo(){
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update the player layer's frame when the player view's bounds change
        self.playerLayer?.frame = self.playerViewHolder.bounds
    }
    @objc func vGesture(_ gesture: UISwipeGestureRecognizer) {
        playerViewHolder.isHidden = true
        self.player?.pause()

        if imageNumber == maxNumber - 1 {
            imageNumber = 0
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .reveal
            playerViewHolder.isHidden = false
            self.player?.play()

            playerViewHolder.layer.add(transition, forKey: kCATransition)
            
            sampleImageView.sd_setImage(with: imageUrls[1])
                
        } else {
            imageNumber += 1

            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .reveal
            sampleImageView.layer.add(transition, forKey: kCATransition)
            sampleImageView.sd_setImage(with: imageUrls[imageNumber + 1])

        }
        
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
       
        if imageNumber == maxNumber-1 {
            imageNumber = 0
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .reveal
            sampleImageView.layer.add(transition, forKey: kCATransition)
            
            sampleImageView.sd_setImage(with: imageUrls[0])
                
        } else {
            imageNumber += 1

            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .reveal
            print(imageNumber)
            sampleImageView.layer.add(transition, forKey: kCATransition)
            sampleImageView.sd_setImage(with: imageUrls[imageNumber])

        }
     
        
    }
    deinit {
        // Pause and remove the player when the view controller is deallocated
        self.player?.pause()
        self.playerLayer?.removeFromSuperlayer()
    }
}
