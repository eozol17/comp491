//
//  CameraViewController.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 8.03.2022.
//

import UIKit
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var CameraView: UIImageView!
    @IBOutlet weak var TakePhotoButton: UIButton!
    @IBOutlet weak var analizButton: UIButton!
    var fileName:String = ""

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var q:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        fileName = dateFormatter.string(from: date)
        fileName = fileName+".jpg"
        print(fileName)
    }
    
    @IBAction func sendPhotoButtonPressed(_ sender: Any) {
        if let myImage = imageView.image{
            imageAnalysis(myImage: myImage,name:fileName)
        }
    }
    
    @IBAction func AnalizPressed(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else{
            print("UserId Not found")
            return
        }
        activityIndicator.startAnimating()
        print("UserId:" + userID)
        let url = URL(string: "https://europe-west3-skinmate-2aab0.cloudfunctions.net/image_analysis_by_storage")!
        var request = URLRequest(url: url)
        
        let body = ["user_id": userID,"file_name":fileName]
    
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body
        )
        
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("------Error------")
                print(error)
                // Handle HTTP request error
            } else if let data = data {
                do{
                    print("Got Data")
                    self.activityIndicator.stopAnimating()
                     let alert = UIAlertController(title: "Analiz Tamamlandı", message: "\"Profil\" ekranından analiz sonuçlarına, \"Ürün Önerileri\" ekranından ürün ve ürün kullanım önerilerine bakabilir, \"İlerleme\" ekranından ilerlemenizi takip edebilirsiniz.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { action in })
                    alert.addAction(action)
                    DispatchQueue.main.async (
                        execute: { self.present(alert, animated: true)
                    })
                }
                catch{
                    print("------catch------")
                }
                // Handle HTTP request response
            } else {
                print("------Unhandled------\n")
                // Handle unexpected error
            }
            print("---------------")
        }.resume()
    }
    
    
    func imageAnalysis(myImage:UIImage,name:String) {
        
        let storage = Storage.storage().reference()
        
        let imageData = myImage.jpegData(compressionQuality: 0.8)!
        
        let userID = Auth.auth().currentUser?.uid
        

        
        
        let file = storage.child("\(String(describing: userID!))/\(name)")
        
        let uploadTask = file.putData(imageData, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
               print("success")
            }
        }
    }
    
    
    
    
    @IBAction func TappedCameraBtn(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        CameraView?.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

