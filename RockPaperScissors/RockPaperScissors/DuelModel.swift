//
//  DuelModel.swift
//  RockPaperScissors
//
//  Created by Le Viet Tung on 6/5/26.
//

import SwiftUI

enum DuelResult: String, CaseIterable {
    case win
    case lose
    case draw

    var color: Color {
        switch self {
        case .win: return .green
        case .lose: return .red
        case .draw: return .yellow
        }
    }
}

enum DuelOption: String, CaseIterable {
    case rock
    case paper
    case scissors
}
