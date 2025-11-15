//
//  SpokenLanguagesModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 19.10.2025.
//

import Foundation


struct SpokenLanguagesModel: Codable, Identifiable, Hashable{
    let id = UUID() // for ForEach
    let englishName : String
    
    enum CodingKeys: String, CodingKey{
        case englishName = "english_name"
    }
    
}
