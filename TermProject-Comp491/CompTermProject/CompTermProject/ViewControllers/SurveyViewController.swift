//
//  surveyViewController.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 23.03.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class surveyViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var drySkinCheckBox: UIButton!
    @IBOutlet weak var skinRashCheckBox: UIButton!
    @IBOutlet weak var hormonalTherapyCheckBox: UIButton!
    
    @IBOutlet weak var genderOption: UITextField!
    @IBOutlet weak var ageOption: UITextField!
    @IBOutlet weak var DrySkin: UITextField!
    @IBOutlet weak var SkinRash: UITextField!
    @IBOutlet weak var Hormonal_Therapy: UITextField!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap) // Add gesture recognizer to background view
        // Do any additional setup after loading the view.
    }
    @objc func handleTap() {
        nameField.resignFirstResponder() // dismiss keyoard
        lastNameField.resignFirstResponder()
        //lastName.resignFirstResponder()
        genderOption.resignFirstResponder()
        ageOption.resignFirstResponder()
        //DrySkin.resignFirstResponder()
        //SkinRash.resignFirstResponder()
        //Hormonal_Therapy.resignFirstResponder()
    }
    
    let checkedImage = UIImage(named: "checked")! as UIImage
    let uncheckedImage = UIImage(named: "unchecked")! as UIImage
    
    var isDrySkinChecked: Bool = false
    var isSkinRashChecked: Bool = false
    var isHormonalTherapyChecked: Bool = false
    
    @IBAction  func buttonClicked(sender: UIButton) {
        print(isDrySkinChecked)
        if(isDrySkinChecked == false) {
            print("checked now")
            isDrySkinChecked = true
            drySkinCheckBox.setImage(checkedImage, for: UIControl.State.normal)
        } else {
            print("unchecked now")
            isDrySkinChecked = false
            drySkinCheckBox.setImage(uncheckedImage, for: UIControl.State.normal)
        }
    }
    
    @IBAction func skinRashButtonClicked(sender: UIButton) {
        print(isSkinRashChecked)
        if(isSkinRashChecked == false) {
            print("checked now skin rash")
            isSkinRashChecked = true
            skinRashCheckBox.setImage(checkedImage, for: UIControl.State.normal)
        } else {
            print("unchecked now skin rash")
            isSkinRashChecked = false
            skinRashCheckBox.setImage(uncheckedImage, for: UIControl.State.normal)
        }
    }
    
    @IBAction func hormonalTherapyButtonClicked(sender: UIButton) {
        print(isHormonalTherapyChecked)
        if(isHormonalTherapyChecked == false) {
            print("checked now hormon")
            isHormonalTherapyChecked = true
            hormonalTherapyCheckBox.setImage(checkedImage, for: UIControl.State.normal)
        } else {
            print("unchecked now hormon")
            isHormonalTherapyChecked = false
            hormonalTherapyCheckBox.setImage(uncheckedImage, for: UIControl.State.normal)
        }
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        var dryskin: Optional<Any>
        if(isDrySkinChecked == false) {
            dryskin = "No"
        } else {
            dryskin = "Yes"
        }
        
        var skinrash: Optional<Any>
        if(isSkinRashChecked == false) {
            skinrash = "No"
        } else {
            skinrash = "Yes"
        }
        
        var hormonaltherapy: Optional<Any>
        if(isHormonalTherapyChecked == false) {
            hormonaltherapy = "No"
        } else {
            hormonaltherapy = "Yes"
        }
        
        guard let name = nameField.text,let lastName = lastNameField.text,let gender = genderOption.text,let age = ageOption.text,let DrySkin = dryskin,let SkinRash = skinrash,let hormon = hormonaltherapy else{
            return
        }
        guard let userID = Auth.auth().currentUser?.uid else{
            
            return
        }
        // Add a new document with a generated ID
        
        db.collection("users").document(userID).setData([
            "first": name,
            "surname": lastName,
//          Age Formatting should be changed. 
            "age":age,
            "Gender":gender,
            "DrySkin":DrySkin,
            "SkinRash":SkinRash,
            "Hormonal Therapy":hormon,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: Added User Data")
            }
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
