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
    
    // --- MEVCUT ÖZELLİKLERİNİ GÜNCELLEYELİM ---
    let id: Int
    let title: String
    let overview: String? // Overview bazen boş gelebilir, optional yapmak daha güvenli.
    let posterPath: String?
    let voteAverage: Double
    let spokenLanguages: [SpokenLanguagesModel]
    let popularity: Double
    private let runtime: Int?
    let genres: [GenreModel]?
    let productionCountries: [ProductionCountriesModel]?
    let productionCompanies: [ProductionCompaniesModel]?
    
    // --- EKSİK OLAN ÖNEMLİ ÖZELLİKLERİ EKLEYELİM ---
    let backdropPath: String?
    let releaseDate: String?
    let voteCount: Int
    
    // --- CodingKeys ENUM'UNU GÜNCELLEYELİM ---
    // Bu enum, Swift'teki değişken adlarınla JSON'daki anahtar adlarını eşleştirir.
    enum CodingKeys: String, CodingKey {
        case id, title, popularity, runtime, overview, genres
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case spokenLanguages = "spoken_languages"
        case productionCountries = "production_countries"
        case productionCompanies = "production_companies"
        
        // Eklediğimiz yeni alanları da buraya ekliyoruz.
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteCount = "vote_count"
    }
    
    // --- SENİN YARDIMCI FONKSİYONLARIN (DOKUNULMAYACAK) ---
    
    var posterURL: URL? {
        // Bu kodun aynı kalıyor, harika.
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var runtimeDivided: String? {
        // Bu kodun da aynı kalıyor, harika.
        // Sadece küçük bir iyileştirme:
        guard let duration = runtime, duration > 0 else { return nil } // Boş string yerine nil dönmek daha iyi.
        
        let hour: Int = duration / 60
        let minute: Int = duration % 60 // Double'a çevirmeye gerek yok.
        
        if hour > 0 && minute > 0 {
            return "\(hour)h \(minute)m"
        } else if hour > 0 {
            return "\(hour)h"
        } else if minute > 0 {
            return "\(minute)m"
        } else {
            return nil
        }
    }
    
    
    // BU, DETAY EKRANI İÇİN ZENGİN BİR MOCK
    /*static var mockDetail: MovieDetailModel{
        MovieDetailModel(
            id: 27205,
            title: "Inception",
            overview: "Cobb, a skilled thief who commits corporate espionage by infiltrating the subconscious of his targets is offered a chance to regain his old life as payment for a task considered to be impossible: \"inception\".",
            posterPath: "/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg",
            voteAverage: 8.36,
            // Sahte 'spokenLanguages' dizisi
            spokenLanguages: [
                SpokenLanguagesModel(englishName: "English"),
                SpokenLanguagesModel(englishName: "Japanese")
            ],
            popularity: 123.456,
            runtime: 148, // Süreyi dakika olarak veriyoruz
            // Sahte 'genres' dizisi
            genres: [
                GenreModel(id: 28, name: "Action"),
                GenreModel(id: 878, name: "Science Fiction"),
                GenreModel(id: 12, name: "Adventure")
            ],
            // Sahte 'productionCountries' dizisi
            productionCountries: [
                ProductionCountriesModel(iso: "US", name: "United States of America"),
                ProductionCountriesModel(iso: "GB", name: "United Kingdom")
            ],
            // Sahte 'productionCompanies' dizisi
            productionCompanies: [
                ProductionCompaniesModel(id: 923, logoPath: "/effbA2yUrwzxp_P3a1a2GjR2L7b.png", name: "Legendary Pictures"),
                ProductionCompaniesModel(id: 9996, logoPath: "/99Z3GGCDzMxb6eCRZFG2T8fCZ3g.png", name: "Syncopy")
            ]
        )
    }*/
}
