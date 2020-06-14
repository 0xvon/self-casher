//
//  Product.swift
//  App
//
//  Created by Masato TSUTSUMI on 2020/06/14.
//

import Foundation

struct Product {
    let productCode: String
    let price: Int
}

struct DiscountedProduct {
    
}

struct Barcode {
    let id: String
    let price: Int
    let part: String
    let productCode: String
    let checkSum: Int
}

struct DiscountedBarcode {
    let id: String
    let price: Int
    let discountAmount: Int
    let discountType: DiscountType
    let checkSum: Int
}

enum DiscountType {
    case yen
    case persentage
}

struct PointCard {
    let id: String
    var point: Int
}

enum Error {
    case staffError
    case scanError
    case bothError
}
