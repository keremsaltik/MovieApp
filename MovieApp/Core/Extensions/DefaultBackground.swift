//
//  DefaultBackground.swift
//  MovieApp
//
//  Created by Kerem Saltık on 20.11.2025.
//

import SwiftUI

struct DefaultBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            content
        }
    }
}

extension View {
    func defaultBackground() -> some View {
        modifier(DefaultBackgroundModifier())
    }
}
