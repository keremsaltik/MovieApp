//
//  MovieDetailModel.swift
//  MovieApp
//
//  Created by Kerem Saltık on 23.10.2025.
//

import Foundation

struct MovieDetailResponse: Codable{
    let results: [MovieModel]
}

struct MovieDetailModel: Codable, Identifiable, Hashable {
    
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let adult: Bool
    let runtime: Int?
    let genres: [Genre]?
    let spokenLanguages: [SpokenLanguage]?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    
    
    
    enum CodingKeys: String, CodingKey {
            case id, title, overview, popularity, adult, runtime, genres
            case posterPath = "poster_path"
            case backdropPath = "backdrop_path"
            case releaseDate = "release_date"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case spokenLanguages = "spoken_languages"
            case productionCompanies = "production_companies"
            case productionCountries = "production_countries"
        }
    
    
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var runtimeDivided: String? {
        guard let duration = runtime, duration > 0 else { return nil }
        let hour = duration / 60
        let minute = duration % 60
        return "\(hour)h \(minute)m"
    }
    
    var movieURL: URL? {
        return URL(string: "https://www.themoviedb.org/movie/\(id)")
    }
}

struct Genre: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}

struct ProductionCompany: Codable, Identifiable, Hashable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
    
    var logoURL: URL?{
        guard let logoPath = logoPath else { return nil}
        
        return URL(string: "https://image.tmdb.org/t/p/w200\(logoPath)")
    }
    
    enum CodingKeys: String, CodingKey {
            case id, name
            case logoPath = "logo_path"
            case originCountry = "origin_country"
        }
}

struct ProductionCountry: Codable, Hashable, Identifiable {
    var id = UUID()

    let iso3166_1: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
           case name
           case iso3166_1 = "iso_3166_1"
       }
}

struct SpokenLanguage: Codable, Hashable {
    let englishName: String
    let iso: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
            case name
            case englishName = "english_name"
            case iso = "iso_639_1"
        }
}

