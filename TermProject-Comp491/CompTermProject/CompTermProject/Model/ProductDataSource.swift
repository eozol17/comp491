//
//  ProductDataSource.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 11.03.2022.
//

import Foundation
import CoreLocation
import Firebase
import FirebaseFirestore


struct ProductDataSource {
    let db = Firestore.firestore()
    public var productArray: [Product] = []
//    static var productDataSource = ProductDataSource()
    
    func getProductWithIndex(index: Int) -> Product {
            return productArray[index]
    }
    
    func getNumberOfProducts()-> Int{
        return productArray.count
    }
}
    
    
    
    
    











//Get Product

//    func getProduct(_key: String,_number: String,_completion: @escaping (Product)->Void){
//        var myProd: Product = Product(kullanım_sekli: "", ozet_Bilgi: "", urun_bilgi: "", urun_bileseni: [""], urun_boyutu: "", urun_faydalari: "", urun_markasi: "")
//        let docRef = db.collection("product").document("product_list")
//            .collection(_key).document(_number)
//
//        docRef.getDocument(as: Product.self) { error in
//
//
//                _completion(myProd)
//            }
//            else{
//                if let error = error{
//                    _completion(myProd)
//                    print(error)
//                }
//            }
//        }


//fireBase deki akşam rutininde olan bütün productları çekiyor sanırım test edildi datayı alıyor ancak display edemedim bizim viewController da
//    private func getAksamDocument() {
//        //Get specific document from current user
//        let userID = Auth.auth().currentUser?.uid ?? ""
//        let docRef = db.collection("users").document(userID).collection("routines").document("routine").collection("aksam").document("products")
//
//        // Get data
//        docRef.getDocument { document, error in
//            if let document = document {
//                do{
//                    let data = document.data()
//                    if let docKeys = data?.keys{
//                        for key in docKeys{
////                            self.fetchProduct(key: key,number: String(data?[key] as! Int))
//                        }
//                    }
//                    else{
//                        print("Failed Aksam")
//                        //fail
//                    }
//                }
//            }
//        }
//    }
    
    
    //fireBase deki sabah rutininde olan bütün productları çekiyor ve bir liste olarak döndürüyor en son da appendliyoruz bunları
//    private func getSabahDocument(){
//        //Get specific document from current user
//        let userID = Auth.auth().currentUser?.uid ?? ""
//        let docRef = db.collection("users").document(userID).collection("routines").document("routine").collection("sabah").document("products")
//
//        // Get data
//        docRef.getDocument { (document, error) in
//            if let document = document {
//                do{
//                    let data = document.data()
//                    if let docKeys = data?.keys{
//                        for key in docKeys{
//
//                        }
//                    }
//                    else{
//                        print("failed sabah")
//                        //Fail or nil
//                    }
//                }
//            }
//        }
//    }


//içine bir key(yüz maskes) ve numarası(0....300...) verildiğinde o product ı database den çekiyo

//    private func fetchProduct(key: String,number:String) async ->Product {
//        var myProd: Product = Product(kullanım_sekli: "", ozet_Bilgi: "", urun_bilgi: "", urun_bileseni: [""], urun_boyutu: "", urun_faydalari: "", urun_markasi: "")
//        let docRef = db.collection("product").document("product_list")
//            .collection(key).document(number)
//
//        docRef.getDocument { document, error in
//            if let document = document{
//                let data = document.data()
//                let kullanım_sekli: String = data?["Kullanım Şekli:"] as? String ?? ""
//                let ozet_Bilgi: String = data?["Özet Bilgi:"] as? String ?? ""
//                let urun_bilgi: String = data?["Ürün Adı:"] as? String ?? ""
//                let urun_bileseni: [String] = data?["Ürün Bileşimi:"] as? [String] ?? [""]
//                let urun_boyutu:String = data?["Ürün Boyutu:"] as? String ?? ""
//                let urun_faydalari: String = data?["Ürün Faydaları:"] as? String ?? ""
//                let urun_markasi: String = data?["Ürün Markası:"] as? String ?? ""
//                myProd = Product(kullanım_sekli: kullanım_sekli, ozet_Bilgi: ozet_Bilgi, urun_bilgi: urun_bilgi, urun_bileseni: urun_bileseni, urun_boyutu: urun_boyutu, urun_faydalari: urun_faydalari, urun_markasi: urun_markasi)
//            }
//            else{
//                if let error = error{
//                    print(error)
//                }
//            }
//        }
//        print(myProd.urun_markasi)
//        return myProd
//    }



//            if let document = document{
//                let data = document.data()
//                let kullanım_sekli: String = data?["Kullanım Şekli:"] as? String ?? ""
//                let ozet_Bilgi: String = data?["Özet Bilgi:"] as? String ?? ""
//                let urun_bilgi: String = data?["Ürün Adı:"] as? String ?? ""
//                let urun_bileseni: [String] = data?["Ürün Bileşimi:"] as? [String] ?? [""]
//                let urun_boyutu:String = data?["Ürün Boyutu:"] as? String ?? ""
//                let urun_faydalari: String = data?["Ürün Faydaları:"] as? String ?? ""
//                let urun_markasi: String = data?["Ürün Markası:"] as? String ?? ""
