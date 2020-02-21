//
//  FilterTypeEnum.swift
//  movs
//
//  Created by Emerson Victor on 09/12/19.
//  Copyright © 2019 emer. All rights reserved.
//

import Foundation

enum FilterType: String, CaseIterable, Comparable {
    case date = "Date"
    case genre = "Genre"
    
    var values: [String] {
        let dataRepository = DataRepository()
        switch self {
        case .date:
            let movieMinYear = dataRepository.localStorage.favorites.min { (lmovie, rmovie) -> Bool in
                return Int(lmovie.releaseDate)! < Int(rmovie.releaseDate)!
            }
            
            if let minYear = Int(movieMinYear?.releaseDate ?? "") {
                let currentYear = Int(Calendar.current.component(.year, from: Date()))
                return Array(minYear...currentYear).map({ year in String(year)})
            } else {
                return []
            }
        case .genre:
            return Array(dataRepository.localStorage.genres.values).sorted()
        }
    }
    
    static func < (lhs: FilterType, rhs: FilterType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
