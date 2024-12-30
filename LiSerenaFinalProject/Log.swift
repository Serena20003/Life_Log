//
//  Log.swift
//  LiSerenaFinalProject
//
//  Created by Serena Li.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

// Model for storing each log information (image and other metadata)
struct Log {
    var log_date: Date
    var log_entry: Int
    var log_latitude: Double?
    var log_longitude: Double?
    var log_description: String = ""
}
