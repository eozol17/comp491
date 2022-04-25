//
//  Profile.swift
//  CompTermProject
//
//  Created by Lab on 25.04.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Profile: Decodable {
    
    var name: String?
    var kistik: Bool?
    var pustul: Bool?
    var papul: Bool?
    var nodul: Bool?
    var siyah_nokta: Bool?
    var beyaz_nokta: Bool?
    var cilt_tipi: String?
    var created: String?
    
    
    
    init(name: String, kistik: Bool, pustul: Bool, papul: Bool, nodul: Bool, siyah_nokta: Bool, beyaz_nokta: Bool, cilt_tipi: String, created: String){
        self.name = name
        self.kistik = kistik
        self.pustul = pustul
        self.papul = papul
        self.nodul = nodul
        self.siyah_nokta = siyah_nokta
        self.beyaz_nokta = beyaz_nokta
        self.cilt_tipi = cilt_tipi
        self.created = created
    }
    
    mutating func set_name(name: String) {
        self.name = name
    }
    
    mutating func set_kistik(kistik: Bool){
        self.kistik = kistik
    }
    
    mutating func set_pustul(pustul: Bool) {
        self.pustul = pustul
    }
    
    mutating func set_papul(papul: Bool) {
        self.papul = papul
    }
    
    mutating func set_nodul(nodul: Bool) {
        self.nodul = nodul
    }
    
    mutating func set_siyah_nokta(siyah: Bool) {
        self.siyah_nokta = siyah
    }
    
    mutating func set_beyaz_nokta(beyaz: Bool){
        self.beyaz_nokta = beyaz
    }
    
    mutating func set_cilt_tipi(cilt: String){
        self.cilt_tipi = cilt
    }
    
    mutating func set_created(created: String) {
        self.created = created
    }
}
