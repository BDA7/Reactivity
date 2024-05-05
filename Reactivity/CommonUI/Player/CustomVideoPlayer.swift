//
//  CustomVideoPlayer.swift
//  Reactivity
//
//  Created by Данила Бондаренко on 27.04.2024.
//

import UIKit
import AVKit
import AVFoundation

final class CustomVideoPlayer: UIView {
    private var player: AVPlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let view = UIView()
        view.backgroundColor = .black
        view.frame = self.bounds
        addSubview(view)
        addPlayerToView(view)
    }
    
    private func addPlayerToView(_ view: UIView) {
        player = AVPlayer()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspect
        view.layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerAction), name: AVPlayerItem.didPlayToEndTimeNotification, object: nil)
    }
    
    func playVideoWithFileName(_ fileName: String, ofType type: String) {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: type) else { return }
        let videoURL = URL(fileURLWithPath: filePath)
        let playerItem = AVPlayerItem(url: videoURL)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
    }
    
    @objc
    private func playerAction() {
        print("ends play")
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer()
        self.addGestureRecognizer(gesture)
        gesture.addTarget(self, action: #selector(stopAndStart))
        
    }
    
    @objc
    private func stopAndStart() {
        player?.pause()
    }
}

@available(iOS 17, *)
#Preview(traits: .portrait, body: {
    CustomVideoPlayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
})
