//
//  UploadViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//

import UIKit
import SwiftyDropbox
import UniformTypeIdentifiers
import MobileCoreServices

class UploadViewController: UIViewController, UIDocumentPickerDelegate {

    var uploadButton: UIButton={
       let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        return button
    }()
    var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(uploadButton)
        setupSpinner()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        uploadButton.frame = CGRect(x: (view.width - 120) / 2, y: (view.height - 80) / 2, width: 120, height: 80)
    }
    
    func setupSpinner() {
        if #available(iOS 13.0, *) {
            spinner = UIActivityIndicatorView(style: .large)
        } else {
            // Fallback on earlier versions
            spinner = UIActivityIndicatorView(frame: CGRect(x: view.width / 2, y: view.height / 2, width: 80, height: 100))
        }
        spinner.color = .blue
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.sizeToFit()
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func uploadButtonTapped() {
        var documentPicker: UIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            let allowedtypes : [UTType] = [UTType.audio]
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: allowedtypes)
            documentPicker.delegate = self
    present(documentPicker, animated: true, completion: nil)

        } else {
            let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeAudio as String], in: .import)
            present(documentPicker, animated: true, completion: nil)
            // Fallback on earlier versions
        }
        
                
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        showSpinner()
        let client = DropboxClientsManager.authorizedClient
        do{
        let uploadData = try Data(contentsOf: url)
        
        
            client?.files.upload(path: "/audio/\(url.lastPathComponent)", mode: .add, input: uploadData).response { response, error in
            self.hideSpinner()
            if let response = response {
                self.showalert(title: "Upload Success", message: "The file is uploaded")
                print(response)
            } else if let error = error {
                print(error)
                self.showalert(title: "Error", message: "There is an error in uploading, please try again later")
            }
        }
        }
        catch{
            print("error occured")
        }
    }
    func showalert(title:String, message:String){
        let alert = UIAlertController(title: title,message:message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func showSpinner() {
        spinner.startAnimating()
        uploadButton.isEnabled = false
    }
    
    func hideSpinner() {
        spinner.stopAnimating()
        uploadButton.isEnabled = true
    }
}
