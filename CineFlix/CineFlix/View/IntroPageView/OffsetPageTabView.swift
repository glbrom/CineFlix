//
//  OffsetPageTabView.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import SwiftUI

// Custom view for Paging Control
struct OffsetPageTabView <Content: View>: UIViewRepresentable {
    var content: Content
    @Binding var offset: CGFloat
    
    func makeCoordinator() -> Coordinator {
        return OffsetPageTabView.Coordinator(parent: self)
    }
    
    init(offset: Binding <CGFloat>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._offset = offset
    }
    
    // MARK: - UIViewRepresentable
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        
        // Extracting SwiftUI View and embedding into UIKit ScrollView
        let hostView = UIHostingController(rootView: content)
        hostView.view.backgroundColor = .clear
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            
            hostView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostView.view?.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            // if using vertical Paging
            hostView.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ].compactMap { $0 }
        
        scrollView.addSubview(hostView.view)
        scrollView.addConstraints(constraints)
        
        // Enabling Paging
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        // Delegate aetting
        scrollView.delegate = context.coordinator
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        let currentOffset = uiView.contentOffset.x
        if currentOffset != offset {
            uiView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
    // Pages offset
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: OffsetPageTabView
        
        init(parent: OffsetPageTabView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            
            parent.offset = offset
        }
    }
}
