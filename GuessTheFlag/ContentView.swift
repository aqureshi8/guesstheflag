//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ahsan Qureshi on 3/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var alertMessage = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var questionCount = 0
    @State private var finished = false
    @State private var spin = [0.0, 0.0, 0.0]
    @State private var animate = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(countries[number])
                        }
                        .rotation3DEffect(.degrees(spin[number]), axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/)
                        .opacity(animate[number])
                        .scaleEffect(animate[number])
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }.alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }.alert("Finished", isPresented: $finished) {
            Button("Play Again", action: replay)
        } message: {
            Text("Your final score was \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        withAnimation() {
            spin[number] += 360
            for val in 0..<animate.count {
                if val != number {
                    animate[val] = 0.25
                }
            }
        }
        questionCount += 1
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            alertMessage = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong"
            alertMessage = "Wrong! That's the flag of \(countries[number])."
        }
        
        if (questionCount < 8) {
            showingScore = true
        } else {
            finished = true
        }
    }
    
    func askQuestion() {
        spin = [0.0, 0.0, 0.0]
        animate = [1.0, 1.0, 1.0]
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func replay() {
        score = 0
        questionCount = 0
        askQuestion()
    }
}

struct FlagImage: View {
    let flag: String
    
    init(_ flag: String) {
        self.flag = flag
    }
    
    var body: some View {
        Image(flag)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
