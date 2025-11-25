//
//  DisplayableMedia.swift
//  MovieApp
//
//  Created by Kerem Saltık on 13.11.2025.
//

import Foundation



protocol DisplayableMedia: Identifiable, Hashable {
    var posterURL: URL? { get }
    
    var id: Int { get }
}
