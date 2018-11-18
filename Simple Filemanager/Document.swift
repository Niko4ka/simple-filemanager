//
//  Document.swift
//  Simple Filemanager
//
//  Created by Вероника Данилова on 14/11/2018.
//  Copyright © 2018 Veronika Danilova. All rights reserved.
//

struct Document {
    
    enum documentType {
        case file
        case directory
    }
    
    var type: documentType
    var name: String
    var path: String
    
    init(documentType: documentType, documentName: String, filePath: String) {
        self.type = documentType
        self.name = documentName
        self.path = filePath
    }
}
