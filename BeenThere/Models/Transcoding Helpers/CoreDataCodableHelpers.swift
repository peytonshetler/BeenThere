//
//  CoreDataCodableHelpers.swift
//  BeenThere
//
//  Created by Peyton Shetler on 5/21/21.
//

enum CoreDataDecodingError: Error {
    case missingManagedObjectContext
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
