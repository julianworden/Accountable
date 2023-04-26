//
//  LastWeekChartWidget.swift
//  Accountable
//
//  Created by Julian Worden on 4/21/23.
//

import Foundation
import SwiftUI
import WidgetKit

struct LastWeekChartWidget: Widget {
    let kind = "LastWeekChartWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LastWeekChartWidgetView(entry: entry)
        }
        .configurationDisplayName("This Week's Work")
        .description("A widget that shows the work stored in Accountable from the last week.")
        .supportedFamilies([.systemLarge])
    }
}
