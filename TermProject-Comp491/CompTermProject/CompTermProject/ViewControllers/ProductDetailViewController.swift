//
//  ProductDetailViewController.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 9.05.2022.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var Product_Usage: UITextView!
    var productDataSource = ProductDataSource()
    var selectedProdcutUsage : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        productDataSource.delegate = self
        self.title = "Kullanım Şekli"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.Product_Usage.text = selectedProdcutUsage
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

extension ProductDetailViewController:ProductDataSourceDelegate{
    func productDetailLoaded(product: Product) {
        self.Product_Usage.text = product.kullanim_sekli
    }
    
    func productListLoaded() {
    }
}

