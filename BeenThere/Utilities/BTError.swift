//
//  BTError.swift
//  BeenThere
//
//  Created by Peyton Shetler on 4/21/21.
//

import Foundation


enum BTError: String, Error {
    
    case emptyNameField = "You forgot to give this place a name."
    case locationError = "Something went wrong while trying to get your location."
    case generalError = "Something weird happened. If it keeps happening feel free to send a bug report from the settings page."
    case savingError = "There was a problem saving your place."
    case errorRetrievingResults = "There was a problem retrieving your data."
    case cantSendEmail = "Unable to send mail."
    case duplicatePlace = "A place with that name already exists."
    case featureComingSoon = "This feature isn't quite ready. Be on the lookout in the next version!"
    case badInternetConnection = "Something went wrong. Are you sure you're connected to the internet?"
    
    var title: String {
        switch self {
        case .generalError, .savingError, .errorRetrievingResults, .locationError, .cantSendEmail, .badInternetConnection: return "Uh-Oh"
        case .emptyNameField, .duplicatePlace: return "Whoops!"
        case .featureComingSoon: return "This is awkward 😅"
        }
    }
}
