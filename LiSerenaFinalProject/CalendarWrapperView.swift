//
//  CalendarWrapperView.swift
//  LiSerenaFinalProject
//
//  Created by Serena Li.
//

import SwiftUI
import TipKit

// wrapper view to ensure navigation to the single day journal view
struct CalendarWrapperView: View {
    var calendarTip = CalendarTip()
    var body: some View {
        NavigationStack() {
            // shows a tip about the use of the calendar
            TipView(calendarTip)
                .onTapGesture {
                    calendarTip.invalidate(reason: .actionPerformed)
                        }
            CalendarJournalView()
                .navigationDestination(for: Date.self) { value in
                    TodayJournalView(date: value, isShowingConfetti: false)
            }
        }
    }
}

#Preview {
    CalendarWrapperView()
}
