//
//  SignUpViewController.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 22.03.2022.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var emailField: OurUITextField!
    @IBOutlet weak var passwordField: OurUITextField!
    @IBOutlet weak var passwordAgainField: OurUITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap) // Add gesture recognizer to background view
    }

    @objc func handleTap() {
        emailField.resignFirstResponder() // dismiss keyoard
        passwordField.resignFirstResponder()
        passwordAgainField.resignFirstResponder()
    }
    
    
    
    
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        guard let email = emailField.text,let password = passwordField.text,let passwordAgain = passwordAgainField.text else{
            self.warningLabel.text = "Empty Fields"
            return
        }
        if(password != passwordAgain){
            self.warningLabel.text = "Password Check Doesn't match"
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            guard let user = authResult?.user, error == nil else {
                self.warningLabel.text = error!.localizedDescription
                self.warningLabel.isHidden = false
                print(error!.localizedDescription)
              return
            }
            print("\(user.email!) created")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let survey1 = storyboard.instantiateViewController(withIdentifier: "Survey1")
            survey1.modalPresentationStyle = .automatic
//          Lazımlı
            self.dismiss(animated: true)
            self.navigationController?.pushViewController(survey1, animated: true)
            
//            Buralar Hep Toprak
//            self.navigationController?.dismiss(animated: true)
//            self.present(survey1, animated: true, completion: nil)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
