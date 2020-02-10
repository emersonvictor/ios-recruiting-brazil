//
//  Endpoint.swift
//  movs
//
//  Created by Emerson Victor on 10/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import Foundation

struct Endpoint {
    var base: String
    var path: String
    var queries: [URLQueryItem]
    var url: URL? {
        guard var components = URLComponents(string: self.base) else {
            return nil
        }
        
        components.path += self.path
        components.queryItems = self.queries
        return components.url
    }
    
    init(type: EndpointType, path: String, queries: [URLQueryItem]) {
        self.base = type.rawValue
        self.path = path
        self.queries = [URLQueryItem(name: "api_key", value: "ba993d6b1312f03c80a322c3e00fab4d")]
        self.queries.append(contentsOf: queries)
    }
    
    init(type: EndpointType, path: String) {
        self.base = type.rawValue
        self.path = path
        self.queries = [URLQueryItem(name: "api_key", value: "ba993d6b1312f03c80a322c3e00fab4d")]
    }
    
    enum EndpointType: String {
        case movie = "https://api.themoviedb.org/3"
        case image = "http://image.tmdb.org/t/p/w500"
    }
}
