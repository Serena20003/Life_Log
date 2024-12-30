//
//  AddImageTip.swift
//  LiSerenaFinalProject
//
//  Created by Serena Li.
//

import SwiftUI
import TipKit

// tip for adding an image (moment)
struct AddImageTip: Tip {
    var title: Text {
        Text("Add a special moment")
    }


    var message: Text? {
        Text("Click the + icon to add a memory from your photos album")
    }


    var image: Image? {
        Image(systemName: "photo")
    }
    
}
