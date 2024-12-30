//
//  DescTip.swift
//  LiSerenaFinalProject
//
//  Created by Serena Li.
//

import SwiftUI
import TipKit

// tip for describing moment
struct DescTip: Tip {
    var title: Text {
        Text("You can describe the moment")
    }


    var message: Text? {
        Text("Tap on the placeholder and start writing.")
    }


    var image: Image? {
        Image(systemName: "pencil.and.scribble")
    }
    
}
