//
//  ContentView.swift
//  ClarkAndKent
//
//  Created by Le Viet Tung on 4/5/26.
//

import SwiftUI

enum TimeUnit: String, CaseIterable {
    case day
    case hour
    case minute
    case second
}

struct ContentView: View {
    private let allTimeUnits = TimeUnit.allCases

    @State private var selectedFromUnit: TimeUnit = .day
    @State private var selectedToUnit: TimeUnit = .second
    @State private var fromInput: String = ""

    let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 2
        return f
    }()

    var fromInputDouble: Double {
        guard let double = Double(fromInput) else { return 0 }
        return double
    }

    var convertResult: Double {
        switch (selectedFromUnit, selectedToUnit) {
        case (.day, .hour):
            return fromInputDouble * 24
        case (.day, .minute):
            return fromInputDouble * 1_440
        case (.day, .second):
            return fromInputDouble * 86_400
        case (.hour, .day):
            return fromInputDouble / 24
        case (.hour, .minute):
            return fromInputDouble * 60
        case (.hour, .second):
            return fromInputDouble * 3_600
        case (.minute, .day):
            return fromInputDouble / 1_440
        case (.minute, .hour):
            return fromInputDouble / 60
        case (.minute, .second):
            return fromInputDouble * 60
        case (.second, .day):
            return fromInputDouble / 86_400
        case (.second, .hour):
            return fromInputDouble / 3_600
        case (.second, .minute):
            return fromInputDouble / 60
        default:
            return fromInputDouble
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("From") {
                    Picker("From", selection: $selectedFromUnit) {
                        ForEach(allTimeUnits, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    }

                    TextField("Enter", text: $fromInput)
                        .keyboardType(.decimalPad)
                        .onChange(of: fromInput) { _, newValue in
                            // 1. Keep only valid characters
                            var filtered = newValue.filter { "0123456789.".contains($0) }

                            // 2. Allow only one decimal point
                            let dotCount = filtered.filter { $0 == "." }.count
                            if dotCount > 1 {
                                let firstDotIndex = filtered.firstIndex(of: ".")!
                                filtered = String(filtered[..<filtered.index(after: firstDotIndex)]) +
                                    filtered[filtered.index(after: firstDotIndex)...].replacingOccurrences(of: ".", with: "")
                            }

                            // 3. Prevent leading zero like "0123"
                            if filtered.count > 1,
                               filtered.first == "0",
                               filtered[filtered.index(after: filtered.startIndex)] != "."
                            {
                                filtered.removeFirst()
                            }

                            // 4. Apply change if needed
                            if filtered != newValue {
                                fromInput = filtered
                            }
                        }
                }
                .pickerStyle(.segmented)

                Section("To") {
                    Picker("To", selection: $selectedToUnit) {
                        ForEach(allTimeUnits, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    }

                    Text(formatter.string(from: NSNumber(value: convertResult)) ?? "")
                }
                .pickerStyle(.segmented)
            }
            .navigationTitle("Time Converter")
        }
    }
}

#Preview {
    ContentView()
}
