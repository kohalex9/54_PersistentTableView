//
//  FootballTeamTableViewCell.swift
//  54_TableViewPersistent
//
//  Created by Alex Koh on 25/08/2017.
//  Copyright © 2017 AlexKoh. All rights reserved.
//

import UIKit

class FootballTeamTableViewCell: UITableViewCell {

    @IBOutlet weak var managerLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    
    @IBOutlet weak var homeStadiumLabel: UILabel!
    
    @IBOutlet weak var yearFoundedLabel: UILabel!
    
    @IBOutlet weak var goalKeeperLabel: UILabel!
    
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var leagueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
