//
//  ProductionCountriesModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 19.10.2025.
//

import Foundation

struct ProductionCountriesModel: Codable, Hashable, Identifiable{
    let id = UUID()
    let iso: String
    let name: String
    
    enum CodingKeys: String, CodingKey{
        case name
        case iso = "iso_3166_1"
        
    }
    
}
