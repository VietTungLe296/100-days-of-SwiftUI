//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Le Viet Tung on 4/5/26.
//

import SwiftUI

enum QuizAlert: Identifiable {
    case correct
    case incorrect(correctAnswer: String)
    case final(score: Int)

    var id: String {
        switch self {
        case .correct: return "correct"
        case .incorrect: return "incorrect"
        case .final: return "final"
        }
    }
}

struct ContentView: View {
    @State private var allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Ukraine", "US", "UK", "Spain"]
    @State private var correctAnswer: Int = .random(in: 0 ... 2)

    @State private var score = 0
    @State private var askedQuestions = 0
    @State private var activeAlert: QuizAlert?

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .indigo, location: 0.3),
                .init(color: .mint, location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()

            VStack {
                Spacer()
                Spacer()

                Text("Guess The Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)

                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Text("Tap the flag of")
                            .font(.headline.weight(.heavy))
                            .foregroundStyle(.secondary)

                        Text(allCountries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    .foregroundStyle(.white)

                    ForEach(0 ..< 3) { number in
                        Button {
                            checkResult(number)
                        } label: {
                            Image(allCountries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 8)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()

                VStack {
                    Text("Score \(score)")
                        .font(.title.weight(.bold))
                        .foregroundStyle(.white)

                    Button {
                        resetQuiz()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Restart")
                                .font(.headline.weight(.bold))
                        }
                    }
                    .padding(10)
                    .background(.red)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 12))
                }

                Spacer()
                Spacer()
            }

            if let alert = activeAlert {
                CustomAlertContainer(isPresented: Binding(
                    get: { activeAlert != nil },
                    set: { if !$0 { activeAlert = nil } }
                )) {
                    switch alert {
                    case .correct:
                        CustomAlertView(title: "Correct", message: "", buttonTitle: "Next") {
                            activeAlert = nil
                            nextQuiz()
                        }
                    case .incorrect(let answer):
                        CustomAlertView(title: "Incorrect", message: "That was \(answer)", buttonTitle: "Next") {
                            activeAlert = nil
                            nextQuiz()
                        }
                    case .final(let score):
                        CustomAlertView(title: "Finished", message: "Score: \(score)/8", buttonTitle: "Restart") {
                            activeAlert = nil
                            resetQuiz()
                        }
                    }
                }
            }
        }
    }

    private func checkResult(_ number: Int) {
        if number == correctAnswer {
            score += 1
            activeAlert = .correct
        } else {
            activeAlert = .incorrect(correctAnswer: allCountries[correctAnswer])
        }
    }

    private func nextQuiz() {
        askedQuestions += 1

        if askedQuestions > 8 {
            activeAlert = .final(score: score)
            return
        }

        allCountries.shuffle()
        correctAnswer = Int.random(in: 0 ... 2)
    }

    private func resetQuiz() {
        allCountries.shuffle()
        correctAnswer = Int.random(in: 0 ... 2)
        askedQuestions = 0
        score = 0
    }
}

#Preview {
    ContentView()
}
