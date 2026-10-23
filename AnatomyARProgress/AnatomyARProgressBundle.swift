//
//  AnatomyARProgressBundle.swift
//  AnatomyARProgress
//
//  Created by Ravindu Wijethunga on 2026-10-19.
//

import WidgetKit
import SwiftUI

@main
struct AnatomyARProgressBundle: WidgetBundle {
    // both the progress widget and Live Activity ship in this extension
    var body: some Widget {
        AnatomyARProgress()
        StudySessionLiveActivity()
    }
}
