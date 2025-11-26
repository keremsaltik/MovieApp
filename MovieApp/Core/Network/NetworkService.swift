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

struct AddMovieToWatchListBody: Codable{
    let media_type: String
    let media_id: Int
    let watchlist: Bool
}


struct AccountState: Codable{
    let id: Int
    let favorite: Bool
    let watchlist: Bool
}

class NetworkService {
    
    // MARK: - Variables
    
    // Singleton
    //static let shared = NetworkService()
    
    private let session: URLSession
    
    // Constants
    private let apiKey = K.API.apiKey
    private let baseURL = K.API.baseURL
    
    // Private Initializer
    //private init() {}
    
    init() {
        
        let configuration = URLSessionConfiguration.default
        
        
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: - Functions
    //    func getAMovie(){
    //        guard let url = URL(string: "https://api.themoviedb.org/3/movie/11") else { return }
    //        url?.appending(queryItems: [URLQueryItem(name: "api_key", value: "32dff853b6232823b821631da7bef5ae")])
    //        URLRequest(url: url)
    //    }
    
    
    
    // MARK: - DON'T REPEAT YORUSELF
    private func performRequsest<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.requestFailed(description: "Invalid server response. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
            
        }catch let error as DecodingError{
            throw APIError.decodingFailed(description: error.localizedDescription)
        }catch{
            throw APIError.requestFailed(description: error.localizedDescription)
        }
    }
    
    // MARK: - MOVIES
    func getPopularMovies() async throws -> MovieResponse {
        var urlComponents = URLComponents(string: "\(baseURL)/movie/popular")
        
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let url = urlComponents?.url else { throw APIError.invalidURL }
        
        return try await performRequsest(url: url)
    }
    
    
    func getTopRatedMovies() async throws -> MovieResponse{
        var urlComponents = URLComponents(string: "\(baseURL)/movie/top_rated")
        
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let url = urlComponents?.url else { throw APIError.invalidURL }
        
       return try await performRequsest(url: url)
    }
    
    
    func getMoviewsByCategory(byGenre categoryId: Int, page: Int = 1) async throws -> MovieResponse{
        var urlComponents = URLComponents(string: "\(baseURL)/discover/movie")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "with_genres", value: String(categoryId)),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let url = urlComponents?.url else { throw APIError.invalidURL}
        
        return try await performRequsest(url: url)
    }
    
    
    func getMovieById(movieId id: Int) async throws -> MovieDetailModel {
        
        guard var urlComponents = URLComponents(string: "\(baseURL)/movie/\(id)") else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        return try await performRequsest(url: url)
    }
    
    
    func searchMovies(query: String, page: Int) async throws -> MovieResponse{
        var urlComponents = URLComponents(string: "\(baseURL)/search/movie")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let url = urlComponents?.url else { throw APIError.invalidURL }
        
        return try await performRequsest(url: url)
        
        
    }
    
    // for Login
    func getNewToken() async throws -> String{
        var urlComponents = URLComponents(string: "\(baseURL)/authentication/token/new?")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        guard let url = urlComponents?.url else { throw APIError.invalidURL }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {  throw APIError.requestFailed(description: "Invalid server response. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)") }
        
        do{
            let tokenResponse = try JSONDecoder().decode(RequestTokenResponse.self, from: data)
            return tokenResponse.request_token
        }catch let error as DecodingError {
            throw APIError.decodingFailed(description: error.localizedDescription)
        } catch {
            throw APIError.requestFailed(description: error.localizedDescription)
        }
    }
    
    
    @MainActor
    func directToTMDB(with token: String) {
        
        let redirectUrl = "movieapptmdb://auth"
        
        var urlComponents = URLComponents(string: "https://www.themoviedb.org/authenticate/\(token)")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "redirect_to", value: redirectUrl)
        ]
        
        guard let url = urlComponents?.url else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func createSessionID(with approvedToken: String) async throws -> String{
        var urlComponents = URLComponents(string: "\(baseURL)/authentication/session/new")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        guard let url = urlComponents?.url else { throw APIError.invalidURL}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["request_token": approvedToken]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.requestFailed(description: "Invalid server response. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
        }
        do{
            let sessionResponse = try JSONDecoder().decode(SessionResponse.self, from: data)
            return sessionResponse.session_id
        }catch let error as DecodingError {
            throw APIError.decodingFailed(description: error.localizedDescription)
        } catch {
            throw APIError.requestFailed(description: error.localizedDescription)
        }
    }
    
    // Logout
    func deleteSession(sessionId: String) async throws -> Bool{
        guard var urlComponents = URLComponents(string: "\(baseURL)/authentication/session") else {
                throw APIError.invalidURL
            }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        guard let url = urlComponents.url else { throw APIError.invalidURL }
        
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = DeleteSessionBody(session_id: sessionId)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {  throw APIError.requestFailed(description: "Invalid server response. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")}
        
        do{
            let response = try JSONDecoder().decode(SuccessResponse.self, from: data)
            return response.success
        }catch let error as DecodingError {
            
            throw APIError.decodingFailed(description: error.localizedDescription)
        } catch {
            throw APIError.requestFailed(description: error.localizedDescription)
        }
        
    }
    
    // MARK: - ACCOUNT
    
    // Account Details
    func getAccountDetails(sessionID: String) async throws -> AccountDetailResponse{
        var urlComponents = URLComponents(string: "\(baseURL)/account")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: K.Keychain.sessionID, value: sessionID)
        ]
        
        guard let url = urlComponents?.url else { throw APIError.invalidURL}
        
        return try await performRequsest(url: url)
    }
    
    // Favorite Movies
    func getWatchListMoviesbyAccount(accountId: Int, sessionID: String) async throws -> MovieResponse{
        var urlComponents = URLComponents(string: "\(baseURL)/account/\(accountId)/watchlist/movies")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: K.Keychain.sessionID, value: sessionID),
            URLQueryItem(name: "sort_by", value: "created_at.asc")
        ]
        
        guard let url = urlComponents?.url else { throw APIError.invalidURL }
        
        return try await performRequsest(url: url)
    }
    
    func addMovieToWatchlist(sessionId: String, accountId: Int, body: AddMovieToWatchListBody) async throws -> SuccessResponse {
        
        let urlString = "\(baseURL)/account/\(accountId)/watchlist"
        
        guard var urlComponents = URLComponents(string: urlString) else {
            throw APIError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: K.API.apiKey),
            URLQueryItem(name: "session_id", value: sessionId)
        ]
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
    
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            let errorData = String(data: data, encoding: .utf8) ?? "Hata mesajı okunamadı"

            throw APIError.requestFailed(description: "Server returned status code \((response as? HTTPURLResponse)?.statusCode ?? 0)")
        }
        
        return try JSONDecoder().decode(SuccessResponse.self, from: data)
    }
    
    func getAccountStates(for movieID: Int, sessionID: String) async throws -> AccountState{
        var urlComponents = URLComponents(string: "\(baseURL)/movie/\(movieID)/account_states")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: K.Keychain.sessionID, value: sessionID)
        ]
        
        guard let url = urlComponents?.url else { throw APIError.invalidURL }
        
        return try await performRequsest(url: url)
        
    }
    
    
}
