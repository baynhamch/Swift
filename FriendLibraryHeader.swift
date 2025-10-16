//
//  FriendLibraryHeader.swift
//  fibril2
//
//  Created by Nicholas Conant-Hiley on 10/16/25.
//

import SwiftUI

import SwiftUI
import UIKit

struct FriendLibraryHeader: View {
    // Starts with you first
    let users = ["Me", "Sarah", "Ben", "Alice"]
    
    @State private var index = 0
    @State private var dragOffset: CGFloat = 0
    @State private var crossedThreshold = false
    
    // Animation / gesture tunables
    private let threshold: CGFloat = 80
    private let snapSpring = Animation.interpolatingSpring(stiffness: 200, damping: 22)

    var body: some View {
        GeometryReader { _ in
            let isFirst = index == 0
            let isLast  = index == users.count - 1
            let alignment: Alignment = isFirst ? .leading : (isLast ? .trailing : .center)

            VStack(spacing: 0) {
                // MARK: - Title and subtitle
                VStack(alignment: isFirst ? .leading : (isLast ? .trailing : .center), spacing: 4) {
                    Text(titleText(users[index]))
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: alignment)
                        .offset(x: dragOffset * 0.2)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: index)

                    Text(subtitleText(users[index]))
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: alignment)
                        .offset(x: dragOffset * 0.25)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity, alignment: alignment)

                // MARK: - Accent line
                Rectangle()
                    .fill(Color(red: 0.35, green: 0.75, blue: 0.55))
                    .frame(height: 2)
                    .padding(paddingForLine(isFirst: isFirst, isLast: isLast))
                    .offset(x: dragOffset)
            }
            .gesture(dragGesture)
            .animation(snapSpring, value: index)
        }
        .frame(height: 120)
    }

    // MARK: - Gesture
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                dragOffset = rubberBand(value.translation.width)
                let crossed = abs(value.translation.width) > threshold
                if crossed && !crossedThreshold {
                    crossedThreshold = true
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                } else if !crossed {
                    crossedThreshold = false
                }
            }
            .onEnded { value in
                let dx = value.translation.width
                let vx = value.predictedEndTranslation.width - dx

                if abs(dx) > threshold || abs(vx) > 400 {
                    if dx < 0 && index < users.count - 1 { index += 1 }   // swipe left → next
                    if dx > 0 && index > 0              { index -= 1 }   // swipe right → prev
                }

                withAnimation(snapSpring) { dragOffset = 0 }
                crossedThreshold = false
            }
    }

    // MARK: - Helpers
    private func rubberBand(_ x: CGFloat) -> CGFloat {
        x / (1 + abs(x) / 150)
    }

    private func titleText(_ user: String) -> String {
        user == "Me" ? "My Library" : "\(user)’s Library"
    }

    private func subtitleText(_ user: String) -> String {
        user == "Me" ? "Books I’ve collected" : "\(user)’s collected"
    }

    private func paddingForLine(isFirst: Bool, isLast: Bool) -> EdgeInsets {
        if isFirst { return EdgeInsets(top: 0, leading: 80, bottom: 0, trailing: 0) }      // align left
        if isLast  { return EdgeInsets(top: 0, leading: 0,  bottom: 0, trailing: 80) }     // align right
        return EdgeInsets(top: 0, leading: 120, bottom: 0, trailing: 120)                  // centered
    }
}

#Preview {
    FriendLibraryHeader()
}
