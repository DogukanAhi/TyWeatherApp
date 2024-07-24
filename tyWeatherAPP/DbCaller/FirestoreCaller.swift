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

func getDataFromFirestore(completion: @escaping ([String]) -> Void) {
    let firestoreDatabase = Firestore.firestore()
    firestoreDatabase.collection("cities").addSnapshotListener { (snapshot, error) in
        if error != nil {
            print(error?.localizedDescription ?? "Error")
            completion([])
        } else {
            var cityNames = [String]()
            if snapshot?.isEmpty != true && snapshot != nil {
                for document in snapshot!.documents {
                    if let ankara = document.get("Ankara") as? String {
                        cityNames.append(ankara)
                    }
                    if let gaziantep = document.get("Gaziantep") as? String {
                        cityNames.append(gaziantep)
                    }
                    if let istanbul = document.get("Istanbul") as? String {
                        cityNames.append(istanbul)
                    }
                }
            }
            completion(cityNames)
        }
    }
}

