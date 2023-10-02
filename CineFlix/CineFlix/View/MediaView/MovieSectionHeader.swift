//
//  MovieSectionHeader.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import UIKit

class MovieSectionHeader: UICollectionReusableView {
    
    // MARK: - Properties
    static let headerID = "headerID"
    
    // MARK: UI Elements
    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor.white.withAlphaComponent(0.65)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    // MARK: - Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
        ])
    }
}
