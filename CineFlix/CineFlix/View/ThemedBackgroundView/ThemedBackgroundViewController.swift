//
//  ThemedBackgroundViewController.swift
//  CineFlix
//
//  Created by Macbook on 06.09.2023.
//

import UIKit

class ThemedBackgroundViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = MediaFetcherViewModel()
    
    // MARK: - UI Elements
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        updateBackground()
    }
    
    // MARK: - Constraints
    private func setupConstraint() {
        view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - SignOut
    @objc func signOut() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
        viewModel.delSession()
    }
    
    // MARK: - Configuration NavigationBar
    func configureNavigationBar(withLogo: Bool, backButtonTitle: String, rightBarButtonImageName: String?, rightBarButtonAction: Selector?) {
        if withLogo {
            var image = UIImage(named: "logoCine")
            image = image?.withRenderingMode(.alwaysOriginal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        } else {
            navigationItem.leftBarButtonItem = nil
        }
        
        if let imageName = rightBarButtonImageName {
            let rightBarButton = UIBarButtonItem(image: UIImage(systemName: imageName), style: .done, target: self, action: rightBarButtonAction)
            navigationItem.rightBarButtonItem = rightBarButton
            navigationController?.navigationBar.tintColor = UIColor.systemOrange
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        
        navigationItem.backButtonTitle = backButtonTitle
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Check for theme changes and update the background image
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateBackground()
        }
    }
    
    // MARK: - Update BackgroundImageView
    func updateBackground() {
        if traitCollection.userInterfaceStyle == .light {
            if let lightImage = UIImage(named: "OAK40B0") {
                backgroundImageView.image = lightImage
                backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
                backgroundImageView.contentMode = .right
            }
        } else {
            if let darkImage = UIImage(named: "OAK40B0") {
                backgroundImageView.image = darkImage
                backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
                backgroundImageView.contentMode = .bottomLeft
            }
        }
    }
}
