//
//  MovieAPIService.swift
//  movs
//
//  Created by Emerson Victor on 02/12/19.
//  Copyright © 2019 emer. All rights reserved.
//

import Foundation
import UIKit

final class MovieAPIService {
    func fetch<DecodingType: Decodable>(from url: URL,
                                        completion: @escaping (Result<DecodingType, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let defaultError = NSError(domain: "error", code: 0, userInfo: nil)
            
            guard let _ = response, let data = data, error == nil else {
                completion(.failure(error ?? defaultError))
                return
            }
            
            if let result = try? JSONDecoder().decode(DecodingType.self, from: data) {
                completion(.success(result))
                return
            } else {
                completion(.failure(defaultError))
            }
        }.resume()
    }
    
    func fetchPoster(from url: URL,
                     completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let error = NSError(domain: "error", code: 0, userInfo: nil)
            guard let _ = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            if let poster = UIImage(data: data) {
                completion(.success(poster))
                return
            } else {
                completion(.failure(error))
            }
        }.resume()
    }
}
