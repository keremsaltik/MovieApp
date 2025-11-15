//
//  DisplayableMedia.swift
//  MovieApp
//
//  Created by Kerem Saltık on 13.11.2025.
//

import Foundation

/// Ekranda bir medya kartı olarak gösterilebilecek herhangi bir nesnenin
/// uyması gereken minimum gereksinimleri tanımlar.

protocol DisplayableMedia: Identifiable, Hashable {
    /// Medyanın poster resminin tam URL'si.
        /// Eğer poster yoksa `nil` olabilir.
    var posterURL: URL? { get }
    
    // `Identifiable` protokolü için gereklidir, `ForEach` içinde kullanılır.
    /// Bu özelliğin modelde `id` olarak adlandırılması gerekir.
    
    var id: Int { get }
}
