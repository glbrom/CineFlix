//
//  LoginViewController.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import UIKit
import SwiftUI
import SafariServices


class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var loginView: CustomView!
    @IBOutlet weak var enterName: UITextField!
    @IBOutlet weak var enterPassword: UITextField!
    
    @IBOutlet weak var showPass: UIButton!
    
    @IBOutlet weak var creatorView: UIVisualEffectView!
    @IBOutlet weak var gitHubViewButton: CustomView!
    @IBOutlet weak var linkedInViewButton: CustomView!
    
    private lazy var loginViewModel = AuthenticationViewModel()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBackgroundImage()
        showSecurityPass()
        animateViewInLoginVC()
        
        enterName.endEditing(true)
        
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBackgroundImage()
    }
    
    // MARK: - IBActions
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        safariVCButtonPressed(sender: sender, url: URLConstants.registrationAccount)
    }
    
    @IBAction func guestButtonPresssed(_ sender: UIButton) {
        loginViewModel.createGuestSession { session in
            if session.success == true {
                let storyboard = UIStoryboard(name: "Main", bundle: nil) // esli vxod po acc to VC takoy
                let vc = storyboard.instantiateViewController(withIdentifier: CineflixTabBarController.identifier)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
        }
    }
    
    @IBAction func forgotPassButtonPressed(_ sender: UIButton) {
        safariVCButtonPressed(sender: sender, url: URLConstants.forgotPassword)
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard let username = enterName.text, let password = enterPassword.text else { return }
        
        loginViewModel.createSession(username: username, password: password) { success in
            if success == true {
                let storyboard = UIStoryboard(name: "Main", bundle: nil) // esli vxod po acc to VC takoy
                let vc = storyboard.instantiateViewController(withIdentifier: CineflixTabBarController.identifier)
                vc.modalPresentationStyle = .fullScreen
                self.dismiss(animated: false)
                self.present(vc, animated: false)
            } else {
                self.addAllert()
            }
        }
    }
    
    @IBAction func gitHubButtonPressed(_ sender: UIButton) {
        safariVCButtonPressed(sender: sender, url: SocialMediaLinks.gitHub)
    }
    
    @IBAction func linkedInButtonPressed(_ sender: UIButton) {
        safariVCButtonPressed(sender: sender, url: SocialMediaLinks.linkedIn)
    }
    
    // MARK: - Private Methods
    
    // ShowPassButtonAction
    @objc func showPassAction(_ sender: Any) {
        enterPassword.isSecureTextEntry.toggle()
        showPass.isSelected.toggle()
    }
    
    
    // SafariViewController
    @objc func safariVCButtonPressed(sender: UIButton, url: String) {
        guard let getURL = URL(string: url) else { return }
        let config = SFSafariViewController.Configuration()
        let safariVC = SFSafariViewController(url: getURL, configuration: config)
        present(safariVC, animated: true)
    }
    
    // Show security pass
    private func showSecurityPass() {
        showPass.setImage(UIImage(systemName: "eye.slash")?.withTintColor(.black).withRenderingMode(.alwaysTemplate), for: .normal)
        showPass.setImage(UIImage(systemName: "eyes")?.withTintColor(.systemOrange).withRenderingMode(.alwaysOriginal), for: .selected)
        showPass.addTarget(self, action: #selector(showPassAction), for: .touchUpInside)
    }
    
    // Allert inputError
    private func addAllert() {
        let errorInputMessage = UIAlertController(title: "Error", message: "Incorrect enter Password or Username", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Pushed Cancel")
        }
        
        errorInputMessage.view.tintColor = .systemRed.withAlphaComponent(0.6)
        errorInputMessage.addAction(cancel)
        
        self.present(errorInputMessage, animated: true, completion: nil)
    }
    
    // Animate View
    private func animateViewInLoginVC() {
        UIView.animate(withDuration: 0.9, delay: 0.5, options: .curveEaseInOut) {
            
            self.loginView.alpha = 0.7
            self.loginView.frame = self.loginView.frame.offsetBy(dx: 0, dy: -700)
            
            self.gitHubViewButton.alpha = 0.7
            self.gitHubViewButton.frame = self.gitHubViewButton.frame.offsetBy(dx: 0, dy: -400)
            
            self.linkedInViewButton.alpha = 0.7
            self.linkedInViewButton.frame = self.linkedInViewButton.frame.offsetBy(dx: 0, dy: -400)
            
            self.creatorView.frame = self.creatorView.frame.offsetBy(dx: 0, dy: -400)
        }
    }
    
    // Set backgroundImage
    private func setBackgroundImage(_ imageName: String, contentMode: UIView.ContentMode) {
        self.view.subviews.forEach { subview in
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }
        
        if let backgroundImage = UIImage(named: imageName) {
            let imageView = UIImageView(image: backgroundImage)
            imageView.contentMode = contentMode
            imageView.frame = self.view.bounds
            self.view.insertSubview(imageView, at: 0)
        }
    }
    
    private func updateBackgroundImage() {
        if traitCollection.userInterfaceStyle == .light {
            setBackgroundImage("OAK40B0", contentMode: .right)
        } else {
            setBackgroundImage("OAK40B0", contentMode: .bottomLeft)
        }
    }
    
}

// MARK: - UIViewControllerRepresentable
struct LoginViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
