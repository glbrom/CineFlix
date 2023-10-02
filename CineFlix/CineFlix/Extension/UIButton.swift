//
//  UIButton.swift
//  CineFlix
//
//  Created by Macbook on 09.09.2023.
//

import UIKit

extension UIButton {
    static func setCustomButton(imageName: String, labelText: String, fontSize: CGFloat, buttonSize: CGFloat, iconColor: UIColor) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        
        // Create a vertical stack view for the image and text
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8 // Distance between the image and text
        
        // Create an image view and a label
        let imageView = UIImageView(image: UIImage(systemName: imageName))
        imageView.tintColor = iconColor
        let label = UILabel()
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        
        // Add the image and text to the stack
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        // Add the stack view as a subview inside the button
        button.addSubview(stackView)
        
        // Set constraints for the stack view to occupy the entire available space inside the button
        stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        
        // Set constraints for the image (if needed)
        imageView.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        return button
    }
}
