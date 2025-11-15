//
//  ProfileView.swift
//  MovieApp
//
//  Created by Kerem Saltık on 8.11.2025.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel = ProfileViewModel()
    
    
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TitleTextView(title: "Profile", titleFont: .title2)
                    .padding(.horizontal, CGFloat.App.spacingXXSmall)
                
                if let details = sessionManager.accountDetails{
                    Button {
                        
                    } label: {
                        HStack{
                            AsyncImage(url: details.avatarURL){
                                phase in
                                if let image = phase.image{
                                    image
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                        .clipShape(Circle())
                                }
                                else{
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                        .foregroundColor(.gray)
                                }
                            }
                            VStack{
                                Text(details.username)
                                    .font(.title3)
                                Text(details.name ?? "")
                            }
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.top, CGFloat.App.spacingMedium)
                    .padding(.horizontal, CGFloat.App.spacingXXSmall)
                    .foregroundStyle(Color.App.primaryTextColor)
                }
                
                
                TitleTextView(title: "SavedMovies", titleFont: .title3)
                    .padding(.top, CGFloat.App.spacingSmall)
                    .padding(.horizontal, CGFloat.App.spacingXXSmall)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack{
                        ForEach(viewModel.favoriteMovies){
                            movie in
                            NavigationLink(value: movie){
                                ZStack{
                                    MovieCard(movie: movie, width: 172, height: 237)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, CGFloat.App.spacingXXSmall)
                    }
                    .frame(height: 240)
                    
                }
                Spacer()
                
                
            }
            .background(.black)
            
            
            .navigationDestination(for: Result.self, destination: { movie in
               // MovieDetailView(detailViewModel: MovieDetailViewModel(movieId: movie.id))
                TestView(id: movie.id)
            })
            
            .onAppear {
                if viewModel.favoriteMovies.isEmpty{
                    Task{
                        await viewModel.fetchFavoriteMovies()
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout", role: .destructive){
                        showingLogoutAlert = true
                    }
                }
            }
            
            .alert("Logout", isPresented: $showingLogoutAlert) {
                Button("Logout", role: .destructive){
                    Task{
                        await sessionManager.logout()
                    }
                }
                Button("Vazgeç", role: .cancel) { }
            } message: {
                Text("Oturumu sonlandırmak istediğinizden emin misiniz?")
            }
        }
    }
    
}

#Preview {
    /*ProfileView()
     .environmentObject(SessionManager())*/
}
