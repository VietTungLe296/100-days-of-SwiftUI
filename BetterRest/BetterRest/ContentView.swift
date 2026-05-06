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
    @State private var actualSleepAmount = ""

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack {
                        Text("When do you want to wake up?")
                            .font(.headline.bold())

                        DatePicker("Choose a time", selection: $wakeup, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .onChange(of: wakeup) { _ in
                                calculateBedTime()
                            }
                    }

                    VStack {
                        Text("Desire amount of sleep")
                            .font(.headline.weight(.semibold))
                        Stepper("\(desireSleepAmount.formatted()) hours", value: $desireSleepAmount, in: 4 ... 12, step: 0.25)
                            .onChange(of: desireSleepAmount) { _ in
                                calculateBedTime()
                            }
                    }

                    Picker("Daily coffee intake", selection: $cupOfCoffee) {
                        ForEach(0 ..< 21) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                    .onChange(of: cupOfCoffee) { _ in
                        calculateBedTime()
                    }

                    VStack {
                        Text("YOU NEED TO SLEEP AT")
                            .font(.title.bold().italic())
                        Text("\(actualSleepAmount)")
                            .font(.system(size: 100, design: .rounded))
                    }
                }
            }
            .padding()
        }
        .onAppear {
            calculateBedTime()
        }
        .alert("Something wrong!", isPresented: $showAlert) {
            Button("Done") {}
        } message: {
            Text("Please try again later")
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
            actualSleepAmount = (wakeup - result.actualSleep).formatted(date: .omitted, time: .shortened)
        } catch {
            showAlert = true
        }
    }
}

#Preview {
    ContentView()
}
