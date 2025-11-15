//
//  MovieModedl.swift
//  MovieApp
//
//  Created by Kerem Saltık on 13.10.2025.
//

import Foundation


struct MovieResponse: Codable{
    let results: [MovieModel]
}

// Movie Model
// Identifiable was used for SwiftUI list
struct MovieModel: Codable, Identifiable, Hashable, DisplayableMedia{
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    let popularity: Double
    let genreIds: [Int]?
    
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
        
    }
    
    var posterURL: URL?{
        guard let posterPath = posterPath else { return nil }
        // Base URL + size + FilePath
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}

extension MovieModel {
    
    // Bu, liste ekranları için basit bir mock
    static var mock: MovieModel {
        MovieModel(
                    id: 11,
                    title: "Star Wars",
                    overview: "A long time ago in a galaxy far, far away...",
                    posterPath: "/6FfCtAuLGro8tTZ6iVdVTtrvfbO.jpg",
                    voteAverage: 8.2,
                    // Liste ekranı için bu detaylara ihtiyacımız yok, boş diziler verebiliriz.
                    popularity: 150.0,
                    genreIds: [],
                   
                )
    }
    
    
}
