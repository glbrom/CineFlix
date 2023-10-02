//
//  CanvasPreviewUIKit.swift
//  CineFlix
//
//  Created by Macbook on 27.08.2023.
//

import SwiftUI

extension UIViewController {
    
    // MARK: - Private Struct Preview
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            // Update logic here if needed
        }
    }
    
    // MARK: - Public Method showPreview()
    func showPreview() -> some View {
        Preview(viewController: self).edgesIgnoringSafeArea(.all)
    }
}

// add to ViewController

//struct ViewControllerProvider: PreviewProvider {
//    static var previews: some View {
//        // ViewController.showPreview
//    }
//}
