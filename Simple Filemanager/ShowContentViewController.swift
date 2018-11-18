//
//  ShowContentViewController.swift
//  Simple Filemanager
//
//  Created by Вероника Данилова on 15/11/2018.
//  Copyright © 2018 Veronika Danilova. All rights reserved.
//

import UIKit

class ShowContentViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    var fileContent: String!
    var fileName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.text = fileContent
        self.navigationItem.title = fileName
    }
    
}
