//
//  Product.swift
//  SampleDemoApp
//
//  Created by Subhankar on 28/06/19.
//  Copyright © 2019 Subhankar. All rights reserved.
//

import Foundation

struct AppData: Decodable {
    let conversion: [Conversion]
    let product: [Product]
    let title: String
    
    private enum CodingKeys: String, CodingKey {
        case conversion
        case product = "products"
        case title
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conversion = try container.decode(Array.self, forKey: .conversion)
        product = try container.decode(Array.self, forKey: .product)
        title = try container.decode(String.self, forKey: .title)
    }
}


struct Product: Decodable {
    let url: String
    let name: String
    let price: String
    let currency: String
    
    private enum CodingKeys: String, CodingKey {
        case url
        case name
        case price
        case currency
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey: .url)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(String.self, forKey: .price)
        currency = try container.decode(String.self, forKey: .currency)
    }
}
