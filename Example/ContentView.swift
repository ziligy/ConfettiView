//
//  ContentView.swift
//
//  Example for:
//      https://github.com/ziligy/ConfettiView
//
//  Created by Jeffrey Greenberg on 5/27/20.
//  Copyright © 2020 Jeffrey Greenberg. All rights reserved.
//

import SwiftUI
import ConfettiView

struct ContentView: View {

    @State private var isShowingConfetti: Bool = false

    var body: some View {

        let confettiCelebrationView = ConfettiCelebrationView(isShowingConfetti: $isShowingConfetti, timeLimit: 4.0)

        let playButton = Button(action: {
            NotificationCenter.default.post(name: Notification.Name.playConfettiCelebration, object: Bool.self)
        }) {
            Text("Play Celebration!!")
        }.transition(.slowFadeIn)

        return ZStack {
            if !isShowingConfetti { playButton }
            confettiCelebrationView
        }
    }
}

/// a timed celebration
struct ConfettiCelebrationView: View {

    @Binding var isShowingConfetti: Bool // true while confetti is displayed

    private var timeLimit: TimeInterval // how long to display confetti

    @State private var timer = Timer.publish(every: 0.0, on: .main, in: .common).autoconnect()

    init(isShowingConfetti: Binding<Bool>, timeLimit: TimeInterval = 4.0) {
        self.timeLimit = timeLimit
        _isShowingConfetti = isShowingConfetti
    }

    var body: some View {

        // define confetti cell elements & fadeout transition
        let confetti = ConfettiView( confetti: [
            .text("🎉"),
            .text("💪"),
            .shape(.circle),
            .shape(.triangle),
            // if using SF symbols, UIImage takes systemName to build
            .image(UIImage(systemName: "star.fill")!)
        ]).transition(.slowFadeOut)

        return ZStack {
            // show either confetti or nothing
            if isShowingConfetti { confetti } else { EmptyView() }
        }.onReceive(timer) { time in
            // timer beat is one interval then quit the confetti
            self.timer.upstream.connect().cancel()
            self.isShowingConfetti = false
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name.playConfettiCelebration)) { _ in
            // got notification so do --> reset & play
            self.resetTimerAndPlay()
        }
    }

    // reset the timer and turn on confetti
    private func resetTimerAndPlay() {
        timer = Timer.publish(every: self.timeLimit, on: .main, in: .common).autoconnect()
        isShowingConfetti = true
    }

}

// notification to start timer & display the confetti celebration view
public extension Notification.Name {
    static let playConfettiCelebration = Notification.Name("play_confetti_celebration")
}

// fade in & out transitions for ConfettiView and Play button
extension AnyTransition {
    static var slowFadeOut: AnyTransition {
        let insertion = AnyTransition.opacity
        let removal = AnyTransition.opacity.animation(.easeOut(duration: 1.5))
        return .asymmetric(insertion: insertion, removal: removal)
    }

    static var slowFadeIn: AnyTransition {
        let insertion = AnyTransition.opacity.animation(.easeIn(duration: 1.5))
        let removal = AnyTransition.opacity
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
