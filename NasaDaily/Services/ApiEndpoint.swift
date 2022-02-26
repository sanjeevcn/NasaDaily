//
//  ApiEndpoint.swift
//  NasaDaily
//
//  Created by Sanjeev on 26/02/22.
//

import Foundation

enum ApiEndpoint {
    case fetchPicOfDay(String?)
    
    var baseUrl: String {
        return "https://api.nasa.gov"
    }
    
    var path: String {
        switch self {
        case .fetchPicOfDay:
            return "/planetary/apod"
        }
    }
    
    var description: String {
        return baseUrl + path
    }
    
    var apiKey: String {
        return "LSfrUWwcXHuBbFJ9REpcUp8ZCiCllbP8LqmY9daZ"
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .fetchPicOfDay(let date):
            if let validDate = date {
                return [.init(name: "api_key", value: apiKey),
                 .init(name: "date", value: validDate)]
            } else {
                return [.init(name: "api_key", value: apiKey)]
            }
        }
    }
    
    var httpMethod: String {
        switch self {
        case .fetchPicOfDay:
            return "GET"
        }
    }
    
    var request: URLRequest {
        var urlComponents: URLComponents = URLComponents(string: baseUrl)!
        urlComponents.path = path
        
        if queryItems.count > 0 {
            urlComponents.queryItems = queryItems
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = httpMethod
        
        if httpMethod == "POST" {}//POST Request body
        debugPrint(request)
        return request
    }
}

extension ApiEndpoint: Equatable {
    static func == (lhs: ApiEndpoint, rhs: ApiEndpoint) -> Bool {
        return lhs.path == rhs.path
    }
}
