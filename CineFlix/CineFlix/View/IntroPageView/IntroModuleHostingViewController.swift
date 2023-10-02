//
//  IntroHostingViewController.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import SwiftUI
import UIKit

// MARK: - IntroModuleView
struct IntroModuleView: View {
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            DynamicBackgroundView()
            IntroScreensView(screenSize: size)
        }
    }
}

// MARK: - HostingViewController
class IntroModuleHostingViewController: UIHostingController<SplashScreenView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SplashScreenView())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
