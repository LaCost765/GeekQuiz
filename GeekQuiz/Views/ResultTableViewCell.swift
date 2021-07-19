//
//  ResultTableViewCell.swift
//  GeekQuiz
//
//  Created by Egor on 18.07.2021.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var prizeLabel: UILabel!
    @IBOutlet weak var hallHelpButton: UIButton!
    @IBOutlet weak var fiftyFiftyButton: UIButton!
    @IBOutlet weak var friendCallButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureResult(with result: GameResult) {
        nameLabel.text = result.name
        dateLabel.text = result.date
        prizeLabel.text = "\(result.prize) $"
        
        hallHelpButton.isEnabled = !result.isHallHelpUsed
        fiftyFiftyButton.isEnabled = !result.isFiftyFiftyUsed
        friendCallButton.isEnabled = !result.isFriendCallUsed
    }
}
