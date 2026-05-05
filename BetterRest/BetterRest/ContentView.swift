//
//  ContentView.swift
//  BetterRest
//
//  Created by Le Viet Tung on 5/5/26.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var desireSleepAmount = 8.0
    @State private var wakeup = defaultWakeTime
    @State private var cupOfCoffee = 0
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }

    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    Text("When do you want to wake up?")
                        .font(.headline.bold())

                    DatePicker("Choose a time", selection: $wakeup, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowSeparator(.hidden)

                VStack {
                    Text("Desire amount of sleep")
                        .font(.headline)
                    Stepper("\(desireSleepAmount.formatted()) hours", value: $desireSleepAmount, in: 4 ... 12, step: 0.25)
                }

                VStack {
                    Text("Daily coffee intake")
                        .font(.headline)
                    Stepper("^[\(cupOfCoffee) cup](inflect: true)", value: $cupOfCoffee, in: 0 ... 20, step: 1)
                }
            }
            .toolbar {
                Button("Calculate", action: calculateBedTime)
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") {
                    showAlert = false
                }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculatorModel(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeup)
            let hour = (components.hour ?? 0) * 3600
            let minute = (components.minute ?? 0) * 60

            let result = try model.prediction(
                input: .init(wake: Double(hour + minute), estimatedSleep: desireSleepAmount, coffee: Double(cupOfCoffee))
            )
            alertTitle = "Result"
            alertMessage = (wakeup - result.actualSleep).formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Something wrong!"
            alertMessage = "Please try again later"
        }

        showAlert = true
    }
}

#Preview {
    ContentView()
}
