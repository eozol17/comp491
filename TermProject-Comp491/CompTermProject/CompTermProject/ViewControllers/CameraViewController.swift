//
//  CameraViewController.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 8.03.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var CameraView: UIImageView!
    @IBOutlet weak var TakePhotoButton: UIButton!
    @IBOutlet weak var analizButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.allowsEditing = true
//        picker.delegate = self
//        present(picker, animated: true)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func AnalizPressed(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else{
            print("UserId Not found")
            return
        }
        print("Fonksiyona girildi." + "UserId:" + userID)
        let url = URL(string: "https://europe-west3-skinmate-2aab0.cloudfunctions.net/analysis")!
        var request = URLRequest(url: url)
        let body = ["user_id": userID]
            
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
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        if let sabah = json["sabah"] as? [String:Any]{
                            for(key,_) in sabah{
                                print("key = " + key)
                                if let x = sabah[key] as? [String: String]{
                                    for (key1,value2) in x{
                                        print("key1 = " + key1)
                                        print("value2 = " + value2 )
                                    }
                                }
                            }
                        }
                    }
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
    
        
        
        let myImage = UIImage(named: "sebamed.png")!
        
        let imageData:Data = myImage.pngData()!
        
        let imageStr = imageData.base64EncodedString()
    
        ///
        ///
        ///
        guard let userID = Auth.auth().currentUser?.uid else{
            print("UserId Not found")
            return
        }
        let body2 = [
            "user_id": userID
            //"image": imageStr
        ]
            
        let bodyData2 = try? JSONSerialization.data(
            withJSONObject: body2

        )
        let urlSession2 = URLSession.shared
        let baseURL = URL(string: "https://europe-west3-skinmate-2aab0.cloudfunctions.net/image_analysis")!
        
        var urlRequest2 = URLRequest(url: baseURL)
            urlRequest2.httpMethod = "POST"
            urlRequest2.httpBody = bodyData2
            urlRequest2.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask2 = urlSession2.dataTask(with: urlRequest2) { data, response, error in
                //let decoder = JSONDecoder()
                //if let data = data {
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("success")
                    print(response)
                } catch  {
                    print(error)
                }
            }
            dataTask2.resume()
        
      
        
        
        
        //request2.httpBody = try? JSONSerialization.data(withJSONObject: body2, options: .fragmentsAllowed)
        

    
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

