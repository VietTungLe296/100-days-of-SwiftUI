//
//  ContentView.swift
//  WeSplit
//
//  Created by Le Viet Tung on 4/5/26.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberofPeople = 0
    @State private var tipPercentage = 15

    @FocusState private var amountIsFocus

    private let tipOptions = [0, 10, 15, 20, 25]

    var originalAmount: Double {
        return checkAmount + (checkAmount / 100 * Double(tipPercentage))
    }

    var splitAmount: Double {
        return originalAmount / Double(numberofPeople + 2)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocus)
                        .submitLabel(.next)

                    Picker("Number of people", selection: $numberofPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0)")
                        }
                    }
                }

                Section("Leave a tip?") {
                    Picker("Tip", selection: $tipPercentage) {
                        ForEach(0..<101, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }.pickerStyle(.navigationLink)
                }

                Section("OG Amount") {
                    Text(originalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }

                Section("Split Amount") {
                    Text(splitAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("We Split")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Cancel") {
                        amountIsFocus = false
                    }
                    Spacer()
                    Button("Done") {
                        amountIsFocus = false
                    }
                }
            }
            .onAppear {
                amountIsFocus = true
            }
        }
    }
}

#Preview {
    ContentView()
}
