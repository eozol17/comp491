//
//  ProductDataSourceDelegate.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 18.04.2022.
//

import Foundation

protocol ProductDataSourceDelegate {
    func productListLoaded()
    func productDetailLoaded(product: Product)
}
