//
//  DbCaller.swift
//  tyWeatherAPP
//
//  Created by Doğukan Ahi on 23.07.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

func addDataToFirestore() { // MARK: Adding data to firestore
    let cities : [String:String] = ["Ankara":"Ankara","Gaziantep":"Gaziantep","Istanbul":"Istanbul"]
    let firestoreDatabase = Firestore.firestore()
    var firestoreReference : DocumentReference? = nil
    firestoreReference = firestoreDatabase.collection("cities").addDocument(data: cities, completion: { (error) in
        if error != nil {
            print(error?.localizedDescription ?? "error")
        }
    })
    
}

func getDataFromFirestore(completion: @escaping ([String: String]) -> Void) {
    let firestoreDatabase = Firestore.firestore()
    firestoreDatabase.collection("cities").addSnapshotListener { snapshot, error in
        if let error = error {
            print(error.localizedDescription)
            completion([:])
        } else {
            var cities = [String: String]()
            if let snapshot = snapshot, !snapshot.isEmpty {
                for document in snapshot.documents {
                    for (key, value) in document.data() {
                        if let cityName = value as? String {
                            cities[key] = cityName
                        }
                    }
                }
            }
            completion(cities)
        }
    }
}

