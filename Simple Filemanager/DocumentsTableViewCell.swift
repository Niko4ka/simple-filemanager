//
//  DocumentsTableViewCell.swift
//  Simple Filemanager
//
//  Created by Вероника Данилова on 14/11/2018.
//  Copyright © 2018 Veronika Danilova. All rights reserved.
//

import UIKit

class DocumentsTableViewCell: UITableViewCell {
    
    public var documentTypeInCell: Document.documentType = .directory
    public var path: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func setContent(with document: Document) {
        self.textLabel?.text = document.name
        self.path = document.path
        
        switch document.type {
        case .file:
            self.imageView?.image = UIImage(named: "file")
            self.documentTypeInCell = .file
        case .directory:
            self.imageView?.image = UIImage(named: "directory")
            self.documentTypeInCell = .directory
        }
    }

}
