//
//  MovieCard.swift
//  MovieApp
//
//  Created by Kerem Saltık on 16.10.2025.
//

import SwiftUI

struct MovieCard<T:DisplayableMedia>: View {
    
    let movie: T
    let width: CGFloat
    let height: CGFloat?
    

    
    var body: some View {
        
        AsyncImage(url: movie.posterURL){ image in
            switch image {
            case .success(let img):
                img
                
                    .resizable()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                
            case .failure(_):
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                    Image(systemName: "photo.artframe")
                        .foregroundColor(.white)
                }
                
            case .empty:
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                    ProgressView()
                    
                }
            @unknown default:
                EmptyView()
            }
            
        }
        
    }
}
