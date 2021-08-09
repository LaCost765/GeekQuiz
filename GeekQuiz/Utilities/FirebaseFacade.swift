//
//  FirebaseFacade.swift
//  GeekQuiz
//
//  Created by Egor on 20.07.2021.
//

import Foundation
import Firebase
import SwiftyJSON

class FirebaseFacade {
    
    func signInUser(with email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                 
            if let error = error {
                print(error.localizedDescription)
                completion(false, error.localizedDescription)
                return
            }
            
            Game.shared.userName = self?.getCurrentUserName() ?? ""
            completion(true, nil)
        }
    }
    
    func signUpUser(email: String, name: String, surname: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(false, error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else {
                completion(false, "No user data")
                return
            }
        
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = "\(name) \(surname)"
            changeRequest.commitChanges { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    completion(true, nil)
                }
            }
//            let firestore = Firestore.firestore()
//            firestore.collection("users").document(user.uid).setData(["name": "\(name) \(surname)"]) { [weak self] err in
//
//                if let err = err {
//                    print("Error: \(err.localizedDescription)")
//                    return
//                }
//
//                do {
//                    try Auth.auth().signOut()
//                } catch {
//                    print("Error: \(error.localizedDescription)")
//                }
//                completion(true, nil)
//            }
        }
    }
    
    func loadBestResultForUser(completion: @escaping (GameResult?) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let firestore = Firestore.firestore()
        firestore.collection("bestResults").document(uid).getDocument { document, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            if let document = document,
               document.exists,
               let data = document.data() {
                
                let result = GameResult.createFromDictionary(dict: data)
                completion(result)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    func addResultToFirestore(result: GameResult) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let firestore = Firestore.firestore()
        firestore.collection("bestResults").document(uid).setData(result.convertToDictionary()) { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("New best result for uid \(uid) successfully written")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func isUserSignedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentUserName() -> String? {
        if let name = Auth.auth().currentUser?.displayName {
            return name
        } else {
            return nil
        }
    }
    
    func loadAllUsersResults(completion: @escaping ([GameResult?]) -> Void) {
        
        let firestore = Firestore.firestore()
        firestore.collection("bestResults").getDocuments { query, err in
            
            if let err = err {
                print("Error when getting results: \(err.localizedDescription)")
            } else {
                guard let query = query else { return }
                var results: [GameResult?] = []
                for document in query.documents {
                    results.append(GameResult.createFromDictionary(dict: document.data()))
                }
                completion(results)
            }
        }
    }
}
