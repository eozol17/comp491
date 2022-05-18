//
//  LoginViewController.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 22.03.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailField: OurUITextField!
    @IBOutlet weak var passwordField: OurUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap) // Add gesture recognizer to background view

        // Do any additional setup after loading the view.
    }
    
    
    @objc func handleTap() {
        emailField.resignFirstResponder() // dismiss keyoard
        passwordField.resignFirstResponder()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailField.text, let password = passwordField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard error == nil else {
                self?.warningLabel.text = error!.localizedDescription
                self?.warningLabel.isHidden = false
                print(error!.localizedDescription)
              return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let TabBar = storyboard.instantiateViewController(withIdentifier: "TabBar")
            TabBar.modalPresentationStyle = .automatic
//          Lazımlı
            self?.dismiss(animated: true)
            self?.navigationController?.pushViewController(TabBar, animated: true)
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
