//
//  NewGroupCompleteCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-22.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

protocol NewGroupCompleteCellDelegate {
    func completeCreatingGroup()
}

class NewGroupCompleteCell: UITableViewCell {
    
    var delegate: NewGroupCompleteCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func completeBtnPressed(_ sender: UIButton) {
        let delegate = self.delegate
        delegate?.completeCreatingGroup()
    }
}
