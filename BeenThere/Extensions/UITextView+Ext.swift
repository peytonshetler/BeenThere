//
//  UITextView+Ext.swift
//  BeenThere
//
//  Created by Peyton Shetler on 6/2/21.
//

import UIKit

extension UITextView {
    
    // Inside of your viewDidLoad function, or wherever you set your textView text:  textView.resolveTags()
    
    func resolveTags(fontSize: CGFloat = 17){
        let string: NSString = self.text as NSString
        let words: [String] = string.components(separatedBy: " ")

        let attributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor : UIColor.label

        ]

        let attrString = NSMutableAttributedString(string: string as String, attributes: attributes as [NSAttributedString.Key : Any])

        for word in words {
            if word.hasPrefix("#") {
                let matchRange: NSRange = string.range(of: word as String)
                var stringifiedWord: String = word as String
                stringifiedWord = String(stringifiedWord.dropFirst())
                attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(stringifiedWord)", range: matchRange)
                attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue , range: matchRange)
            } else {
                let matchRange: NSRange = string.range(of: word as String)
                var stringifiedWord: String = word as String
                stringifiedWord = String(stringifiedWord.dropFirst())
                //attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(stringifiedWord)", range: matchRange)
                attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label , range: matchRange)
            }
        }
        
        self.attributedText = attrString
    }
}
