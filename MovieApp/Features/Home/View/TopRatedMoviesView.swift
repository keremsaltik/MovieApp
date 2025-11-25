//
//  TopRatedMoviesView.swift
//  MovieApp
//
//  Created by Kerem Saltık on 16.10.2025.
//

import SwiftUI

struct TopRatedMoviesView: View {
    
    // MARK: - Variables
    let topRatedMovies: [MovieModel]
    
    var body: some View {
        VStack(alignment: .leading){
            TitleTextView(title: "Top Rated", titleFont: Font.App.title3)
                .padding(.top, 24)
            
            
            ScrollView(.horizontal) {
                HStack{
                    ForEach(topRatedMovies){
                        movie in
                        NavigationLink(value: Route.movie(movie)){
                            ZStack(alignment: .bottomLeading){
                                MovieCard(movie: movie, width: 355, height: nil)
                                
                                
                                
                                
                                VStack(alignment: .leading, spacing: 4){
                                    Text(movie.title)
                                        .foregroundStyle(.white)
                                    HStack{
                                        ForEach(0..<5) { index in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(index < Int(movie.voteAverage / 2) ? .yellow : .gray.opacity(0.5))
                                        }
                                    }
                                    
                                    Text(String(format: "%.1f", movie.voteAverage))
                                        .foregroundStyle(.white)
                                    
                                }
                                .frame(maxWidth: .infinity ,alignment: .leading)
                                .padding(.leading)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
        }
        .frame(height: 429)
        .padding(.top,8)
        .tabViewStyle(.page)
    }
}


