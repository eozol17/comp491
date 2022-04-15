//
//  Survey_2_ViewController.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 15.04.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class Survey_2_ViewController: UIViewController {
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var post2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func post2(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else{
            print("UserId Not found")
            return
        }
        print("Fonksiyona girildi." + "UserId:" + userID)
        let url = URL(string: "https://europe-west3-skinmate-2aab0.cloudfunctions.net/recommendation")!
        var request = URLRequest(url: url)
        let body = ["user_id": userID]
        //
        print(JSONSerialization.isValidJSONObject(body))
            
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
                // Handle HTTP request response
                print("------data------")
                print(data)
            } else {
                print("------Unhandled------\n")
                // Handle unexpected error
            }
            print("---------------")
        }.resume()
    }
    
    
    
    
//    Caleed with button
    @IBAction func postPressed(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else{
            print("UserId Not found")
            return
        }
        print("Fonksiyona girildi." + "UserId:" + userID)
        let url = URL(string: "https://us-central1-skinmate-2aab0.cloudfunctions.net/function-1")!
        var request = URLRequest(url: url)
        let body = ["user_id": userID]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body
        )
        request.httpMethod = "POST"
        request.httpBody = bodyData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print("------Error------")
                print(error)
                // Handle HTTP request error
            } else if let data = data {
                // Handle HTTP request response
                print("------data------")
                print(data)
            } else {
                print("------Unhandled------\n")
                // Handle unexpected error
            }
        }.resume()
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
