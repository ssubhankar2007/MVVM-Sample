//
//  HomeViewModel.swift
//  SampleDemoApp
//
//  Created by Subhankar on 26/06/19.
//  Copyright © 2019 Subhankar. All rights reserved.
//

import Foundation

class HomeViewModel {
    var viewDidLoad: ()->() = {}
    var reloadCollection: ()->() = {}
    var completeData: AppData?
    var setPriceCurrency = "INR"
    init() {
        viewDidLoad = { [weak self] in
            self?.requestData(completion: {
                self?.reloadCollection()
            })
        }
    }

    func fetchData() {
        self.requestData(completion: {
            self.reloadCollection()
        })
    }
    func requestData(completion: @escaping()->Void) {
        APIManager.requestData(url: "common/json/assignment.json", method: .get, parameters: nil) { (result) in
            do {
                if let dataType = try? result.get() {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let mainData = try decoder.decode(AppData.self, from: dataType)
                    self.completeData = mainData
                    completion()
                }
            } catch {
                print("Unable to fetch data")
            }
        }
    }
    func updateTimeLabel() -> String {
        let endTime: Double = 1595275200000
        let difference = endTime - Date.timeIntervalSinceReferenceDate
        let hours = floor(difference/60/60)
        let minutes = floor((difference - (hours * 60 * 60)) / 60)
        let seconds = floor(((difference - (hours * 60 * 60)) / 60)/60)
        
        if hours > 0 {
            return "\(hours.clean):\(minutes.clean):\(seconds.clean) Left"
        } else if minutes > 0 {
            return "\(minutes.clean):\(seconds.clean) Left"
        } else if seconds > 0{
            return "\(seconds.clean) Left"
        }
        return "00:00:00"
    }
    func updatePrice(from: String, price: String) -> String {
        var searchParticularConversion = self.completeData?.conversion.filter {$0.fromCurrency == from && $0.toCurrency == self.setPriceCurrency}
        var totalPrice: Float = 0.0
        if searchParticularConversion?.count ?? 0 > 0 {
            if let rate = searchParticularConversion?[0].rate {
                totalPrice = (rate as NSString).floatValue * (price as NSString).floatValue
            }
        } else {
            searchParticularConversion = self.completeData?.conversion.filter {$0.fromCurrency == self.setPriceCurrency && $0.toCurrency == from}
            if searchParticularConversion?.count ?? 0 > 0 {
                if let rate = searchParticularConversion?[0].rate {
                    totalPrice = (price as NSString).floatValue / (rate as NSString).floatValue
                }
            } else {
                totalPrice = (price as NSString).floatValue
            }
        }
        return "\(setPriceCurrency) \(totalPrice.clean)"
    }
}

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
