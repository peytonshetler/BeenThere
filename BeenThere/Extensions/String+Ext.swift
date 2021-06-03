//
//  String+Ext.swift
//  BeenThere
//
//  Created by Peyton Shetler on 6/2/21.
//

import UIKit


extension String
{
    // use case: someString.getHashtags()
    
    func getHashtags() -> [String]
    {
        if let regex = try? NSRegularExpression(pattern: "#[a-z0-9]+", options: .caseInsensitive)
        {
            let string = self as NSString

            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "#", with: "").lowercased()
            }
        }

        return []
    }
}
