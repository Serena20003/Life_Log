//
//  CalendarTip.swift
//  LiSerenaFinalProject
//
//  Created by Serena Li.
//

import SwiftUI
import TipKit

// tip for using the calendar view
struct CalendarTip: Tip {
    var title: Text {
        Text("This is the calendar")
    }


    var message: Text? {
        Text("Where you can revisit logs from before")
    }


    var image: Image? {
        Image(systemName: "calendar")
    }
    
}
