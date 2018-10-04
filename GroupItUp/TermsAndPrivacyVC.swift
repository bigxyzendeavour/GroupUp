//
//  TermsAndPrivacyVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-06-07.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class TermsAndPrivacyVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var displayText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = displayText
    }

    

}
