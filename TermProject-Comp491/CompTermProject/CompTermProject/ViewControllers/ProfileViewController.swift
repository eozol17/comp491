//
//  ProfileViewController.swift
//  CompTermProject
//
//  Created by Lab on 25.04.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    var profileDataSource = ProfileDataSource()
    
    
    //@IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var kistikLabel: UILabel!
    @IBOutlet weak var pustulLabel: UILabel!
    
    @IBOutlet weak var papulLabel: UILabel!
    
    @IBOutlet weak var nodulLabel: UILabel!
    
    
    @IBOutlet weak var siyahNoktaLabel: UILabel!
    
    @IBOutlet weak var beyazNoktaLabel: UILabel!
    
    @IBOutlet weak var ciltTipiLabel: UILabel!
    
   // @IBOutlet weak var createdLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileDataSource.delegate = self
        profileDataSource.loadProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileDataSource.delegate = self
        profileDataSource.loadProfile()
        
        if(nodulLabel.text == "Label"){
            kistikLabel.text = ("Henüz bir analiz bulunamamıştır.")
            pustulLabel.text = ("")
            papulLabel.text = ("")
            nodulLabel.text = ("")
            siyahNoktaLabel.text = ("")
            beyazNoktaLabel.text = ("")
            ciltTipiLabel.text = ("")
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

extension ProfileViewController: ProfileDataSourceDelegate {
    
    func profileLoaded() {
        //nameLabel.text = profileDataSource.profileArray[0].name
        
        if(profileDataSource.profileArray[0].cilt_tipi! == "error") {
            kistikLabel.text = ("Yüz algılanamamıştır. Tekrar fotoğraf çekiniz.")
            pustulLabel.text = ("")
            papulLabel.text = ("")
            nodulLabel.text = ("")
            siyahNoktaLabel.text = ("")
            beyazNoktaLabel.text = ("")
            ciltTipiLabel.text = ("")
//        } else if(pustulLabel.text == "Label" || kistikLabel.text == "Label" || papulLabel.text == "Label" || nodulLabel.text == "Label") {
//            kistikLabel.text = ("Henüz bir analiz bulunamamıştır.")
//            pustulLabel.text = ("")
//            papulLabel.text = ("")
//            nodulLabel.text = ("")
//            siyahNoktaLabel.text = ("")
//            beyazNoktaLabel.text = ("")
//            ciltTipiLabel.text = ("")
        
        }
            else {
            let kistik = String(profileDataSource.profileArray[0].kistik!)
            if(kistik == "false") {
                kistikLabel.text = ("Kistik: Yok")
            } else if(kistik == "true") {
                kistikLabel.text = ("Kistik: Var")
            }
        
            let pustul = String(profileDataSource.profileArray[0].pustul!)
            if(pustul == "false") {
                pustulLabel.text = ("Püstül: Yok")
            } else if(pustul == "true") {
                pustulLabel.text = ("Püstül: Var")
            }
        
            let papul = String(profileDataSource.profileArray[0].papul!)
            if(papul == "false") {
                papulLabel.text = ("Papül: Yok")
            } else if(papul == "true") {
                papulLabel.text = ("Papül: Var")
            }
        
            let nodul = String(profileDataSource.profileArray[0].nodul!)
            if(nodul == "false") {
                nodulLabel.text = ("Nodül: Yok")
            } else if(nodul == "true") {
                nodulLabel.text = ("Nodül: Var")
            }
        
            let siyahNokta = String(profileDataSource.profileArray[0].siyah_nokta!)
            if(siyahNokta == "false") {
                siyahNoktaLabel.text = ("Siyah Nokta: Yok")
            } else if(siyahNokta == "true") {
                siyahNoktaLabel.text = ("Siyah Nokta: Var")
            }
        
            let beyazNokta = String(profileDataSource.profileArray[0].beyaz_nokta!)
            if(beyazNokta == "false") {
                beyazNoktaLabel.text = ("Beyaz Nokta: Yok")
            } else if(beyazNokta == "true") {
                beyazNoktaLabel.text = ("Beyaz Nokta: Var")
            }
            
            ciltTipiLabel.text = ("Cilt Tipi: \(profileDataSource.profileArray[0].cilt_tipi!)")
            //createdLabel.text = profileDataSource.profileArray[0].created
        }
    }
}

