//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Le Viet Tung on 6/5/26.
//

import Combine
import SwiftUI

struct ContentView: View {
    @State private var playCount = 1
    @State private var score = 0
    @State private var shuffledOptions = DuelOption.allCases.shuffled()
    @State private var expectedResult: DuelResult = DuelResult.allCases.randomElement() ?? .win
    @State private var botOption = DuelOption.allCases.randomElement() ?? .rock

    @State private var showResult = false
    @State private var timeRemaining = 3
    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.teal, .blue], startPoint: .bottom, endPoint: .top)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Duel \(playCount)/10 ~ Score: \(score)")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)

                    Text("\(timeRemaining)")
                        .font(.system(size: 100, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("YOU SHOULD")
                            .font(.title.weight(.bold))
                            .foregroundStyle(.white)

                        Text(expectedResult.rawValue.capitalized)
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(expectedResult.color)
                    }

                    Image(botOption.rawValue)
                        .resizable()
                        .frame(width: 250, height: 250)

                    HStack(spacing: 24) {
                        ForEach(shuffledOptions, id: \.self) { option in
                            Button {
                                handlePlayerButton(option)
                            } label: {
                                Image(option.rawValue)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                    Button {
                        resetGame()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Restart")
                        }
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)
                }
            }
            .alert("Result", isPresented: $showResult) {
                Button("OK") {
                    resetGame()
                }
            } message: {
                Text("Your final score is \(score)")
            }
            .onReceive(timer) { _ in
                guard !showResult else { return }

                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    proceedNextDuel()
                }
            }
        }
    }

    private func handlePlayerButton(_ playerOption: DuelOption) {
        let result: DuelResult
        switch (playerOption, botOption) {
        case (.rock, .paper), (.paper, .scissors), (.scissors, .rock):
            result = .lose
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
            result = .win
        default:
            result = .draw
        }

        if result == expectedResult {
            score += 1
        } else {
            if score > 0 {
                score -= 1
            }
        }

        proceedNextDuel()
    }

    private func proceedNextDuel() {
        playCount += 1
        if playCount > 10 {
            playCount = 1
            showResult = true
            return
        }

        generateDuel()
    }

    private func resetGame() {
        score = 0
        playCount = 1
        generateDuel()
    }

    private func generateDuel() {
        resetTimer()
        expectedResult = DuelResult.allCases.randomElement() ?? .win
        botOption = DuelOption.allCases.randomElement() ?? .rock
        shuffledOptions.shuffle()
    }

    private func resetTimer() {
        timeRemaining = 3
    }
}

#Preview {
    ContentView()
}
