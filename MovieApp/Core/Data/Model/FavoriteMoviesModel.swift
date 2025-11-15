//
//  FavoriteMoviesModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 9.11.2025.
//

import Foundation

struct Result: Codable, Identifiable, Hashable, DisplayableMedia{
    let adult: Bool
    let backdropPath: String
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    
    enum CodingKeys: String, CodingKey {
        case adult, id, popularity,  title, video, overview
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    var posterURL: URL?{
        guard let posterPath = posterPath else { return nil }
        
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}


struct FavoriteMoviesModel: Codable{
    let page: Int
    let results: [Result]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
