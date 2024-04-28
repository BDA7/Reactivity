//
//  VideoCollectionViewCell.swift
//  Reactivity
//
//  Created by Данила Бондаренко on 28.04.2024.
//

import UIKit
import AVKit
import SnapKit

final class VideoCollectionViewCell: UICollectionViewCell {
    static let indentifier = "VideoCollectionViewCell"
    
    var player: AVPlayer?
    
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
    
    private let videoContainer: UIView = {
        return UIView()
    }()
    
    private var videoName: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        contentView.clipsToBounds = true
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(AVPlayerItem.didPlayToEndTimeNotification)
    }
    
    public func configure(with videoName: String) {
        self.videoName = videoName
        configureVideo()
    }
    
    private func configureVideo() {
        guard
            let videoName,
            let path = Bundle.main.path(forResource: videoName, ofType: "MP4")
        else { return }
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        
        let playerView = AVPlayerLayer(player: player)
        playerView.videoGravity = .resizeAspectFill
        playerView.frame = contentView.bounds
        videoContainer.layer.addSublayer(playerView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerAction), name: AVPlayerItem.didPlayToEndTimeNotification, object: nil)
    }
    
    @objc
    private func playerAction(_ notification: NSNotification) {
        guard
            let playerItem = notification.object as? AVPlayerItem,
            playerItem == player?.currentItem
        else { return }
        
        print("ends play")
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    public func startVideo() {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    public func pauseVideo() {
        player?.pause()
    }
}

extension VideoCollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        makeLayoutForSubViews()
    }
    
    private func setupSubViews() {
        contentView.addSubview(videoContainer)
        
        contentView.addSubview(vStack)
        [likeButton, commentButton, specialButton, shareButton].forEach {
            vStack.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = true
            $0.tintColor = .white
        }
        
        videoContainer.clipsToBounds = true
        contentView.sendSubviewToBack(videoContainer)
    }
    
    private func makeLayoutForSubViews() {
        videoContainer.frame = contentView.bounds
        vStack.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.equalTo(contentView.snp.centerY)
            $0.width.equalTo(40)
        }
        [likeButton, commentButton, specialButton, shareButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(40)
            }
        }
    }
}
