//
//  DynamicBackgroundView.swift
//  CineFlix
//
//  Created by Macbook on 09.09.2023.
//

import SwiftUI

struct DynamicBackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            if colorScheme == .dark {
                // MARK: - Dark Theme
                Image("OAK40B0")
                    .frame(width: 700, height: 950, alignment: .bottomLeading)
                    .clipped()
            } else {
                // MARK: - Light Theme
                Image("OAK41Y1")
                    .clipped()
                    .frame(width: 700, height: 950, alignment: .trailing)
                    .clipped()
            }
        }
        .ignoresSafeArea()
    }
}
