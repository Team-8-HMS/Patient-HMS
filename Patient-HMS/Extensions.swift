//
//  Extensions.swift
//  Patient-HMS
//
//  Created by Krsna Sharma on 05/07/24.
//

import Foundation
import SwiftUI

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}


struct CalendarDayView: View {
    let date: Date

    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(dayOfMonth)
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(width: 80, height: 100)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }

    private var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date)
    }

    private var dayOfMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
}
