//
//  FeedVideoViewController.swift
//  Reactivity
//
//  Created by Данила Бондаренко on 27.04.2024.
//

import UIKit
import RxSwift

//MARK: - Props and inits
final class FeedVideoViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    
    private let currentIndex = BehaviorSubject(value: 0)
    
    private var videos = ["1", "IMG_2372"]
    
    private var viewModel: FeedVideoViewModel?
    
    init(viewModel: FeedVideoViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Life cycle
extension FeedVideoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
}

//MARK: - Collection View
extension FeedVideoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    private func makeCollectionView() {
        collectionView?.backgroundColor = .black
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.indentifier)
        
        guard let collectionView else { return }
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.indentifier, for: indexPath) as? VideoCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: videos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = cell as? VideoCollectionViewCell? else { return }
        videoCell?.pauseVideo()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = cell as? VideoCollectionViewCell? else { return }
        videoCell?.startVideo()
    }
}

//MARK: - Preview
#Preview("Feed View", traits: .portrait, body: {
    FeedVideoViewController(viewModel: FeedVideoViewModel())
})
