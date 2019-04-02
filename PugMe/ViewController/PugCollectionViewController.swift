//
//  PugCollectionViewController.swift
//  PugMe
//
//  Created by Varun D Patel on 4/01/19.
//  Copyright © 2019 Varun D Patel. All rights reserved.
//

import UIKit

class PugCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private var _pugsFactory = PugsFactory()
    private var _collectionView: UICollectionView!
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        _setupCollectionView()
        _pugsFactory.delegate = self
        _pugsFactory.getNextPage()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _pugsFactory.pugs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _pugsFactory.pugs[section].pugImageUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pugCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PugCollectionViewCell", for: indexPath) as! PugCollectionViewCell
        pugCollectionViewCell.likeButton.addTarget(self, action: #selector(self.likeButtonTapped(_:)), for: .touchUpInside)
        let pug = _pugsFactory.pugs[indexPath.section]
        pugCollectionViewCell.likeCount = pug.likeCount[indexPath.row]
        pugCollectionViewCell.imageLiked = pug.pugImageLiked[indexPath.row]
        
        //Download || Use Cached Images:
        if let cachedUrl = pug.pugImageUrls![indexPath.row]?.absoluteString, let cachedData = pug.pugImageCache[cachedUrl] {
            pugCollectionViewCell.pugImage = UIImage(data: cachedData)
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let pugUrl = pug.pugImageUrls![indexPath.row]!
                let imageData = try? Data(contentsOf: pugUrl)
                pug.pugImageCache[pugUrl.absoluteString] = imageData
                DispatchQueue.main.async {
                    if let cell = collectionView.cellForItem(at: indexPath), let imageData = imageData {
                        (cell as! PugCollectionViewCell).pugImage = UIImage(data: imageData)
                    }
                }
            }
        }
        
        //if you're 8 images away from the "bottom", get next page
        if (indexPath.section == 50 * _pugsFactory.pageNumber - 8) {
            _pugsFactory.getNextPage()
        }
        return pugCollectionViewCell
    }
    
    @objc func likeButtonTapped (_ sender: UIButton) {
        let buttonPosition = sender.convert(sender.bounds.origin, to: _collectionView)
        let indexPath = _collectionView.indexPathForItem(at: buttonPosition)
        if let indexPath = indexPath {
            let pug = _pugsFactory.pugs[indexPath.section]
            pug.pugImageLiked![indexPath.row] = !sender.isSelected
            if let cell = _collectionView.cellForItem(at: indexPath) {
                (cell as! PugCollectionViewCell).imageLiked = pug.pugImageLiked![indexPath.row]
            }
        }
    }
}

//MARK: Private Setup Methods
extension PugCollectionViewController {
    private func _setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
        _collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        _collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(_collectionView)
        _collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        _collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        _collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        _collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        _collectionView.backgroundColor = .white
        _collectionView.register(PugCollectionViewCell.self, forCellWithReuseIdentifier: "PugCollectionViewCell")
        _collectionView.delegate = self
        _collectionView.dataSource = self
    }
}

extension PugCollectionViewController: Pugsable {
    func newPugsAvailable() {
        _collectionView.reloadData()
    }
}
