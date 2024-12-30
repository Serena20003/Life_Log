//
//  TodayJournalView.swift
//  LiSerenaFinalProject
//
//  Created by Serena Li.
//

import SwiftUI
import PhotosUI
import TipKit
import ConfettiView

// The today view displaying current day's entries
// although called "today", but the calendar view redirects to this view as well, hence need the previous view to pass the date
struct TodayJournalView: View {
    @State var date: Date
    var fbvm = FirebaseViewModel(filename: "")
    var month: String {
        if let monthInt = Calendar.current.dateComponents([.month], from: date).month {
            return Calendar.current.monthSymbols[monthInt-1]
        }
        return ""
    }
    var day: Int {
        return Calendar.current.dateComponents([.day], from: date).day ?? -1
    }
    // creating instances of tips
    let descTip = DescTip()
    let addImageTip = AddImageTip()
    @State var isShowingConfetti: Bool
    var body: some View {
        NavigationStack() {
            // defines the confettiview
            let confetti = ConfettiView( confetti: [
                .text("🥳"),
                .text("💪"),
                .text("🤯"),
                .text("✌️"),
                // if using SF symbols, UIImage takes systemName to build
                .image(UIImage(systemName: "star.fill")!)
            ])
            ZStack {
                ScrollView() {
                    // tips will show on the top of the page until tapped away once
                    TipView(descTip)
                    TipView(addImageTip)
                    // shows 3 grids of individual entries, each with their unique document names
                    ForEach(0..<3) {entry in
                        TodayJournalGridView(log: Log(log_date: date, log_entry: entry), fbViewModel: FirebaseViewModel(filename: ""), isShowingConfetti: $isShowingConfetti)
                    }
                }
                // ZStack ensures the confetti comes on top of the other views
                if isShowingConfetti {
                    confetti
                }
            }.background(.creamFlow)
        }.navigationTitle("\(month) \(day)")
        .onTapGesture {
            // tapping dismisses the tips and stops confetti
            descTip.invalidate(reason: .actionPerformed)
            addImageTip.invalidate(reason: .actionPerformed)
            isShowingConfetti = false
        }
    }
}

#Preview {
    TodayJournalView(date: Date() - 86400, isShowingConfetti: true) // yesterday, test
}
