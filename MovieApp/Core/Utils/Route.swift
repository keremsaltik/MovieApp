//
//  Route.swift
//  MovieApp
//
//  Created by Kerem Saltık on 17.11.2025.
//

import Foundation

enum Route: Hashable{
    case movie(MovieModel)
    case profile
    case search(String)
    case genre(id: Int, name: String)
}
