//
//  VideoViewController.swift
//  Reactivity
//
//  Created by Данила Бондаренко on 27.04.2024.
//

import UIKit
import SnapKit
import RxGesture
import RxSwift

final class VideoViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private var videoPlayer: CustomVideoPlayer?
    
    private let likeButton = UIImageView(image: UIImage(systemName: "heart.fill"))
    private let commentButton = UIImageView(image: UIImage(systemName: "ellipsis.message.fill"))
    private let shareButton = UIImageView(image: UIImage(systemName: "arrowshape.turn.up.forward.fill"))
    private let specialButton = UIImageView(image: UIImage(systemName: "bookmark.fill"))
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 32
        
        return stack
    }()
    
    private var isLiked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        makeUI()
        bindUI()
    }
    
    private func makeUI() {
        videoPlayer = CustomVideoPlayer(frame: view.bounds)
        guard let videoPlayer else { return }
        view.addSubview(videoPlayer)
        
        addSubViewsActionStack()
        setupConstraints()
    }
    
    private func bindUI() {
        likeButton
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [unowned self] _ in
                let newColor: UIColor = self.isLiked ? .red : .white
                UIView.transition(with: self.likeButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.likeButton.tintColor = newColor
                }, completion: nil)
                self.isLiked.toggle()
            }
            .disposed(by: disposeBag)
    }

}

extension VideoViewController {
    private func addSubViewsActionStack() {
        let views = [likeButton, commentButton, shareButton, specialButton]
        view.addSubview(vStack)
        
        views.forEach {
            vStack.addArrangedSubview($0)
            $0.tintColor = .white
        }
        
    }
    
    private func setupConstraints() {
        vStack.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.equalTo(view.snp.centerY)
            $0.width.equalTo(40)
        }
        
        likeButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        commentButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        shareButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        specialButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
}

extension VideoViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        videoPlayer?.playVideoWithFileName("IMG_2372", ofType: "MP4")
    }
}

#Preview("Video View", traits: .portrait, body: {
    VideoModule.build()
})
