//
//  Api.swift
//  Master
//
//  Created by Dalton Ng on 26/12/18.
//  Copyright © 2018 Dalton Prescott. All rights reserved.
//

import Foundation
import Firebase


let db = Firestore.firestore()


public func logout() {
    try! Auth.auth().signOut()
}

public func getCurrentUserDisplayName() -> String {
    guard let user = Auth.auth().currentUser else { return "" }
    return user.displayName ?? ""
}

public func getCurrentUserProfilePhotoURL() -> URL {
    let user = Auth.auth().currentUser
    var photoUrl = String()
    
    photoUrl = (user!.photoURL!.absoluteString)
    
    if let providerData = user?.providerData {
        for userInfo in providerData {
            switch userInfo.providerID {
            case "facebook.com":
                print("user is signed in with facebook")
                photoUrl += "?height=500"
            case "google.com":
                print("user is signed in with google")
                photoUrl = String(photoUrl[...(photoUrl.count-16)]) + "s400-c/photo.jpg"
            default:
                print("user is signed in with \(userInfo.providerID)")
            }
        }
    }
    return URL(string: photoUrl)!
}

// Asynchronous
func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}

/*
func downloadImage(from url: URL) {
    print("Download Started")
    getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        print(response?.suggestedFilename ?? url.lastPathComponent)
        print("Download Finished")
        DispatchQueue.main.async() {
            self.imageView.image = UIImage(data: data)
        }
    }
}*/

// Updates the user document in Firebase.
// Returns true if it was successful.
public func updateUserDocument(displayName: String? = nil, photoURL:URL? = nil, email:String? = nil) -> Bool {
    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    
    if displayName != nil {
        changeRequest?.displayName = displayName
    }
    
    if photoURL != nil {
        changeRequest?.photoURL = photoURL
    }
    
    changeRequest?.commitChanges { (error) in
        print(error?.localizedDescription as Any)
    }
    
    return false
}

public func gainEarlyAdopterBadge() {
    checkForEarlyAdopterBadge(completion: { success in
        if success {
            print("Early adopter badge already exists!")
            return
        }
            let uid = Auth.auth().currentUser?.uid
        
            db.collection("admin/badges/earlyAdopter").document(uid!).setData([
               "uid":uid!,
               "deviceTimestamp": Timestamp(),
               "date": FieldValue.serverTimestamp()
            ]) { err in
                if let err = err {
                    print("Error adding early adopter badge: \(err)")
                } else {
                    print("Early adopter badge successfully added!")
                }
            }
        })
}

public func checkForEarlyAdopterBadge(completion: @escaping (_ success: Bool) -> ()) {
    let uid = Auth.auth().currentUser?.uid
    //var badgeExist = false
    
    db.collection("admin/badges/earlyAdopter").document(uid!).getDocument { (document, error) in
        if let document = document, document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Early adopter badge data: \(dataDescription)")
            completion(true)
        } else {
            print("Early adopter badge does not exist")
            completion(false)
        }
        
    }
}


////addDocument(data: ["uid":uid!, "date":currentDate]) { err in
public func postStudySet(studySet: StudySetData) {
    let uid = Auth.auth().currentUser?.uid
    
    
    
}
