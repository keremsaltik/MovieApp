//
//  ProductionCompaniesModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 19.10.2025.
//

import Foundation

struct ProductionCompaniesModel: Codable, Hashable,Identifiable{
    let id: Int
    let logoPath: String?
    let name: String
    //let originCountry: String
    
    enum CodingKeys: String, CodingKey{
        case id, name
        //case originCountry = "origin_country"
        case logoPath = "logo_path"
    }
    
    var logoURL: URL?{
        guard let logoPath = logoPath else { return nil}
        
        return URL(string: "https://image.tmdb.org/t/p/w200\(logoPath)")
    }
}
