//
//  ProfileDataSource.swift
//  CompTermProject
//
//  Created by Lab on 25.04.2022.
//

import Foundation
import CoreLocation
import Firebase
import FirebaseFirestore


class ProfileDataSource {
    
    
    private let baseURL = "https://europe-west3-skinmate-2aab0.cloudfunctions.net/get_last-1"
    public var profileArray: [Profile] = []
    static var profileDataSource = ProfileDataSource()
    var delegate: ProfileDataSourceDelegate?
    
    init() {
        
    }
    
    func loadProfile() {
        guard let userID = Auth.auth().currentUser?.uid else{
            print("UserId Not found")
            return
        }
        let body = ["user_id": userID, "query": "analysis"]
            
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body

        )
        let urlSession = URLSession.shared
        if let url = URL(string: "\(baseURL)") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = bodyData
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                //let decoder = JSONDecoder()
                //if let data = data {
                
                do {
                    let decoder = JSONDecoder()
                    //decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let profileArrayFromNetwork = try decoder.decode([Profile].self, from: data!)
                    self.profileArray = profileArrayFromNetwork
                    
                    DispatchQueue.main.async {
                        self.delegate?.profileLoaded()
                    }
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
                
            }
            dataTask.resume()
        }
    }
    func getProfileWithIndex(index: Int) -> Profile {
            return profileArray[index]
    }
    
    func getNumberOfProfiles()-> Int{
        return profileArray.count
    }
    
    
}
