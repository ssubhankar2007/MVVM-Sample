//
//  Conversion.swift
//  SampleDemoApp
//
//  Created by Subhankar on 28/06/19.
//  Copyright © 2019 Subhankar. All rights reserved.
//

import Foundation
struct Conversion: Decodable {
    var fromCurrency: String
    var toCurrency: String
    var rate: String
    
    enum CodingKeys:String, CodingKey  {
        case fromCurrency = "from"
        case toCurrency = "to"
        case rate = "rate"
    }
}
