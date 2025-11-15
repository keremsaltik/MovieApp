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
                    
//                    Text("Email")
//                        .foregroundStyle(Color.App.secondaryTextColor)
//                        .font(Font.App.subtitle)
//                        .padding(.top, CGFloat.App.spacingSmall)
//                    
//                    
//                    TextField(text: $mail, prompt: Text("Academy23gmail.com")
//                        .foregroundStyle(Color.App.secondaryTextColor)) { }
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10)
//                            .fill(Color.App.textFieldColor.opacity(0.24))
//                        )
//                    .padding(.top, CGFloat.App.spacingXXXSmall)
//                    .foregroundStyle(Color.App.primaryTextColor)
//                    
//                    
//                    Text("Password")
//                        .foregroundStyle(Color.App.secondaryTextColor)
//                        .font(Font.App.subtitle)
//                        .padding(.top, CGFloat.App.spacingXSmall)
//                    
//                    
//                    TextField(text: $password, prompt: Text("*****")
//                        .foregroundStyle(Color.App.secondaryTextColor)) { }
//                    .padding(.top, CGFloat.App.spacingXXXSmall)
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.App.textFieldColor.opacity(0.24))
//                    )
//                    .foregroundStyle(Color.App.primaryTextColor)
                    
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
                    // Bu efekti yaratmak için birkaç yöntem var. Eğer resmin altını karartmak istiyorsak, en temiz yol bir ZStack oluşturmaktır. En alt katmana ana rengi, onun üzerine resmi koyarım. En üste de, içeriği barındıran VStack'in .background'ına, alttan üste doğru şeffaflaşan bir LinearGradient ekleyerek hem keskin geçişi yumuşatır hem de metinlerin okunabilirliğini artırırım."
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
        // Neden? -> Uygulamaya "movieapptmdb://" URL'si ile geri dönüldüğünde
                // bu kod bloğu tetiklenir. Olayı doğrudan ViewModel'e paslarız.
        .onOpenURL{
            url in
            
            print("Geri dönen url: \(url)")
            
            Task{
                await viewModel.handleRedirect(url: url)
            }
        }
        
    }
}
#Preview {
    SignInView()
}
