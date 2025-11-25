//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Kerem Saltık on 16.10.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    
    @ObservedObject var detailViewModel: MovieDetailViewModel
    
    var body: some View {
        if let movie = detailViewModel.movieDetail {
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    
                    // Only Poster and Title
                    MovieDetailHeader(movie: movie)
                    
                    // Info section includes other details
                    MovieDetailInfo(movie: movie)
                    
                }
                
                .toolbar {
                    ToolbarItemGroup(placement: .automatic) {
                        if let movie = detailViewModel.movieDetail, let url = movie.movieURL{
                            ShareLink(item: url){
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                        
                        Button {
                            Task{
                                await detailViewModel.toggleWatchListStatus()
                            }
                        } label: {
                            Image(systemName: detailViewModel.isInWatchList ? "bookmark.fill" : "bookmark")
                        }
                    }
                    .sharedBackgroundVisibility(.automatic)
                }
                .tint(Color.App.primaryColor)
            }
            
            .ignoresSafeArea(edges: .top)
            .navigationTitle(detailViewModel.movieDetail?.title ?? "Loading...")
            .navigationBarTitleDisplayMode(.inline)
            .defaultBackground()
        }
    }
    
    
    private struct MovieDetailHeader: View {
        
        let movie: MovieDetailModel
        
        var body: some View {
            
            ZStack(alignment: .bottomLeading) {
                
                
                WebImage(url: movie.posterURL)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                // Gradient overlay
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                    startPoint: .center,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                // Title
                TitleTextView(title: movie.title, titleFont: Font.App.title2)
                    .padding()
            }
                
            
            /*AsyncImage(url: movie.posterURL){
                phase in
                switch phase {
                case .empty:
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                        ProgressView()
                    }
                    
                case .success(let image):
                    ZStack(alignment: .bottomLeading){
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        
                        TitleTextView(title: movie.title, titleFont: Font.App.title2)
                            .padding()
                    }
                    
                    
                    
                case .failure(_):
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                        Image(systemName: "photo.artframe")
                            .foregroundColor(.white)
                    }
                    
                @unknown default:
                    ZStack{
                        EmptyView()
                    }
                    
                }
            }*/
            
        }
    }
    
    private struct MovieDetailInfo: View {
        
        let movie: MovieDetailModel
        
        var body: some View {
            VStack(alignment: .leading){
                HStack{
                    VStack(alignment: .leading){
                        TitleTextView(title: "Duration", titleFont: Font.App.subtitle.bold())
                        Text(movie.runtimeDivided ?? "N/A")
                            .foregroundStyle(Color.App.secondaryTextColor)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading){
                        TitleTextView(title: "Language", titleFont: Font.App.subtitle.bold())
                        ForEach(movie.spokenLanguages ?? [], id: \.englishName){
                            language in
                            Text(language.englishName)
                                .foregroundStyle(Color.App.secondaryTextColor)
                        }
                    }
                    .padding(.trailing, CGFloat.App.spacingLarge)
                    
                }
                .padding(.top, CGFloat.App.spacingMedium)
                
                
                HStack{
                    VStack(alignment: .leading){
                        TitleTextView(title: "Genre", titleFont: Font.App.subtitle.bold())
                        ForEach(movie.genres ?? []){
                            genre in
                            Text(genre.name)
                                .foregroundStyle(Color.App.secondaryTextColor)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading){
                        TitleTextView(title: "Popularity", titleFont: Font.App.subtitle.bold())
                        Text(String(format: "%.1f", movie.popularity))
                            .foregroundStyle(Color.App.secondaryTextColor)
                    }
                    .padding(.trailing, CGFloat.App.spacingLarge)
                    
                    
                }
                .padding(.top, CGFloat.App.spacingSmall)
                
                TitleTextView(title: "Story", titleFont: Font.App.subtitle.bold())
                    .padding(.top, CGFloat.App.spacingXSmall)
                
                Text(movie.overview ?? "")
                    .padding(.top,CGFloat.App.spacingXXXSmall)
                    .foregroundStyle(Color.App.secondaryTextColor)
                
                
                TitleTextView(title: "Production Countries", titleFont: Font.App.subtitle.bold())
                    .padding(.top, CGFloat.App.spacingSmall)
                
                ScrollView(.horizontal) {
                    HStack{
                        ForEach(movie.productionCountries ?? []){
                            country in
                            Text(country.name)
                                .foregroundStyle(Color.App.secondaryTextColor)
                        }
                    }
                    
                }
                .padding(.top, CGFloat.App.spacingXXXSmall)
                
                
                TitleTextView(title: "Production Companies", titleFont: Font.App.subtitle.bold())
                    .padding(.top,CGFloat.App.spacingXXSmall)
                
                if let companies = movie.productionCompanies, !companies.isEmpty{
                    ProductionCompaniesSection(companies: companies)
                }
                
                
                TitleTextView(title: "Rating & Reviews", titleFont: Font.App.subtitle.bold())
                    .padding(.top, CGFloat.App.spacingLarge)
                
                Text(String(format: "%.1f",movie.voteAverage))
                    .padding(.top,CGFloat.App.spacingXXSmall)
                    .foregroundStyle(Color.App.secondaryTextColor)
            }
            .padding()
        }
    }
}


private struct ProductionCompaniesSection: View {
    
    let companies: [ProductionCompany]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack{
                ForEach(companies, id: \.id){
                    company in
                    VStack{
                        WebImage(url: company.logoURL)
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        /*AsyncImage(url: company.logoURL){
                            phase in
                            if let image = phase.image{
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            else{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.1))
                                    .overlay(
                                        Image(systemName: "building.2")
                                            .foregroundColor(.gray)
                                    )
                            }
                        }*/
                        
                        Text(company.name)
                            .foregroundStyle(Color.App.secondaryTextColor)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(detailViewModel: MovieDetailViewModel(movieId: 13804))
    }
    .preferredColorScheme(.dark)
}
