//
//  MediaPreviewCollectionViewCell.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import UIKit
import SDWebImage

class MediaPreviewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    let viewModel = MediaDetailInfoViewModel()
    static var identifier = "MediaPreviewCollectionViewCell"
    
    // MARK: - UI Elements
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .systemOrange
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
        setupConstraint()
    }
    
    private func configureShadow() {
        container.layer.shadowRadius = 12
        container.layer.shadowOffset = CGSize(width: 4, height: 8)
        container.layer.shadowOpacity = 0.6
        container.layer.shadowColor = UIColor.systemOrange.withAlphaComponent(0.6).cgColor
        container.layer.cornerRadius = 6
    }
    
    // MARK: - Configuration
    public func configure(with title: Media) {
        if let titleText = title.title ?? title.name {
            let maxLength = 17
            if titleText.count > maxLength {
                let words = titleText.split(separator: " ")
                var truncatedText = ""
                var currentLength = 0
                for word in words {
                    if currentLength + word.count + 1 <= maxLength {
                        truncatedText += word + " "
                        currentLength += word.count + 1
                    } else {
                        break
                    }
                }
                titleLabel.text = truncatedText.trimmingCharacters(in: .whitespaces)
            } else {
                titleLabel.text = titleText
            }
        } else {
            titleLabel.text = ""
        }
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + (title.poster_path ?? "")) else { return }
        posterView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        posterView.sd_setImage(with: url, completed: nil)
    }
    
    // MARK: - Constraints
    private func setupConstraint() {
        contentView.addSubview(container)
        contentView.addSubview(titleLabel)
        container.addSubview(posterView)
        
        NSLayoutConstraint.activate([
            container.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            container.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            container.heightAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1.5),
            
            posterView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0),
            posterView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 0),
            posterView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
            posterView.heightAnchor.constraint(equalTo: posterView.widthAnchor, multiplier: 1.5),
            
            titleLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0),
            titleLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 6),
        ])
    }
}
