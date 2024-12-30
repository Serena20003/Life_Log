//
//  TodayJournalGridView.swift
//  LiSerenaFinalProject
//
//  Created by Serena Li.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

struct TodayJournalGridView: View {
    // variables passed in by TodayJournalView
    @State var log: Log
    @State var momentItem: PhotosPickerItem?
    @State var momentImage: Image? 
    @State var uiImage: UIImage?
    @StateObject var locationViewModel = LocationViewModel()
    @StateObject var fbViewModel: FirebaseViewModel
    @Binding var isShowingConfetti: Bool
    let dimensions: CGFloat = 150
    var body: some View {
        VStack(alignment: .center) {
            // the grids will only be editable if the day is current day
            if (Calendar.current.dateComponents([.month], from: log.log_date).month == Calendar.current.dateComponents([.month], from: Date()).month && Calendar.current.dateComponents([.day], from: log.log_date).day == Calendar.current.dateComponents([.day], from: Date()).day) {
                TextField("Describe the moment", text: $log.log_description)
                    .padding()
                    .font(.title3)
                PhotosPicker(selection: $momentItem, matching: .images, label: {
                    if let momentImage {
                        momentImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: dimensions, height: dimensions)
                            .frame(width: dimensions, height: dimensions)
                    } else {
                        Image(systemName: "plus.app.fill")
                            .foregroundStyle(.black)
                            .symbolRenderingMode(.hierarchical)
                            .font(.custom("add", size: dimensions))
                    }
                })
                // otherwise will only display what was recorded before
            } else {
                TextField("No thoughts", text: $log.log_description)
                    .padding()
                    .font(.title3)
                    .disabled(true)
                if let momentImage {
                    momentImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                        .frame(width: dimensions, height: dimensions)
                } else {
                    Image(systemName: "pencil.slash")
                        .foregroundStyle(.black)
                        .symbolRenderingMode(.hierarchical)
                        .font(.custom("add", size: dimensions))
                }
            }
                
        }
        // when detecting a change in textfield, call viewmodel to update description
        .onChange(of: log.log_description) { oldValue, newValue in
            log.log_description = newValue
            Task {
                await fbViewModel.updateDescription(log)
            }
        // when detecting a change in image choice, call viewmodel to update the image data
        }.onChange(of: momentItem) { oldValue, newValue in
            // Convert PhotosPickerItem > Image
            guard let newValue else {
                return
            }
            Task {
                do {
                    guard let data = try await newValue.loadTransferable(type: Data.self) else {
                        print("cannot convert photo item to data")
                        return
                    }
                    uiImage = UIImage(data: data)
                    guard let uiImage else {
                        print("cannot load ui image")
                        return
                    }
                    momentImage = Image(uiImage: uiImage)
                    uploadPhoto()
                    isShowingConfetti = await fbViewModel.allFilled(date: log.log_date)
                } catch {
                    print(error)
                }
            }
            // determine the fileName on first appearance
        }.onAppear() {
            // naming convention: dd/mm/yyyy_entry
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            fbViewModel.fileName = "\(dateFormatter.string(from: log.log_date))_\(log.log_entry)"
            DispatchQueue.main.async {
                Task {
                    // momentImage = await fbViewModel.downloadPhoto()
                    // https://www.youtube.com/watch?v=YgjYVbg1oiA
                    log.log_description = await fbViewModel.getDescription()
                    // the max size need to exceed the possible largest image size!!
                    fbViewModel.storageRef.getData(maxSize: 30000000) { data, error in
                        if (data != nil && error == nil) { // file found
                            if let uii = UIImage(data: data!) {
                                momentImage = Image(uiImage: uii)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // https://www.youtube.com/watch?v=YgjYVbg1oiA
    // not part of the view model because doesn't work when put in the model, not sure why
    // potential extension
    func uploadPhoto() {
        // modify photourl if modified photo
        // upload new photo
        guard uiImage != nil else {
            return
        }
        let imageData = uiImage!.pngData()
        guard imageData != nil else {
            return
        }
        if let location = locationViewModel.lastKnownLocation {
            log.log_latitude = location.coordinate.latitude
            log.log_longitude = location.coordinate.longitude
        }
        let uploadTask = fbViewModel.storageRef.putData(imageData!, metadata: nil) { data, error in
            Task {
                await fbViewModel.uploadData(log)
            }
        }
    }
}


//#Preview {
//    TodayJournalGridView(log: Log(log_date: Date(), log_entry: 0), fbViewModel: FirebaseViewModel())
//}
