//
//  ContentView.swift
//  CowsAndBullsA
//
//  Created by Weerawut on 30/12/2568 BE.
//

import SwiftUI

struct ContentView: View {
    @State private var guesses: [String] = []
    @State private var guess: String = ""
    @State private var answer : String = ""
    @State private var isGameOver: Bool = false
    @State private var errorMessage: String = ""
    @State private var guessCount: Int = 0
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @AppStorage("maximumGuesses") var maximumGuesses: Int = 50
    @AppStorage("answerLength") var answerLength: Int = 4
    @AppStorage("enableHardMode") var enableHardMode: Bool = false
    @AppStorage("showGuessCount") var showGuessCount: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                TextField("Enter a guess...", text: $guess)
                    .onSubmit(submitGuess)
                
                Button {
                    submitGuess()
                } label: {
                    Text("Go")
                }
            }
            .padding(.horizontal)
            
            Group {
                if !errorMessage.isEmpty {
                    HStack {
                        Image(systemName: "xmark.square.fill")
                        Text(errorMessage)
                        Spacer()
                    }
                    .foregroundStyle(.red)
                } else {
                    Text(" ")
                }
            }
            .padding(.horizontal)
            
            List(0..<guesses.count, id: \.self) { index in
                let guess = guesses[index]
                let shouldShowResult = (enableHardMode == false) || (enableHardMode && index == 0)
                
                HStack {
                    Text(guess)
                    Spacer()
                    if shouldShowResult {
                        Text(result(for: guess))
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.sidebar)
            
            if showGuessCount {
                Text("Guesses: \(guesses.count)/\(maximumGuesses)")
            }
        }
        .padding(.vertical)
        .frame(width: 250)
        .frame(minHeight: 300)
        .navigationTitle("Cows And Bulls")
        .onAppear {
            startNewGame()
        }
        .alert(alertTitle, isPresented: $isGameOver) {
            Button("OK", action: startNewGame)
        } message: {
            Text(alertMessage)
        }
        .onChange(of: answerLength) {
            startNewGame()
        }
        .onChange(of: maximumGuesses) {
            startNewGame()
        }
    }
    
    private func submitGuess() {
        let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
        guard guess.rangeOfCharacter(from: badCharacters) == nil else {
            errorMessage = "Only numbers are allowed."
            return
        }
        guard guess.count == answerLength else {
            errorMessage = "Enter only \(answerLength) digits."
            return
        }
        guard Set(guess).count == answerLength else {
            errorMessage = "Enter a guess with all unique digits."
            return
        }
        
        
        if let _ = guesses.firstIndex(where: {$0 == guess}) {
            errorMessage = "You already guessed that."
            return
        }
        errorMessage = ""
        guesses.insert(guess, at: 0)
        guessCount += 1
        
        if result(for: guess).contains("\(answerLength)b") {
            alertTitle = "You Win!"
            if guessCount < 10 {
                alertMessage = "Great! Only \(guessCount)!\nClick OK to play again."
            } else if guessCount < 20 {
                alertMessage = "Good! \(guessCount) less than 20!\nClick OK to play again."
            } else {
                alertMessage = "Not bad at \(guessCount) guesses!\nClick OK to play again."
            }
            isGameOver = true
        } else if guessCount >= maximumGuesses {
            alertTitle = "Opps!"
            alertMessage = "Guess over \(maximumGuesses)! Click OK to play again."
            isGameOver = true
        }
        
        guess = ""
    }
    
    private func result(for guess: String) -> String {
        var bulls = 0
        var cows = 0
        let guessArray = Array(guess)
        let answerArray = Array(answer)
        for (i,letter) in guessArray.enumerated() {
            if letter == answerArray[i] {
                bulls += 1
            } else if answerArray.contains(letter) {
                cows += 1
            }
        }
        return "\(bulls)b \(cows)c"
    }
    
    private func startNewGame() {
        guard answerLength >= 3 && answerLength <= 8 else {
            errorMessage = "Set your Answer length between 3 and 8 in Settings."
            return
        }
        guessCount = 0
        guess = ""
        guesses.removeAll()
        answer = ""
        answer = (0...9)
            .shuffled()
            .prefix(answerLength)
            .map(String.init)
            .joined()
        print("Answer: \(answer)")
    }
}

#Preview {
    ContentView()
}
