//
//  ContentView.swift
//  MovieApp
//
//  Created by Kerem Saltık on 13.10.2025.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Variables
    @State var searchQuery: String = ""
    
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject private var viewModel = HomeViewModel()
    
    let textFieldPlaceHolder = "Search for Movie name, actors..."
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                ScrollView{
                    HStack{
                        TitleTextView(title: "Movies Center", titleFont: Font.App.title1)
                        
                        Spacer()
                        
                        NavigationLink(destination: ProfileView()) {
                            if let details = sessionManager.accountDetails {
                                
                                    AsyncImage(url: details.avatarURL) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 44, height: 44)
                                                .clipShape(Circle())
                                        } else {
                                            Image(systemName: "person.circle.fill")
                                                .resizable()
                                                .frame(width: 44, height: 44)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                
                                
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    
                    TextField(text: $searchQuery, prompt: Text(textFieldPlaceHolder)
                        .foregroundStyle(Color.App.secondaryTextColor)) { }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.App.textFieldColor.opacity(0.24))
                        )
                        .padding(.top, CGFloat.App.spacingXXSmall)
                        .foregroundStyle(Color.App.primaryTextColor)
                    
                    
                    
                    
                    VStack(alignment: .leading){
                        TitleTextView(title: "High Rated", titleFont: Font.App.title3)
                        
                        TopRatedMoviesView(topRatedMovies: viewModel.topRatedMovies)
                    }
                    .padding(.top,CGFloat.App.spacingXSmall)
                    
                    
                    VStack(alignment: .leading){
                        HStack{
                            TitleTextView(title: "Drama", titleFont: Font.App.title3)
                            
                            Spacer()
                            
                            Button {
                                // Action when button tapped
                            } label: {
                                Text("Show more")
                                    .foregroundStyle(Color.App.primaryColor)
                                    .font(Font.App.subtitle)
                            }
                        }
                        .padding(.bottom, CGFloat.App.spacingXXXSmall)
                        
                        MovieCategoryView(moviesbyGenre: viewModel.dramaMovies)
                    }
                    
                    .padding(.top, CGFloat.App.spacingMedium)
                    
                    
                    
                    VStack(alignment: .leading){
                        HStack{
                            TitleTextView(title: "Comedy", titleFont: Font.App.title3)
                            
                            Spacer()
                            
                            Button {
                                // Button when tapped
                            } label: {
                                Text("Show More")
                                    .foregroundStyle(Color.App.primaryColor)
                                    .font(Font.App.subtitle)
                            }
                            
                        }
                        .padding(.bottom, CGFloat.App.spacingXXXSmall)
                        
                        MovieCategoryView(moviesbyGenre: viewModel.comedyMovies)
                        
                    }
                    .padding(.top, CGFloat.App.spacingMedium)
                    
                    
                    
                }
                .padding(.horizontal, CGFloat.App.spacingXXSmall)
                .padding(.top, CGFloat.App.spacingXLarge)
                .ignoresSafeArea()
                //.navigationTitle("Movie Center")
                
                
                
                .navigationDestination(for: MovieModel.self) { movie in
                    // Kural: MovieModel tipinde veri gelirse,
                    // o 'movie' objesini kullanarak bu hedefi oluştur
                    //  MovieDetailView(detailViewModel: MovieDetailViewModel(movieId: movie.id))
                    TestView(id: movie.id)
                }
                .task {
                    await viewModel.fetchTopRatedMovies()
                    await viewModel.fetchDramaMovies()
                    await viewModel.fetchComedyMovies()
                }
            }
            .background(.black)
            
        }
        
        
        .tint(.white)
    }
    
    
}


#Preview {
    HomeView()
         .environmentObject(SessionManager())
}
