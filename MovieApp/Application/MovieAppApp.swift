//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Kerem Saltık on 13.10.2025.
//

import SwiftUI

@main
struct MovieAppApp: App {
    
    @StateObject private var sessionManager = SessionManager()
    @State private var navigationPath = NavigationPath()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()


        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {

                Color.black.ignoresSafeArea()

                if sessionManager.isLoadingAuthentication {
                    ProgressView()
                        .controlSize(.large)
                } else {
                    NavigationStack(path: $navigationPath) {
                        
                        Group {
                            if sessionManager.isLoggedIn {
                                HomeView(navigationPath: $navigationPath)
                            } else {
                                SignInView()
                            }
                        }
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .profile:
                                ProfileView()
                            case .movie(let movie):
                                MovieDetailView(
                                    detailViewModel: MovieDetailViewModel(movieId: movie.id)
                                )
                            case .search(let query):
                                SearchView(query: query)
                            case .genre(let id, let name):
                                GenreView(viewModel: GenreViewModel(genreId: id), genreName: name)
                            }
                        }
                    }
                }
            }
            .environmentObject(sessionManager)
            .task {
                await sessionManager.checkAuthentication()
            }
        }
    }
}
