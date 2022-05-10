//
//  Product.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 7.03.2022.
//

import Foundation
import FirebaseFirestoreSwift

class Product: Codable{
    var urun_turu:String
    var kullanim_sekli: String
    var urun_adi:String
    var zaman: String
    
    
    init(urun_turu:String,urun_adı:String,kullanim_sekli:String,zaman:String){
        self.urun_turu = urun_turu
        self.urun_adi = urun_adı
        self.kullanim_sekli = kullanim_sekli
        self.zaman = zaman
    }
    
    func set_Urun_turu(tür:String){
        self.urun_turu = tür
    }
    func set_kullanım(kullanım:String){
        self.kullanim_sekli = kullanım
    }
    func set_Urun_adı(ad:String){
        self.urun_adi = ad
    }
    
//    var ozet_Bilgi: String
//    var urun_bilgi: String
//    var urun_bileseni: [String]
//    var urun_boyutu:String
//    var urun_faydalari: String
//    var urun_markasi: String
    
//    init(kullanım_sekli:String,ozet_Bilgi:String,urun_bilgi: String,urun_bileseni: [String],urun_boyutu:String
//    ,urun_faydalari: String,urun_markasi: String){
//        self.kullanım_sekli = kullanım_sekli
//        self.ozet_Bilgi = ozet_Bilgi
//        self.urun_bilgi = urun_bilgi
//        self.urun_bileseni = urun_bileseni
//        self.urun_boyutu = urun_boyutu
//        self.urun_faydalari = urun_faydalari
//        self.urun_markasi = urun_markasi
//    }
}
