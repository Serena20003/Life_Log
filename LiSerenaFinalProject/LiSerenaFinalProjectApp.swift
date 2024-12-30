//
//  LiSerenaFinalProjectApp.swift
//  LiSerenaFinalProject
//
//  Created by Serena Li.
//

import SwiftUI
import TipKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // initialize and congigure firebase app
        FirebaseApp.configure()
        return true
    }
}

// Singleton used in the app
var user_id: String = "BLANK"

@main
struct LiSerenaFinalProjectApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Group {
                    // 3 tabs
                    CalendarWrapperView()
                        .tabItem {
                            Label("Calendar", systemImage: "calendar")
                        }
                    TodayJournalView(date:Date(), isShowingConfetti: false)
                        .tabItem {
                            Label("Today", systemImage: "camera.fill")
                        }
                    MapJournalView()
                        .tabItem {
                            Label("Map", systemImage: "mappin.and.ellipse")
                        }
                }
                // how to make background cover the whole screen: https://forums.developer.apple.com/forums/thread/121799
                .toolbarBackground(.pinkDiary, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .task {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)])
                }
            }
        }
    }
    
    init() {
        try? Tips.configure()
        // user_id will be the same for the same simulator even after quit the background instance
        // asking for permission to track location for photos
        var locationViewModel = LocationViewModel()
        locationViewModel.requestPermission()
        // assign user id
        if (UserDefaults.standard.string(forKey: "UserID") == nil) {
            UserDefaults.standard.set(UUID().uuidString, forKey: "UserID")
        }
        user_id = UserDefaults.standard.string(forKey: "UserID") ?? "GUEST"
        print("The permission to read/write freely to the firebase will expire on 2024/12/28")
    }
}
