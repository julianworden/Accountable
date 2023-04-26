//
//  TotalHoursWorkedWidget.swift
//  Accountable
//
//  Created by Julian Worden on 4/26/23.
//

import Foundation
import SwiftUI
import WidgetKit

struct TotalHoursWorkedWidget: Widget {
    let kind = "TotalHoursWorkedWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TotalHoursWorkedWidgetView(entry: entry)
        }
        .configurationDisplayName("Total Hours (All Projects)")
        .description("Shows the sum of all hours worked in Accountable")
        .supportedFamilies([.systemSmall])
    }
}
