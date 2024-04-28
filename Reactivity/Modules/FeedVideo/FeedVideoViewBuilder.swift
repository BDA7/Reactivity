//
//  FeedVideoViewBuilder.swift
//  Reactivity
//
//  Created by Данила Бондаренко on 28.04.2024.
//

import Foundation

final class FeedVideoViewBuilder {
    static func build() -> FeedVideoViewController {
        let viewModel = FeedVideoViewModel()
        let view = FeedVideoViewController(viewModel: viewModel)
        
        return view
    }
}
