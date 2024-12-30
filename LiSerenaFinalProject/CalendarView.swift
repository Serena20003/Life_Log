//
//  CalendarView.swift
//  LiSerenaFinalProject
//
//  Created by Serena Li.
//

import SwiftUI
import UIKit

// View to transfer UIKit Calendarview to SwiftUI view and transfers data between
struct CalendarView: UIViewRepresentable {
    
    let interval: DateInterval
    @Binding var dateSelected: Date?
    @Binding var isNavigating: Bool
    
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        // https://github.com/StewartLynch/UICalendarView_SwiftUI-Completed/blob/main/UICalendarView_SwiftUI/Views/CalendarViewTab/CalendarView.swift
        view.delegate = context.coordinator
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = dateSelection
        return view
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        print("")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, dateSelected: $dateSelected)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarView
        @Binding var dateSelected: Date?
        
        init(parent: CalendarView, dateSelected: Binding<Date?>) {
            self.parent = parent
            self._dateSelected = dateSelected
        }
        
        // records the selected date
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let dateComponents else {
                return
            }
            parent.dateSelected = Calendar.current.date(from: dateComponents)
            DispatchQueue.main.async { [self] in
                parent.isNavigating = true
            }
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }
        
    }
}
