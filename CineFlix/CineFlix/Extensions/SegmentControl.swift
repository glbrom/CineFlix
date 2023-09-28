//
//  SegmentControl.swift
//  CineFlix
//
//  Created by Macbook on 09.09.2023.
//

import UIKit

extension UISegmentedControl {
    
    // MARK: - Remove Border and Customize
    func removeBorder() {
        var bgcolor: CGColor
        var textColorNormal: UIColor
        var textColorSelected: UIColor
        
        if self.traitCollection.userInterfaceStyle == .dark {
            bgcolor = UIColor.clear.cgColor
            textColorNormal = UIColor.white.withAlphaComponent(0.4)
            textColorSelected = UIColor.systemOrange.withAlphaComponent(0.9)
        } else {
            bgcolor = UIColor.clear.cgColor
            textColorNormal = UIColor.white.withAlphaComponent(0.8)
            textColorSelected = UIColor.systemOrange.withAlphaComponent(0.9)
        }
        
        let backgroundImage = UIImage.getColoredRectImageWith(color: bgcolor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        
        let deviderImage = UIImage.getColoredRectImageWith(color: bgcolor, andSize: CGSize(width: 2, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        
        let normalFont = UIFont.systemFont(ofSize: 13) // Replace with your desired font size
        self.setTitleTextAttributes([
            NSAttributedString.Key.font: normalFont,
            NSAttributedString.Key.foregroundColor: textColorNormal
        ], for: .normal)
        
        let selectedFont = UIFont.boldSystemFont(ofSize: 15) // Replace with your desired font size for selected segment
        self.setTitleTextAttributes([
            NSAttributedString.Key.font: selectedFont,
            NSAttributedString.Key.foregroundColor: textColorSelected
        ], for: .selected)
    }
    
    // MARK: - Setup Segment
    func setupSegment() {
        DispatchQueue.main.async {
            self.removeBorder()
            self.addUnderlineForSelectedSegment()
        }
    }
    
    // MARK: - Add Underline for Selected Segment
    func addUnderlineForSelectedSegment() {
        DispatchQueue.main.async {
            self.removeUnderline()
            let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments) - 5
            let underlineHeight: CGFloat = 3.0
            let underlineXPosition = CGFloat(self.selectedSegmentIndex * Int(underlineWidth) + 5)
            let underLineYPosition = self.bounds.size.height - 4
            let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
            let underline = UIView(frame: underlineFrame)
            underline.layer.cornerRadius = 4
            underline.backgroundColor = .systemOrange.withAlphaComponent(0.9)
            underline.tag = 1
            self.addSubview(underline)
        }
    }
    
    // MARK: - Change Underline Position
    func changeUnderlinePosition() {
        guard let underline = self.viewWithTag(1) else { return }
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        underline.frame.origin.x = underlineFinalXPosition
    }
    
    // MARK: - Remove Underline
    func removeUnderline() {
        guard let underline = self.viewWithTag(1) else { return }
        underline.removeFromSuperview()
    }
}
