//
//  TrailerCollectionViewCell.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import UIKit
import youtube_ios_player_helper

class TrailerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static var identifier = "TrailerCollectionViewCell"
    
    // MARK: UI Elements
    public var playerView: YTPlayerView = {
        let view = YTPlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    
    // MARK: - Layout
    override func layoutSubviews() {
        setupConstraints()
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        contentView.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            playerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
    }
}
