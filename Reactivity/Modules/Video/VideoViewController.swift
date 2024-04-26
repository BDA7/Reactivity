//
//  VideoViewController.swift
//  Reactivity
//
//  Created by Данила Бондаренко on 27.04.2024.
//

import UIKit
import AVKit
import AVFoundation

final class VideoViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
    
    
}

extension VideoViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "IMG_2372", ofType: "MP4") else {
            debugPrint("video not found")
            return
        }
        
        let player = AVPlayer(url: NSURL.fileURL(withPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
        
    }
}

#Preview("Video View", traits: .portrait, body: {
    VideoModule.build()
})
