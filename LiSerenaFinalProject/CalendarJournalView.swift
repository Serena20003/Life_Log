//
//  CalendarJournalView.swift
//  LiSerenaFinalProject
//
//  Created by Serena Li.
//

import SwiftUI

// the calendar view using UIKit Calendar through UIViewRepresentable
struct CalendarJournalView: View {
    @State var dateSelected: Date?
    @State var isNavigating = false
    var body: some View {
        VStack() {
            // https://www.youtube.com/watch?v=d8KYAeBDQAQ
            CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), dateSelected: $dateSelected, isNavigating: $isNavigating)
        }.background(.creamFlow).edgesIgnoringSafeArea(.all)
        NavigationLink(destination: TodayJournalView(date: dateSelected ?? Date(), isShowingConfetti: false), isActive: $isNavigating) {
        }
    }
}

#Preview {
    CalendarJournalView()
}
