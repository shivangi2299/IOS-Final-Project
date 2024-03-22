//
//  FirebaseHelpers.swift
//  FinalProject
//
//  Created by CDMStudent on 3/15/24.
//

import Foundation
import FirebaseFirestore

enum FirebaseCollectionReference : String {
    case User
    case Products
    case Basket
}

func FirebaseReference(_ collectionReference: FirebaseCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
