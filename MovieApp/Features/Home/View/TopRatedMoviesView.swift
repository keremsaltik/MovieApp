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
            Text("Top Rated")
                .padding(.top, 24)
            
            
            TabView {
                ForEach(topRatedMovies.prefix(10)){
                    movie in
                    NavigationLink(value: movie){
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
                                /// TODO: MOVIE GENRE AND TIME WILL BE UPDATED
                                Text("Action: 2 hr 9 min")
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
        .frame(height: 429)
        .padding(.top,8)
        .tabViewStyle(.page)
    }
}


