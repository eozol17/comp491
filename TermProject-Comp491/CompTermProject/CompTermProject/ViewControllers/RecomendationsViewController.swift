//
//  RecomendationsViewController.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 11.03.2022.
//

import UIKit

class RecomendationsViewController: UIViewController {

    var productDataSource = ProductDataSource.productDataSource;
    
    
    @IBOutlet weak var productsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        
//        let cell = sender as! ProductsTableViewCell
//                if let indexPath = self.productsTableView.indexPath(for: cell) {
//                    let product = productDataSource.getProductWithIndex(index: 0)
//                }
        
        
    }
    func getRealIndex(indexPath: IndexPath) -> Int {
        let realIndex = indexPath.row.quotientAndRemainder(dividingBy: productDataSource.getNumberOfProducts()).remainder
                return realIndex
        }
}

extension RecomendationsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if (section == 0) {
                return 10
            } else if (section == 1) {
                return 50
            }
            return 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductsTableViewCell
            let product = productDataSource.getProductWithIndex(index: getRealIndex(indexPath: indexPath))
            cell.ProductName.text = product?.prodName
            cell.productAttributes.text = product?.usage
            cell.productAttributes.textColor = UIColor.cyan
            return cell
        }
}
