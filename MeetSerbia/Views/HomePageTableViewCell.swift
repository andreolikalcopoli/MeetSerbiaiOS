//
//  HomePageTableViewCell.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import UIKit

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var selfImage: UIImageView!
    @IBOutlet weak var stringLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
