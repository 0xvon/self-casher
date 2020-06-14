//
//  SelfCasherForDiscount.swift
//  App
//
//  Created by Masato TSUTSUMI on 2020/06/14.
//

import Foundation
import Vapor

var quantities: Int = 0
var products: [Product] = []
var pointCard: PointCard? = nil
var barcodes: [Barcode] = []
var sum: Int = 0
var err = 0

class SelfCasherUseCase {
    func post(body: String, index: Int) -> String? {
        let selfCasher: SelfCasher = SelfCasher()
        if index == 0 {
            let quantity: Int = selfCasher.getQuantity(input: body)
            quantities = quantity
        } else if index <= quantities {
            let product = selfCasher.readProduct(item: body)
            products.append(product)
        } else {
            let parsed: [String] = selfCasher.parseProductInput(input: body)
            switch parsed[0].unicodeScalars.count {
            case 5:
                // start
                let card: PointCard? = parsed.count == 2 ? selfCasher.readPointCard(item: parsed[1]) : nil
                pointCard = card
                return nil
            case 3:
                // end
                let card = pointCard
                let su = sum
                let er = err
                pointCard = nil
                sum = 0
                err = 0
                
                switch er {
                case 0:
                    if let pointCard = card {
                        let point = pointCard.point
                        return "\(su - point)"
                    } else {
                        return "\(su)"
                    }
                case 1:
                    return "staff call: 1"
                case 2:
                    return "staff call: 2"
                default:
                    return "staff call: 1 2"
                }
            case 13:
                // product
                let barcode: Barcode = selfCasher.readBarcode(items: parsed)
                barcodes.append(barcode)
                if !selfCasher.validateBarcode(id: barcode.id, checkSum: barcode.checkSum) {
                    err += 2
                }
                let point: Int = selfCasher.getPoint(price: barcode.price)
                if pointCard != nil { pointCard!.point += point }
                sum += barcode.price
                return nil
            case 15...18:
                // discounted product
                let barcode: DiscountedBarcode = selfCasher.readDiscountedBarcode(items: parsed)
                if !selfCasher.validateBarcode(id: barcode.id, checkSum: barcode.checkSum) {
                    err += 2
                }
                let point: Int = selfCasher.getPoint(price: barcode.price)
                if pointCard != nil { pointCard!.point += point }
                sum += barcode.price
                return nil
            default:
                print("error")
                err += 1
            }
        }
        return nil
    }
}
