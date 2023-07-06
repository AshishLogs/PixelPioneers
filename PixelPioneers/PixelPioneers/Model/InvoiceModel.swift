//
//  InvoiceModel.swift
//  PixelPioneers
//
//  Created by Sushant on 06/07/23.
//

import Foundation
import Alamofire


struct InvoiceModel: Codable, BaseModel {
    let invoiceDate, invoiceID: String?
    let invoiceTotal: Int?
    let items: [Item]?
    let recipient: Recipient?
    let shippingInfo: ShippingInfo?
    let subTotal: Int?
    let taxDetails: [TaxDetail]?
    let totalDiscount: Int?
    let totalTax: String?
    let vendor: Vendor?
    var data: Data?
    enum CodingKeys: String, CodingKey {
        case invoiceDate = "InvoiceDate"
        case invoiceID = "InvoiceId"
        case invoiceTotal = "InvoiceTotal"
        case items = "Items"
        case recipient = "Recipient"
        case shippingInfo = "ShippingInfo"
        case subTotal = "SubTotal"
        case taxDetails = "TaxDetails"
        case totalDiscount = "TotalDiscount"
        case totalTax = "TotalTax"
        case vendor = "Vendor"
    }
    
    var list : [OCRValues] {
        return [OCRValues.init(key: "Vendor Name", value: self.vendor?.vendorName),
                OCRValues.init(key: "Vendor Address", value: self.vendor?.vendorAddress),
                OCRValues.init(key: "Invoice Date", value: self.invoiceDate),
                OCRValues.init(key: "Invoice ID", value: self.invoiceID),
                OCRValues.init(key: "Recipient Details", value: self.recipient?.billingAddress),
                OCRValues.init(key: "Shipping Info", value: self.shippingInfo?.shippingAddress),
                OCRValues.init(key: "Total Discount", value: String.init(format: "%d", self.totalDiscount ?? 0.0)),
                OCRValues.init(key: "Invoice Total", value: String.init(format: "%d", self.invoiceTotal ?? 0.0)),
                OCRValues.init(key: "Sub Total", value: String.init(format: "%d", self.subTotal ?? 0.0))].filter({$0.value != nil && ($0.value ?? "").count > 0 })
    }
}

// MARK: - Item
struct Item: Codable {
    let amount: Double?
    let description, productCode: String?
    let quantity, tax: Int?
    let taxRate: String?

    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case description = "Description"
        case productCode = "ProductCode"
        case quantity = "Quantity"
        case tax = "Tax"
        case taxRate = "TaxRate"
    }
}

// MARK: - Recipient
struct Recipient: Codable {
    let billingAddress: String?

    enum CodingKeys: String, CodingKey {
        case billingAddress = "BillingAddress"
    }
}

// MARK: - ShippingInfo
struct ShippingInfo: Codable {
    let shippingAddress, shippingAddressRecipient: String?

    enum CodingKeys: String, CodingKey {
        case shippingAddress = "ShippingAddress"
        case shippingAddressRecipient = "ShippingAddressRecipient"
    }
}

// MARK: - TaxDetail
struct TaxDetail: Codable {
    let amount: Int?

    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
    }
}

// MARK: - Vendor
struct Vendor: Codable {
    let vendorAddress, vendorAddressRecipient, vendorName, vendorTaxID: String?

    enum CodingKeys: String, CodingKey {
        case vendorAddress = "VendorAddress"
        case vendorAddressRecipient = "VendorAddressRecipient"
        case vendorName = "VendorName"
        case vendorTaxID = "VendorTaxId"
    }
}


enum InvoiceRouter {
    case upload(image: String)
}

extension InvoiceRouter : APIRouter {
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .upload(let image):
            return ["docType":"invoice", "base64Data": image]
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
}
