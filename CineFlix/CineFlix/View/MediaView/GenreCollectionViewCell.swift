//
//  GenreCollectionViewCell.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static var identifier = "GenreCollectionViewCell"
    
    // MARK: - UI Elements
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "tabbaricon")?.withAlphaComponent(0.1)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1.2
        view.layer.borderColor = UIColor.systemOrange.withAlphaComponent(0.3).cgColor //
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .systemOrange
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        configureShadow()
    }
    
    private func configureShadow() {
        container.layer.shadowRadius = 10
        container.layer.shadowOffset = CGSize(width: 2, height: 2)
        container.layer.shadowColor = UIColor.systemOrange.withAlphaComponent(0.3).cgColor
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        contentView.addSubview(container)
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            container.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            container.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            titleLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 15),
            titleLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -15),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
    }
    
    public func configure(with genre: Genre) {
        titleLabel.text = genre.name
    }
}
