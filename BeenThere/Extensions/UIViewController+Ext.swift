//
//  UIViewController+Ext.swift
//  BeenThere
//
//  Created by Peyton Shetler on 4/21/21.
//

import UIKit

extension UIViewController {
    
   
    func presentBTErrorAlertOnMainThread(error: BTError, buttonTitle: String? = "Ok", completion: ((UIAlertAction) -> Void)?) {
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: error.title, message: error.rawValue, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: completion ?? nil))

            self.present(alert, animated: true)
        }
    }
}
