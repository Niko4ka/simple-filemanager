//
//  ViewController.swift
//  Simple Filemanager
//
//  Created by Вероника Данилова on 14/11/2018.
//  Copyright © 2018 Veronika Danilova. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController {
    
    @IBOutlet weak var documentsTableView: UITableView!
    public var documentsList: [Document] = []
    private var fileManager = FileManagerService()
    
    public var directoryName: String?
    public var currentPath: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = directoryName ?? "Documents"
        
        documentsTableView.register(DocumentsTableViewCell.self, forCellReuseIdentifier: "documentCell")
        documentsTableView.delegate = self
        documentsTableView.dataSource = self

        documentsList = fileManager.listFiles(in: currentPath)
    }
    
    
    @IBAction func addDirectory(_ sender: UIBarButtonItem) {
        showAlert(forDocumentType: .directory)
    }
    
    
    @IBAction func addFile(_ sender: UIBarButtonItem) {
        showAlert(forDocumentType: .file)
    }
    
    private func showAlert(forDocumentType docType: Document.documentType) {
        
        var fileContent: String?
        var alertTitle: String
        var fileName = ""
        
        switch docType {
        case .file:
            alertTitle = "File name"
            fileContent = "Hello, world!"
        case .directory:
            alertTitle = "Folder name"
        }
        
        let alertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let createAction = UIAlertAction(title: "Create", style: .default, handler: { action in
            if let textField = alertController.textFields?[0], let text = textField.text {
                if docType == .file && !text.contains(".") {
                    fileName = text + ".txt"
                } else {
                    fileName = text
                }
            }
            let fileCreated = self.fileManager.writeFile(ofType: docType, containing: fileContent, withName: fileName, toDirectory: self.currentPath)
            if fileCreated {
                self.documentsList = self.fileManager.listFiles(in: self.currentPath)
                self.documentsTableView.reloadData()
            } else {
                self.showErrorAlert(with: "Ooops... Couldn't create a new file")
            }
        })
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showErrorAlert(with message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = documentsTableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath) as! DocumentsTableViewCell
        cell.setContent(with: documentsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        documentsTableView.deselectRow(at: indexPath, animated: true)
        
        let cell = documentsTableView.cellForRow(at: indexPath) as! DocumentsTableViewCell
        guard let filename = cell.textLabel?.text else { return }
        let path = cell.path + "/" + filename
        
        switch cell.documentTypeInCell {
        case .directory:
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "documentsVC") as? DocumentsViewController {
                viewController.directoryName = filename
                viewController.currentPath = path

                if let navigator = self.navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
            
        case .file:
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "showContentVC") as? ShowContentViewController {
                viewController.fileContent = fileManager.readFile(withName: filename, inDirectory: self.currentPath)
                viewController.fileName = filename
                
                if let navigator = self.navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cell = documentsTableView.cellForRow(at: indexPath) as! DocumentsTableViewCell
        guard let fileName = cell.textLabel?.text else {
            return nil
        }

        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            let fileIsDeleted = self.fileManager.deleteFile(withName: fileName, inDirectory: cell.path)
            if fileIsDeleted {
                self.documentsTableView.beginUpdates()
                self.documentsList = self.fileManager.listFiles(in: self.currentPath)
                self.documentsTableView.deleteRows(at: [index], with: .fade)
                self.documentsTableView.endUpdates()
            } else {
                self.showErrorAlert(with: "Ooops... Couldn't delete \(fileName)")
            }
            
        }
        return [delete]
    }
}
