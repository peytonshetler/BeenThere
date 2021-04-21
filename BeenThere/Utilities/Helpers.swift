//
//  Helpers.swift
//  BeenThere
//
//  Created by Peyton Shetler on 4/21/21.
//

import UIKit
import MapKit

struct Helpers {
    
    struct Regex {
        
        static func isMatch(pattern: String, string: String?) -> Bool {
            guard let string = string else { return false }
            let nsString = string as NSString
            
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)

                let matches = regex.matches(in: string, range: NSRange(location: 0, length: nsString.length))
                return matches.count != 0
            } catch {
                print("Something went wrong! Error: \(error.localizedDescription)")
            }

            return false
        }
    }
    
    
    struct Location {
        
        static func parseAddress(selectedItem: MKPlacemark, format: String = "%@%@%@%@%@%@%@%@%@%@%@") -> String {

            // put a space between "4" and "Melrose Place"
            let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""

            // put a comma between street and city/state
            let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
                        (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""

            // put a space between "Washington" and "DC"
            let secondSpace = (selectedItem.subAdministrativeArea != nil &&
                                selectedItem.administrativeArea != nil) ? " " : ""
            
            let thirdSpace = (selectedItem.administrativeArea != nil && selectedItem.postalCode != nil) ? " " : ""
            
            
            let secondComma = (selectedItem.postalCode != nil || selectedItem.administrativeArea != nil) &&
                        selectedItem.country != nil ? ", " : ""
            
            let addressLine = String(
                format: format,
                // street number
                selectedItem.subThoroughfare ?? "",
                firstSpace,
                // street name
                selectedItem.thoroughfare ?? "",
                comma,
                // city
                selectedItem.locality ?? "",
                secondSpace,
                // state
                selectedItem.administrativeArea ?? "",
                thirdSpace,
                // zip code
                selectedItem.postalCode ?? "",
                secondComma,
                // country
                selectedItem.country ?? ""
            )

            return addressLine
        }
        
        
        static func parseAddress(selectedItem: BTLocation, format: String = "%@%@%@%@%@%@%@%@%@%@%@") -> String {

            // put a space between "4" and "Melrose Place"
            let firstSpace = (!selectedItem.subThoroughfare.isEmpty && !selectedItem.thoroughfare.isEmpty) ? " " : ""

            // put a comma between street and city/state
            let comma = (!selectedItem.subThoroughfare.isEmpty || !selectedItem.thoroughfare.isEmpty) &&
                        (!selectedItem.administrativeArea.isEmpty) ? ", " : ""

            // put a space between "Washington" and "DC"
            let secondSpace = !selectedItem.administrativeArea.isEmpty ? " " : ""
            
            let thirdSpace = (!selectedItem.administrativeArea.isEmpty && !selectedItem.postalCode.isEmpty) ? " " : ""
            
            
            let secondComma = (!selectedItem.postalCode.isEmpty || !selectedItem.administrativeArea.isEmpty) &&
                !selectedItem.country.isEmpty ? ", " : ""
            
            let addressLine = String(
                format: format,
                // street number
                selectedItem.subThoroughfare,
                firstSpace,
                // street name
                selectedItem.thoroughfare,
                comma,
                // city
                selectedItem.locality,
                secondSpace,
                // state
                selectedItem.administrativeArea,
                thirdSpace,
                // zip code
                selectedItem.postalCode,
                secondComma,
                // country
                selectedItem.country
            )

            return addressLine
        }
    }
    
    
    struct Font {
        
        static func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
            let systemFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
            let font: UIFont

            if #available(iOS 13.0, *) {
                if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
                    font = UIFont(descriptor: descriptor, size: fontSize)
                } else {
                    font = systemFont
                }
            } else {
                font = systemFont
            }

            return font
        }
    }
    
    
    struct Symbol {
        
        static func imageConfig(size: CGFloat, weight: UIImage.SymbolWeight = .regular, scale: UIImage.SymbolScale = .default) -> UIImage.SymbolConfiguration {
            
            return UIImage.SymbolConfiguration(pointSize: size, weight: weight, scale: scale)
        }
    }
}

