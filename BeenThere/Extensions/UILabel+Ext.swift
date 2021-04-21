//
//  UILabel+Ext.swift
//  BeenThere
//
//  Created by Peyton Shetler on 4/21/21.
//

import UIKit

extension UILabel {
    
    func withRoundedFont(size: CGFloat) {
        if let roundedTitleDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .largeTitle)
            .withDesign(.rounded) {
            
            self.font = UIFont(descriptor: roundedTitleDescriptor, size: size)
        }
    }
}
