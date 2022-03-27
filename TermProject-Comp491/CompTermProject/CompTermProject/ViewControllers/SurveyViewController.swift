//
//  surveyViewController.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 23.03.2022.
//

import UIKit
import Firebase

class surveyViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func confirmPressed(_ sender: Any) {
        guard let name = nameField.text,let lastName = lastName.text,let  age = ageField.text else{
            return
        }
        guard let userID = Auth.auth().currentUser?.uid else{
            return
        }
//        ref.child("users").child(userID).setValue(["name":name])
        print(userID)
        
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
