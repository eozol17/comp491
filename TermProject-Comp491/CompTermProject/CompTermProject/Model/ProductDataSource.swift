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


class ProductDataSource {
    let db = Firestore.firestore()
    public var productArray: [Product]
    static var productDataSource = ProductDataSource()
    
    init(){
        productArray = []
        //Burda da productArray i doluruyoruz ancak 2 tane array de yapılabilir sabah akşam diye.
        print("sabah init")
        getSabahDocument()
        print("Akşam init")
        getAksamDocument()
        print("Product Array")
        print(productArray)
                          
    }
    
    func getProductWithIndex(index: Int) -> Product {
            return productArray[index]
    }
    
    func getNumberOfProducts()-> Int{
        return productArray.count
    }
    
    //içine bir key(yüz maskes) ve numarası(0....300...) verildiğinde o product ı database den çekiyo
    private func fetchProduct(key: String,number:String){
        let docRef = db.collection("product").document("product_list")
            .collection(key).document(number)
        
        docRef.getDocument { document, error in
            if let document = document{
                let data = document.data()
                let kullanım_sekli: String = data?["Kullanım Şekli:"] as? String ?? ""
                let ozet_Bilgi: String = data?["Özet Bilgi:"] as? String ?? ""
                let urun_bilgi: String = data?["Ürün Adı:"] as? String ?? ""
                let urun_bileseni: [String] = data?["Ürün Bileşimi:"] as? [String] ?? [""]
                let urun_boyutu:String = data?["Ürün Boyutu:"] as? String ?? ""
                let urun_faydalari: String = data?["Ürün Faydaları:"] as? String ?? ""
                let urun_markasi: String = data?["Ürün Markası:"] as? String ?? ""
                let myProd: Product = Product(kullanım_sekli: kullanım_sekli, ozet_Bilgi: ozet_Bilgi, urun_bilgi: urun_bilgi, urun_bileseni: urun_bileseni, urun_boyutu: urun_boyutu, urun_faydalari: urun_faydalari, urun_markasi: urun_markasi)
            }
            else{
                if let error = error{
                    print(error)
                }
            }

//            print("func içi")
//            print(myProd.urun_markasi)
//            self.productArray.append(myProd)
//            print("self.productArray: ")
//            print(self.productArray[0].urun_markasi)
//            print("productArray: ")
//            print(productArray[0].urun_markasi)
//            print("----------------")
        }
//        print("Return Kısmı")
//        print("self.productArray: ")
//        print(self.productArray[0].urun_markasi)
//        print("productArray: ")
//        print(productArray[0].urun_markasi)
//        print("---------------")
//        return(productArray)
    }
    
    //fireBase deki akşam rutininde olan bütün productları çekiyor sanırım test edildi datayı alıyor ancak display edemedim bizim viewController da
    private func getAksamDocument() {
        //Get specific document from current user
        let userID = Auth.auth().currentUser?.uid ?? ""
        let docRef = db.collection("users").document(userID).collection("routines").document("routine").collection("aksam").document("products")

        // Get data
        docRef.getDocument { document, error in
            if let document = document {
                do{
                    let data = document.data()
                    if let docKeys = data?.keys{
                        for key in docKeys{
//                            self.fetchProduct(key: key,number: String(data?[key] as! Int))
                        }
                    }
                    else{
                        print("Failed Aksam")
                        //fail
                    }
                }
            }
        }
    }
    
    
    //fireBase deki sabah rutininde olan bütün productları çekiyor ve bir liste olarak döndürüyor en son da appendliyoruz bunları
    private func getSabahDocument(){
        //Get specific document from current user
        let userID = Auth.auth().currentUser?.uid ?? ""
        let docRef = db.collection("users").document(userID).collection("routines").document("routine").collection("sabah").document("products")

        // Get data
        docRef.getDocument { (document, error) in
            if let document = document {
                do{
                    let data = document.data()
                    if let docKeys = data?.keys{
                        for key in docKeys{
                            
                        }
                    }
                    else{
                        print("failed sabah")
                        //Fail or nil
                    }
                }
            }
        }
    }
}
