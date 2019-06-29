//
//  APIManager.swift
//  SampleDemoApp
//
//  Created by Subhankar on 27/06/19.
//  Copyright © 2019 Subhankar. All rights reserved.
//

import Foundation

class APIManager {
    
    static let baseUrl = "https://a2b7cf8676394fda75de-6e0550a16cd96615f7274fd70fa77109.r93.cf3.rackcdn.com/"
    
    typealias parameters = [String:Any]

    
    enum HTTPMethod: String {
        case get     = "GET"
        case post    = "POST"
        case put     = "PUT"
        case delete  = "DELETE"
    }
    enum RequestError: Error {
        case unknownError
        case connectionError
        case authorizationError([String: Any])
        case invalidRequest
        case notFound
        case invalidResponse
        case serverError
        case serverUnavailable
    }
    
    static func requestData(url: String, method: HTTPMethod, parameters: parameters?, completion: @escaping (Result<Data, RequestError>) -> Void) {
        
        let header =  ["Content-Type": "application/x-www-form-urlencoded"]
        var urlRequest = URLRequest(url: URL(string: baseUrl + url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpMethod = method.rawValue
        
        if let parameters = parameters {
            let parameterData = parameters.reduce("") { (result, param) -> String in
                return result + "&\(param.key)=\(param.value as! String)"
                }.data(using: .utf8)
            urlRequest.httpBody = parameterData
        }
        if CommandLine.arguments.contains("-mockApi") {
            let delay = 2
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                let filePath = "Product"
                if let fileUrl = Bundle.main.url(forResource: filePath, withExtension: "json") {
                    do {
                        let data = try? Data(contentsOf: fileUrl, options: [])
                        if let json = data {
                            completion(.success(json))
                        }
                    } catch (let error) {
                        print(error.localizedDescription)
                        
                    }
                }
            }
        } else {
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print(error)
                    completion(.failure(.connectionError))
                }else if let data = data ,let responseCode = response as? HTTPURLResponse {
                    do {
                        if let responseJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            //                        print("responseCode : \(responseCode.statusCode)")
                            //                        print("responseJSON : \(responseJson)")
                            switch responseCode.statusCode {
                            case 200:
                                completion(.success(data))
                            case 400...499:
                                completion(.failure(.authorizationError(responseJson)))
                            case 500...599:
                                completion(.failure(.serverError))
                            default:
                                completion(.failure(.unknownError))
                                break
                            }
                        }
                    }
                    catch let parseJSONError {
                        completion(.failure(.unknownError))
                        print("error on parsing request to JSON : \(parseJSONError)")
                    }
                }
                }.resume()
        }
        
        
    }
}

