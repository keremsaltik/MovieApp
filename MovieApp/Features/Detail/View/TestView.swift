//
//  TestView.swift
//  MovieApp
//
//  Created by Kerem Saltık on 15.11.2025.
//

import SwiftUI

struct TestView: View {
    let id: Int
        
        var body: some View {
            VStack {
                Text("Başarıyla Geldim!")
                    .font(.largeTitle)
                Text("Bana verilen ID: \(id)")
                    .font(.title2)
            }
            .onAppear {
                print("✅✅✅ TestView Ekranda Göründü! ID: \(id) ✅✅✅")
            }
        }
}

#Preview {
    //TestView()
}
