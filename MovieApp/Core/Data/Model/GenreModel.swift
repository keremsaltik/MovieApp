//
//  GenreModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 19.10.2025.
//

import Foundation

struct GenreModel: Codable,Hashable, Identifiable{
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey{
        case id, name
    }
}
