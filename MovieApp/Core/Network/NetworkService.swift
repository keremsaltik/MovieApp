//
//  NetworkService.swift
//  MovieApp
//
//  Created by Kerem Saltık on 13.10.2025.
//

import Foundation
import UIKit


struct SuccessResponse: Codable{
    let success: Bool
}

struct DeleteSessionBody: Codable{
    let session_id: String
}


class NetworkService {
    
    // MARK: - Variables
    
    // Singleton
    //static let shared = NetworkService()
    
    // Constants
    private let apiKey = "YOUR_TMDB_API_KEY_HERE"
    private let baseURL = "https://api.themoviedb.org/3"
    
    // Private Initializer
    //private init() {}
    
    init() {}
    
    // MARK: - Functions
    //    func getAMovie(){
    //        guard let url = URL(string: "https://api.themoviedb.org/3/movie/11") else { return }
    //        url?.appending(queryItems: [URLQueryItem(name: "api_key", value: "32dff853b6232823b821631da7bef5ae")])
    //        URLRequest(url: url)
    //    }
    
    func getPopularMovies() async throws -> [MovieModel] {
        var urlComponents = URLComponents(string: "\(baseURL)/movie/popular")
        
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let url = urlComponents?.url else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw URLError(.badServerResponse) }
        
        let decoder = JSONDecoder()
        let movieResponse = try decoder.decode(MovieResponse.self, from: data)
        
        return movieResponse.results
    }
    
    
    func getTopRatedMovies() async throws -> [MovieModel]{
        var urlComponents = URLComponents(string: "\(baseURL)/movie/top_rated")
        
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let url = urlComponents?.url else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw URLError(.badServerResponse) }
        
        print(String(data: data, encoding: .utf8) ?? "Veri String'e dönüştürülemedi")
        
        let decoder = JSONDecoder()
        let movieResponse = try decoder.decode(MovieResponse.self, from: data)
        
        return movieResponse.results
    }
    
    
    func getMoviewsByCategory(byGenre categoryId: Int) async throws -> [MovieModel]{
        var urlComponents = URLComponents(string: "\(baseURL)/discover/movie")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "with_genres", value: String(categoryId))
        ]
        
        guard let url = urlComponents?.url else { throw URLError(.badURL)}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw URLError(.badServerResponse) }
        
        let decoder = JSONDecoder()
        let movieResponse = try decoder.decode(MovieResponse.self, from: data)
        
        return movieResponse.results
    }
    
    
    func getMovieById(movieId id: Int) async throws -> MovieDetailModel {
        
        guard var urlComponents = URLComponents(string: "\(baseURL)/movie/\(id)") else {
            print("❌ Adım 2 Başarısız: URLComponents oluşturulamadı.")
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            print("❌ Adım 2 Başarısız: URL oluşturulamadı.")
            throw URLError(.badURL)
        }
        
        print("➡️ Adım 2: İstek atılan URL: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        print("➡️ Adım 3: Sunucudan yanıt alındı.")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Adım 4 Başarısız: Gelen yanıt bir HTTP yanıtı değil.")
            throw URLError(.badServerResponse)
        }
        
        print("➡️ Adım 4: Yanıt kodu kontrol ediliyor: \(httpResponse.statusCode)")
        
        // Başarılı değilse, nedenini loglayalım.
        if httpResponse.statusCode != 200 {
            print("❌ Adım 4 Başarısız: Sunucudan hatalı yanıt kodu alındı: \(httpResponse.statusCode)")
            print("Gelen Hata Verisi: \(String(data: data, encoding: .utf8) ?? "Okunamadı")")
            throw URLError(.badServerResponse)
        }
        
        print("✅ Adım 4: Sunucudan başarılı yanıt (200 OK) alındı.")
        
        do {
            let decoder = JSONDecoder()
            // ÖNEMLİ: keyDecodingStrategy'yi SİLDİĞİNDEN EMİN OL!
            // decoder.keyDecodingStrategy = .convertFromSnakeCase // <-- BU SATIR OLMAMALI!
            
            let movie = try decoder.decode(MovieDetailModel.self, from: data)
            print("✅ Adım 5: Gelen veri başarıyla MovieDetailModel'e çözümlendi. Film: \(movie.title)")
            return movie
        } catch {
            // Decode işlemi başarısız olursa, hatanın ne olduğunu ve HAM VERİYİ yazdır.
            print("❌ Adım 5 Başarısız: DECODE HATASI. Model ile JSON uyuşmuyor.")
            print("Gelen Ham Veri: \(String(data: data, encoding: .utf8) ?? "Veri okunamadı")")
            print("Detaylı Hata: \(error)")
            
            // Hatanın daha da detaylı dökümünü almak için:
            if let decodingError = error as? DecodingError {
                print("Decoding Error Detayları: \(decodingError)")
            }
            throw error
        }
    }
    
    // for Login
    func getNewToken() async throws -> String{
        var urlComponents = URLComponents(string: "\(baseURL)/authentication/token/new?")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        guard let url = urlComponents?.url else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw URLError(.badServerResponse) }
        
        do{
            let tokenResponse = try JSONDecoder().decode(RequestTokenResponse.self, from: data)
            print("Alınan yoken: \(tokenResponse.request_token)")
            return tokenResponse.request_token
        }
    }
    
    // UI işlemi olacağı için ana thread'de yapılmalı o yüzden main actor dedik.
    @MainActor
    func directToTMDB(with token: String) {
        
        let redirectUrl = "movieapptmdb://auth"
        
        var urlComponents = URLComponents(string: "https://www.themoviedb.org/authenticate/\(token)")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "redirect_to", value: redirectUrl)
        ]
        
        guard let url = urlComponents?.url else {
            print("Yönlendirme URL'si oluşturulamadı.")
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func createSessionID(with approvedToken: String) async throws -> String{
        var urlComponents = URLComponents(string: "\(baseURL)/authentication/session/new")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        guard let url = urlComponents?.url else { throw URLError(.badURL)}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["request_token": approvedToken]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let sessionResponse = try JSONDecoder().decode(SessionResponse.self, from: data)
        return sessionResponse.session_id
        
    }
    
    // Logout
    func deleteSession(sessionId: String) async throws -> Bool{
        var urlComponents = URLComponents(string: "\(baseURL)/authentication/session")
        
        guard let url = urlComponents?.url else { throw URLError(.badURL) }
        
        urlComponents?.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey)
            ]
        
       var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = DeleteSessionBody(session_id: sessionId)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw URLError(.badServerResponse)}
    
        let Response = try JSONDecoder().decode(SuccessResponse.self, from: data)
        return Response.success
    }
    
    
    // Account
    func getAccountDetails(sessionID: String) async throws -> AccountDetailResponse{
        var urlComponents = URLComponents(string: "\(baseURL)/account")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "session_id", value: sessionID)
        ]
        
        guard let url = urlComponents?.url else { throw URLError(.badURL)}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else
        { throw URLError(.badServerResponse) }
        
        
        let decoder = JSONDecoder()
        let accountDetails = try decoder.decode(AccountDetailResponse.self, from: data)
        
        return accountDetails
    }
    
    // Favorite Movies
    func getFavoriteMoviesbyAccount(accountId: Int, sessionID: String) async throws -> FavoriteMoviesModel{
        var urlComponents = URLComponents(string: "\(baseURL)/account/\(accountId)/favorite/movies")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "session_id", value: sessionID),
            URLQueryItem(name: "sort_by", value: "created_at.asc")
        ]
        
        guard let url = urlComponents?.url else { throw URLError(.badURL) }
        
        print("İstek atılan URL: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        
        print("Gelen Ham Veri: \(String(data: data, encoding: .utf8) ?? "Veri okunamadı")")

        
        let decoder = JSONDecoder()
        let movieResponse = try decoder.decode(FavoriteMoviesModel.self, from: data)
        
        return movieResponse
    }
    
}
