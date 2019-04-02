//
//  PugCollectionViewCell.swift
//  PugMe
//
//  Created by Varun D Patel on 4/01/19.
//  Copyright © 2019 Varun D Patel. All rights reserved.
//

import UIKit
import Foundation

class PugCollectionViewCell: UICollectionViewCell {
    var pugImage: UIImage? {
        didSet {
            if let image = pugImage {
                _imageView.image = image
            }
        }
    }
    
    var imageLiked: Bool? {
        willSet {
            if let imageLiked = imageLiked, let newValue = newValue {
                if imageLiked && !newValue {
                    likeCount = (likeCount ?? 1) - 1
                } else if !imageLiked && newValue {
                    likeCount = (likeCount ?? 0) + 1
                }
            }
        }
        didSet {
            likeButton.isSelected = imageLiked ?? false
        }
    }
    
    var likeCount: Int? {
        didSet {
            _likeLabel.text = "\(likeCount ?? 0) like\((likeCount ?? 0) != 1 ? "s" : "")"
        }
    }
    
    private var _imageView: UIImageView!
    private(set) var likeButton: UIButton!
    private var _likeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupPugCollectionViewCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        pugImage = UIImage(named: "placeholder")
        imageLiked = false
        likeCount = 0
    }
    
    private func _setupPugCollectionViewCell() {
        self.backgroundColor = .white
        _setupImageView()
        _setupLikeButton()
        _setupLikeLabel()
        imageLiked = false
        likeCount = 0
    }
    
    private func _setupImageView() {
        _imageView = UIImageView(frame: .zero)
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(_imageView)
        _imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
        _imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        _imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        _imageView.contentMode = .scaleAspectFit
    }
    
    private func _setupLikeButton() {
        likeButton = UIButton(frame: .zero)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(likeButton)
        likeButton.setImage(UIImage(named: "open-heart"), for: .normal)
        likeButton.setImage(UIImage(named: "filled-heart"), for: .selected)
        likeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12).isActive = true
        likeButton.topAnchor.constraint(equalTo: _imageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func _setupLikeLabel() {
        _likeLabel = UILabel(frame: .zero)
        _likeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(_likeLabel)
        _likeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12).isActive = true
        _likeLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 8).isActive = true
        _likeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        
        _likeLabel.numberOfLines = 0
        _likeLabel.font = .preferredFont(forTextStyle: .caption2)
    }
}
