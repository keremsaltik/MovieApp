//
//  SignInView.swift
//  MovieApp
//
//  Created by Kerem Saltık on 24.10.2025.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        ZStack() {
            
            Color.black.ignoresSafeArea()
            
            VStack {
                
                Image("SignInBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height * 0.6)
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            
            VStack{
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.3)
                VStack(alignment: .leading){
                    Spacer()
                    TitleTextView(title: "Sign in", titleFont: Font.App.title1)
                    
                    TitleTextView(title: "You'll find what you're looking for in the ocean of movies", titleFont: Font.App.subtitle)
                        .padding(.top, CGFloat.App.spacingXXXSmall)
                    Button {
                        Task{
                            await viewModel.loginButtonTapped()
                        }
                    } label: {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .font(Font.App.buttonText)
                            .foregroundStyle(Color.App.buttonTextColor)
                            .padding()
                            .background(Color.App.primaryColor)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.top, CGFloat.App.spacingMedium)
                    
                    if let errorMessage = viewModel.errorMessage{
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .padding()
                    }
                    
                }
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .black,
                            .black,
                            .black.opacity(0.8),
                            .clear
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                        .padding(.top, -100)
                )
                
                
            }
        }
        .onOpenURL{
            url in
            Task{
                await sessionManager.handleRedirect(url: url)
            }
        }
        
    }
}
#Preview {
    SignInView()
}
