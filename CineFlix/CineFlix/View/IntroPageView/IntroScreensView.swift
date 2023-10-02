//
//  IntroScreensView.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import SwiftUI

struct IntroScreensView: View {
    @State private var logInVCPresented = false
    @State var offset: CGFloat = 0
    
    var screenSize: CGSize
    
    var body: some View {
        VStack {
            headerView()
            offsetPageTabView()
            indicatorsView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .animation(.easeInOut, value: getIndex())
    }
    
    // MARK: - Header View
    private func headerView() -> some View {
        HStack {
            Image("logoCine")
                .padding(5)
            Button(action: {
                logInVCPresented.toggle()
            }, label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.orange)
                    .padding(5)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            })
            .fullScreenCover(isPresented: $logInVCPresented, content: {
                LoginViewControllerRepresentable()
                    .ignoresSafeArea()
            })
        }
        .padding()
    }
    
    // MARK: - Offset Page Tab View
    private func offsetPageTabView() -> some View {
        OffsetPageTabView(offset: $offset) {
            HStack {
                ForEach(intros) { intro in
                    VStack {
                        Image(intro.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: screenSize.height / 2, alignment: .center)
                            .padding(-10)
                            .padding(.trailing, 30)
                        VStack(alignment: .center, spacing: 18) {
                            Text(intro.title)
                                .fontWeight(.semibold)
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                            Text(intro.description)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.trailing, 20)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(.white)
                        .padding(.top, 30)
                    }
                    .padding()
                    .frame(width: screenSize.width)
                }
            }
            .background(.clear)
        }
    }
    
    // MARK: - Indicators View
    private func indicatorsView() -> some View {
        HStack(alignment: .center) {
            HStack(spacing: 12) {
                ForEach(intros.indices, id: \.self) { index in
                    Capsule()
                        .fill(.white)
                        .opacity(0.6)
                        .frame(width: getIndex() == index ? 20 : 7, height: 7)
                }
            }
            .overlay(
                Capsule()
                    .fill(.orange)
                    .opacity(0.9)
                    .frame(width: 20, height: 7)
                    .offset(x: getIndicatorOffset()),
                alignment: .leading
            )
            .offset(x: 120, y: -15)
            Spacer()
        }
        .padding(35)
        .offset(y: -10)
    }
    
    // MARK: - Indicator Offset
    private func getIndicatorOffset() -> CGFloat {
        let progtess = offset / screenSize.width
        let maxWidth: CGFloat = 19
        return progtess * maxWidth
    }
    
    // MARK: - Current Index
    private func getIndex() -> Int {
        let progress = round(offset / screenSize.width)
        let index = min(Int(progress), intros.count - 1)
        return index
    }
}
