//
//  CollectionView.swift
//  CineFlix
//
//  Created by Macbook on 09.09.2023.
//

import UIKit

extension UICollectionView {
    
    // MARK: - Genres Layout
    func genres() -> NSCollectionLayoutSection? {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(150), heightDimension: .absolute(40)))
      
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .absolute(48))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.top = 8
       
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
    
    // MARK: - Media Layout
    func media(headerID: String) -> NSCollectionLayoutSection? {
        let spacing: CGFloat = 2
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: spacing + 6, bottom: spacing, trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(245))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: headerID, alignment: .topLeading)]
        
        return section
    }
}
