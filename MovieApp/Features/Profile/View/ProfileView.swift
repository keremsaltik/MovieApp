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
    @State private var isLoadingFavorites = true
    @State private var hasAppeared = false
    
    @State private var showingLogoutAlert = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            TitleTextView(title: "Profile", titleFont: .title2)
                .padding(.horizontal, CGFloat.App.spacingXXSmall)
            
            if let details = sessionManager.accountDetails{
                HStack{
                    AsyncImage(url: details.avatarURL){
                        phase in
                        if let image = phase.image{
                            image
                                .resizable()
                                .frame(width: 56, height: 56)
                                .clipShape(Circle())
                        }
                        else{
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 56, height: 56)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Text(details.username)
                        .font(.title3)
                    
                    Spacer()
                    
                }
                .padding()
                .background(.dark2, in: RoundedRectangle(cornerRadius: 8))
                .padding(.top, CGFloat.App.spacingMedium)
                .padding(.horizontal, CGFloat.App.spacingXXSmall)
                .foregroundStyle(Color.App.primaryTextColor)
                
            }
            
            
            TitleTextView(title: "SavedMovies", titleFont: .title3)
                .padding(.top, CGFloat.App.spacingSmall)
                .padding(.horizontal, CGFloat.App.spacingXXSmall)
            
            
            if isLoadingFavorites {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: 240)
                    .padding()
            }else{
                
                
                ScrollView(.vertical){
                    LazyVGrid(columns: columns){
                        ForEach(viewModel.favoriteMovies){
                            movie in
                            NavigationLink(value: Route.movie(movie)){
                                ZStack{
                                    MovieCard(movie: movie, width: 172, height: 237)
                                }
                                
                                .disabled(isLoadingFavorites)
                            }
                        }
                        .padding(.horizontal, CGFloat.App.spacingXXSmall)
                    }
                    
                }
            }
            
            
            
        }
        .onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            
            Task {
                await viewModel.fetchFavoriteMovies()
                await MainActor.run {
                    isLoadingFavorites = false
                }
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingLogoutAlert = true
                } label: {
                    Text("Signout")
                        .foregroundStyle(.red)
                }
            }
        }
        
        .alert("Signout", isPresented: $showingLogoutAlert) {
            Button("Signout", role: .destructive){
                Task{
                    await sessionManager.logout()
                }
                
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to end the session?")
        }
        
        .defaultBackground()
        .navigationTitle("Profile")
        
    }
    
}

#Preview {
    ProfileView()
        .environmentObject(SessionManager())
}
