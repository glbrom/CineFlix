//
//  FavoriteMediaTableViewCell.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import UIKit
import SDWebImage

class FavoriteMediaTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static var identifier = "FavoriteMediaTableViewCell"
    
    // MARK: - UI Elements
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .systemOrange
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 5
        label.textAlignment = .natural
        label.textColor = .white.withAlphaComponent(0.65)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    // MARK: - Layuot
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    public func configure(media: Media) {
        titleLabel.text = media.original_title ?? "" + (media.original_name ?? "")
        let date = media.release_date ?? "" + (media.first_air_date ?? "")
        releaseDateLabel.text = String(date.dropLast(6))
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + (media.poster_path ?? "")) else { return }
        posterView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        posterView.sd_setImage(with: url, completed: nil)
        overviewLabel.text = media.overview
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        contentView.addSubview(posterView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(releaseDateLabel)
        
        NSLayoutConstraint.activate([
            posterView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            posterView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterView.heightAnchor.constraint(equalTo: posterView.widthAnchor, multiplier: 1.67),
            
            titleLabel.leftAnchor.constraint(equalTo: posterView.rightAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            releaseDateLabel.leftAnchor.constraint(equalTo: posterView.rightAnchor, constant: 8),
            releaseDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            overviewLabel.leftAnchor.constraint(equalTo: posterView.rightAnchor, constant: 8),
            overviewLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            overviewLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8)
            
        ])
    }
}
