//
//  MovieCategoryView.swift
//  MovieApp
//
//  Created by Kerem Saltık on 16.10.2025.
//

import SwiftUI

struct MovieCategoryView: View {
    
    //MARK: - Variables
    let moviesbyGenre: [MovieModel]

    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(moviesbyGenre.prefix(10)) { movie in
                    NavigationLink(value: movie){
                        MovieCard(movie: movie, width: 208, height: 275)
                        
                    }
                    .buttonStyle(.plain)
                    
                    
                }
            }
            
        }
    }
}

