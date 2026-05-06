//
//  CustomAlertView.swift
//  GuessTheFlag
//
//  Created by Le Viet Tung on 5/5/26.
//

import SwiftUI

struct CustomAlertContainer<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                content.transition(.scale)
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

struct CustomAlertView: View {
    let title: String
    let message: String
    let buttonTitle: String
    let onDismiss: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            if !message.isEmpty {
                Text(message)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
            }

            Button(buttonTitle) {
                onDismiss?()
            }
            .frame(maxWidth: 300, maxHeight: 10)
            .padding()
            .background(Color.green)
            .foregroundStyle(.white)
            .cornerRadius(12)
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding(40)
    }
}

#Preview {
    CustomAlertView(title: "ALERT", message: "234234234234", buttonTitle: "Done", onDismiss: nil)
}
