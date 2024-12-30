//
//  FirebaseViewModel.swift
//  LiSerenaFinalProject
//
//  Created by Serena Li.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

// View Model to process data for all three tabviews, communicates with Firebase
class FirebaseViewModel: ObservableObject {
    @Published var fileName = ""
    
    init(filename: String) {
        fileName = filename
    }
    // filePath is already known because each of the 3 individual grids of one day has its own instance of FirebaseViewModel, so it's less repetition
    // user_id is included here to avoid data conflicts between users who log the same day and entries
    var filePath: String {
        "images/\(user_id)/\(fileName).png"
    }
    var dbOneDocRef: AnyObject {
        Firestore.firestore().collection(user_id).document(fileName)
    }
    var storageRef: AnyObject {
        Storage.storage().reference().child(filePath)
    }
    // This is a more general reference due to the needs of MapJournalView
    var dbGenRef: AnyObject {
        Firestore.firestore().collection(user_id)
    }
    
    // edits data if the entry already exists, creates a new entry if it doesn't, using the log information
    func uploadData(_ log: Log) async {
        do {
            try await dbOneDocRef.updateData(["date": log.log_date, "entry": log.log_entry, "description": log.log_description, "image_path": filePath, "latitude": log.log_latitude ?? 0, "longitude": log.log_longitude ?? 0])
        } catch {
            do {
                try await dbOneDocRef.setData(["date": log.log_date, "entry": log.log_entry, "description": log.log_description, "image_path": filePath, "latitude": log.log_latitude ?? 0, "longitude": log.log_longitude ?? 0])
            } catch {
                print("update unsuccessful")
            }
        }
    }
    
    // Takes in log information and updates the description that user just inputted if the data already exists, or create a new document if log doesn't exist yet.
    func updateDescription(_ log: Log) async {
        do {
            try await dbOneDocRef.updateData(["description": log.log_description])
        } catch {
            do {
                try await dbOneDocRef.setData(["date": log.log_date, "entry": log.log_entry, "description": log.log_description, "image_path": "", "latitude": log.log_latitude ?? 0, "longitude": log.log_longitude ?? 0])
            } catch {
                print("update unsuccessful")
            }
        }
    }
    
    // Displays description from Firestore Database in textfield if log exists
    func getDescription() async -> String {
        do {
            if let desc = try await dbOneDocRef.getDocument()["description"] {
                return desc as! String
            }
        } catch {
            print("no description")
        }
        return ""
    }
    
    // Returns a boolean to determine if all 3 of the entries of the current day has been filled out to give confetti celebration
    // only called when image is changed, so doesn't work for past or future days, which is the desired outcome.
    func allFilled(date: Date) async -> Bool {
        do {
            var count = 0
            let docs = try await dbGenRef.getDocuments()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: date)
            // compares the document ID which is in the same format as date after formatted
            // only if the number of valid entries are exactly 3 will the confetti be released
            for doc in docs.documents {
                if doc.documentID.components(separatedBy: "_")[0] == dateString && doc.data()["image_path"] as! String != "" {
                    count += 1
                }
            }
            if (count == 3) {
                return true
            } else {
                return false
            }
        } catch {
            print("no confettis")
        }
        return false
    }
}

