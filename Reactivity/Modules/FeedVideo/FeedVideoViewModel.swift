//
//  FeedVideoViewModel.swift
//  Reactivity
//
//  Created by Данила Бондаренко on 28.04.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class FeedVideoViewModel {
    private let videos = BehaviorRelay<[String]>(value: ["1", "IMG_2372"])
}

extension FeedVideoViewModel: ViewModelProtocol {
    struct Input {
        let videoIndex: Observable<Int>
    }
    
    struct Output {
        let videoName: Single<String>
    }
    
    func transform(_ input: Input) -> Output {
        let videoName = input
            .videoIndex
            .map { [weak self] index in
                guard let self = self else { return "" }
                let videos = self.videos.value
                guard index >= 0 && index < videos.count else { return "" }
                return videos[index]
            }
            .filter { !$0.isEmpty }
            .asSingle()
        
        return Output(videoName: videoName)
    }
}

