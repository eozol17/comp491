//
//  RecomendationsViewController.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 11.03.2022.
//

import UIKit

class RecomendationsViewController: UIViewController {

    
   // var productDataSource = ProductDataSource.productDataSource;
    var productDataSource = ProductDataSource()
    @IBOutlet weak var productsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ürün Önerileri"
        // Do any additional setup after loading the view.
        productDataSource.delegate = self
        productDataSource.loadProductList()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        productDataSource.delegate = self
        productDataSource.loadProductList()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! ProductsTableViewCell
        if let indexPath = self.productsTableView.indexPath(for: cell) {
            let product = productDataSource.getProductWithIndex(index: getRealIndex(indexPath: indexPath))
            let productDetailViewController = segue.destination as! ProductDetailViewController
            productDetailViewController.selectedProdcutUsage = product.kullanim_sekli
        }
    }
    
    func getRealIndex(indexPath: IndexPath) -> Int {
        let realIndex = indexPath.row.quotientAndRemainder(dividingBy: productDataSource.getNumberOfProducts()).remainder
                return realIndex
        }
}

extension RecomendationsViewController:ProductDataSourceDelegate {
    
    func productListLoaded() {
        productsTableView.reloadData()
    }
    
    func productDetailLoaded(product: Product) {
    }
}

extension RecomendationsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return productDataSource.getNumberOfProducts()
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductsTableViewCell
            let product = productDataSource.getProductWithIndex(index: getRealIndex(indexPath: indexPath))
            //let event = productDataSource.getProductWithIndex(index: 0)
            if (productDataSource.productArray[0].urun_turu == "Uyarı"){
                cell.ProductName.text = product.urun_adi
                cell.productAttributes.text = ""
                cell.productTime.text = ""
            }
            else{
                cell.ProductName.text = product.urun_adi
                cell.productAttributes.text = product.urun_turu
                cell.productTime.text = product.zaman
            }
            return cell
        }
}
