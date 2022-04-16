//
//  Product.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 7.03.2022.
//

import Foundation
import FirebaseFirestoreSwift

class Product: Codable{
    @DocumentID var id:String?
    var kullanım_sekli: String
    var ozet_Bilgi: String
    var urun_bilgi: String
    var urun_bileseni: [String]
    var urun_boyutu:String
    var urun_faydalari: String
    var urun_markasi: String
    init(kullanım_sekli:String,ozet_Bilgi:String,urun_bilgi: String,urun_bileseni: [String],urun_boyutu:String
    ,urun_faydalari: String,urun_markasi: String){
        self.kullanım_sekli = kullanım_sekli
        self.ozet_Bilgi = ozet_Bilgi
        self.urun_bilgi = urun_bilgi
        self.urun_bileseni = urun_bileseni
        self.urun_boyutu = urun_boyutu
        self.urun_faydalari = urun_faydalari
        self.urun_markasi = urun_markasi
    }
}
