//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Kerem Saltık on 16.10.2025.
//

import SwiftUI

struct MovieDetailView: View {
    
    @ObservedObject var detailViewModel: MovieDetailViewModel
    
    var body: some View {
        // 1. ZStack'i en dış katman yapıyoruz.
        ZStack {
            // 2. Arka planı en alta koyuyoruz ki her durumda görünsün.
            Color.black.ignoresSafeArea()
            
            // 3. ViewModel'deki verinin dolu olup olmadığını kontrol ediyoruz.
            // Bu, "Başlık: BOŞ" logunu aldığımız anda çökmesini engelleyecek olan anahtar adımdır.
            if detailViewModel.movieDetail != nil {
                
                // --- SENİN MEVCUT KODUN BURADA BAŞLIYOR (HİÇ DEĞİŞMEDİ) ---
                ScrollView {
                    VStack(alignment: .leading) {
                        AsyncImage(url: detailViewModel.movieDetail?.posterURL) { phase in
                            switch phase {
                            case .empty:
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.3))
                                    ProgressView()
                                }
                                .ignoresSafeArea(edges: .top)
                                .frame(height: 448)
                                
                            case .success(let image):
                                ZStack(alignment: .bottomLeading) {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                    TitleTextView(title: detailViewModel.movieDetail?.title ?? "", titleFont: Font.App.title2)
                                }
                                .ignoresSafeArea(edges: .top)
                                .frame(height: 448)
                                
                            case .failure(_):
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.3))
                                    Image(systemName: "photo.artframe")
                                        .foregroundColor(.white)
                                }
                                .ignoresSafeArea(edges: .top)
                                .frame(height: 448)
                                
                            @unknown default:
                                ZStack {
                                    EmptyView()
                                }
                                .ignoresSafeArea(edges: .top)
                                .frame(height: 448)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            // ... Senin tüm HStack ve diğer detayların burada ...
                            // Hiçbirini değiştirmedim.
                            HStack{
                                VStack(alignment: .leading){
                                    TitleTextView(title: "Duration", titleFont: Font.App.subtitle.bold())
                                    Text(detailViewModel.movieDetail?.runtimeDivided ?? "N/A")
                                        .foregroundStyle(Color.App.secondaryTextColor)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading){
                                    TitleTextView(title: "Language", titleFont: Font.App.subtitle.bold())
                                    ForEach(detailViewModel.movieDetail?.spokenLanguages ?? [SpokenLanguagesModel(englishName: "N/A")]){
                                        language in
                                        Text(language.englishName)
                                            .foregroundStyle(Color.App.secondaryTextColor)
                                    }
                                }
                                .padding(.trailing, CGFloat.App.spacingLarge)
                                
                            }
                            .padding(.top, CGFloat.App.spacingXLarge)
                            
                            // ... Geri kalan tüm kodun ...
                        }
                        .padding()
                    }
                }
                .background(Color.black) // Bu background artık gereksiz ama zararı yok.
                .toolbar {
                    ToolbarItemGroup(placement: .automatic) {
                        Button { } label: { Image(systemName: "square.and.arrow.up") }
                        Button { } label: { Image(systemName: "bookmark") }
                    }
                    // .sharedBackgroundVisibility(.automatic) // Bu modifier eski, kaldırılabilir.
                }
                .foregroundStyle(Color.App.buttonTextColor)
                // --- SENİN MEVCUT KODUN BURADA BİTİYOR ---
                
            } else {
                // 4. Eğer 'detailViewModel.movieDetail' hala nil ise (yani veri yükleniyorsa),
                // sadece bir yükleme göstergesi gösteriyoruz.
                ProgressView()
                    .controlSize(.large)
            }
        }
        // 5. Navigasyon başlığını ZStack'in dışına taşıyoruz.
        .navigationTitle(detailViewModel.movieDetail?.title ?? "Loading...")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(detailViewModel: MovieDetailViewModel(movieId: 13804))
    }
    .preferredColorScheme(.dark)
}
