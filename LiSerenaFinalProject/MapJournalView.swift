//
//  MapJournalView.swift
//  LiSerenaFinalProject
//
//  Created by Serena Li.
//

import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseStorage

// shows markers on the map of the entries
struct MapJournalView: View {
    // instance of view model
    var fbvm = FirebaseViewModel(filename: "")
    @State var entries: [Entry] = []
    var body: some View {
        Map() {
            // iterate through the array of entries to display the markers
            ForEach(entries) { entry in
                Marker(entry.entry_time, coordinate: CLLocationCoordinate2D(latitude: entry.latitude, longitude: entry.longitude))
            }
        }.mapStyle(.standard)
            .onAppear() {
                // use task because of asynchronous process
                // create an array of entries
                Task {
                    do {
                        let docs = try await fbvm.dbGenRef.getDocuments() // initializing docs was a problem
                        for doc in docs.documents {
                            entries.append(Entry(entry_time: doc.documentID, latitude: doc.data()["latitude"] as! CLLocationDegrees, longitude: doc.data()["longitude"] as! CLLocationDegrees))
                        }
                    } catch {
                        print("no docs")
                    }
                }
            }
    }
}

//#Preview {
//    MapJournalView()
//}
