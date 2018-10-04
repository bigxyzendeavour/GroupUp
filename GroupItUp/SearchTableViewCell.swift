//
//  SearchTableViewCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-28.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchOptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureCell(searchOption: String) {
        searchOptionLabel.text = searchOption
    }
}
