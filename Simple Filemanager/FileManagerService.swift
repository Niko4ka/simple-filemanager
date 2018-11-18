//
//  FileManagerService.swift
//  Simple Filemanager
//
//  Created by Вероника Данилова on 14/11/2018.
//  Copyright © 2018 Veronika Danilova. All rights reserved.
//

import Foundation
import CoreServices

final class FileManagerService {
    
    private let directory = "Documents"
    private var directoryPath: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    public func listFiles(in currentDirectoryPath: String) -> [Document] {
        
        var documents: [Document] = []
        
        guard let path = directoryPath?.path else {
            return documents
        }
        
        let filePath = path + currentDirectoryPath

        guard let directory = try? FileManager.default.contentsOfDirectory(atPath: filePath) else {
            return documents
        }

        for file in directory {

            if file.hasPrefix(".") {
                continue
            }

            if file.contains(".") {
                let document = Document(documentType: .file, documentName: file, filePath: currentDirectoryPath)
                documents.append(document)
            } else {
                let document = Document(documentType: .directory, documentName: file, filePath: currentDirectoryPath)
                documents.append(document)
            }
        }

        sortFilesByTypeAndName(in: &documents)
        return documents
    }
    
    public func writeFile(ofType fileType: Document.documentType, containing: String?, withName fileName: String, toDirectory currentDirectoryPath: String) -> Bool {
        
        guard let path = directoryPath?.path else {
            return false
        }
        let filePath = path + currentDirectoryPath + "/" + fileName
        
        switch fileType {
        case .file:
            let rawData: Data? = containing?.data(using: .utf8)
            FileManager.default.createFile(atPath: filePath, contents: rawData, attributes: nil)
        case .directory:
            
            do {
                try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: false, attributes: nil)
            } catch {
                return false
            }
        }
        return true
    }
    
    public func readFile(withName fileName: String, inDirectory currentDirectoryPath: String) -> String? {
        guard let path = directoryPath?.path else {
            return nil
        }
        let filePath = path + currentDirectoryPath + "/" + fileName
        
        guard let fileContent = FileManager.default.contents(atPath: filePath),
            let fileContentEncoded = String(bytes: fileContent, encoding: .utf8) else {
                return nil
        }
        
        return fileContentEncoded
    }
    
    public func deleteFile(withName fileName: String, inDirectory currentDirectoryPath: String) -> Bool {
        
        guard let path = directoryPath?.path else {
            return false
        }
        let filePath = path + currentDirectoryPath + "/" + fileName

        do {
            try FileManager.default.removeItem(atPath: filePath)
        } catch {
            return false
        }
        return true
    }
    
    private func sortFilesByTypeAndName(in array: inout [Document]) {
        
        array.sort { $0.name.localizedCompare($1.name) == .orderedAscending}
        
        array.sort { (firstItem, secondItem) -> Bool in
            if firstItem.type == .directory && secondItem.type == .file {
                return true
            } else {
                return false
            }
        }
    }

}
