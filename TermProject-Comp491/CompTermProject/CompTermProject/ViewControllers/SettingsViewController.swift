//
//  SettingsViewController.swift
//  CompTermProject
//
//  Created by Lab on 24.05.2022.
//

import UIKit
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class SettingsViewController: UIViewController {

    @IBOutlet weak var retrievedImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
        // Do any additional setup after loading the view.
    }
    func getImage() {
        let storage = Storage.storage().reference()
        
        let userID = Auth.auth().currentUser?.uid
        
        let file = storage.child("images/fadime.jpg")
        
        file.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if error == nil && data != nil{
                let image = UIImage(data: data!)
                
                DispatchQueue.main.async {
                    self.retrievedImage.image = image
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
