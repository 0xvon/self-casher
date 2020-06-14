//
//  SelfCasher.swift
//  App
//
//  Created by Masato TSUTSUMI on 2020/06/14.
//

import Foundation

class SelfCasher {
    
    func parseProductInput(input: String) -> [String] {
        let parsedItems: [String] = input.components(separatedBy: " ")
        return parsedItems
    }
    
    func getQuantity(input: String) -> Int {
        guard let quantity = Int(input) else { return 0 }
        return quantity
    }
    
    func readProduct(item: String) -> Product {
        
        let parsedItem: [String] = self.parseProductInput(input: item)
        let productCode: String = parsedItem[0]
        let price: Int = parsedItem.count == 2 ? Int(parsedItem[1])! : 0
        let product: Product = Product(
            productCode: productCode,
            price: price
        )
        return product
    }
    
    func readPointCard(item: String) -> PointCard {
        let pointCard: PointCard = PointCard(id: item, point: 0)
        return pointCard
    }
    
    func discount(product: Product) {
        
    }
    
    func readBarcode(items: [String]) -> Barcode {
        let code: String = items[0]
        let arr = Array(code)
        
        let part = arr[0...1].map { String($0) }.joined(separator: "")
        let productCode: String = part == "02" ? arr[2...6].map { String($0) }.joined(separator: "") : arr[0...11].map { String($0) }.joined(separator: "")
        let checkSum: Int = Int(String(arr.last!))!
        let price: Int = items.count == 2 ? Int(items[1])! : Int(arr[7...11].map { String($0) }.joined(separator: ""))!
        let barcode: Barcode = Barcode(id: code, price: price, part: part, productCode: productCode, checkSum: checkSum)
        
        return barcode
    }
    
    func readDiscountedBarcode(items: [String]) -> DiscountedBarcode {
        let code: String = items[0]
        let arr = Array(code)
        
        let barcode: Barcode = self.readBarcode(items: items)
        let part: DiscountType = arr.count == 18 ? .yen : .persentage
        let discountAmount: Int = arr.count == 15 ? Int(arr[12...13].map { String($0) }.joined(separator: ""))! : Int(arr[12...16].map { String($0) }.joined(separator: ""))!
        let checkSum: Int = Int(String(arr.last!))!
        
        let discountedBarcode: DiscountedBarcode = DiscountedBarcode(
                                                       id: code,
                                                       price: barcode.price,
                                                       discountAmount: discountAmount,
                                                       discountType: part,
                                                       checkSum: checkSum
                                                    )
        
        return discountedBarcode
    }
    
    func validateBarcode(id: String, checkSum: Int) -> Bool {
        var arr = Array(id)
        arr = Array(arr.prefix(arr.count - 1))
        var sum = 0
        for num in arr {
            sum += Int(String(num))!
        }
        return sum % 10 == checkSum
    }
    
    func getPoint(price: Int) -> Int {
        return price / 100
    }
}
