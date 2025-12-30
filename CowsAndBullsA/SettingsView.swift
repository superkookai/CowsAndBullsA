//
//  SettingsView.swift
//  CowsAndBullsA
//
//  Created by Weerawut on 30/12/2568 BE.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("maximumGuesses") var maximumGuesses: Int = 50
    @AppStorage("answerLength") var answerLength: Int = 4
    @AppStorage("enableHardMode") var enableHardMode: Bool = false
    @AppStorage("showGuessCount") var showGuessCount: Bool = false
    
    var body: some View {
        TabView {
            Tab("Game", systemImage: "number.circle") {
                Form {
                    TextField("Maximum Guesses", value: $maximumGuesses, format: .number)
                        .help("The maximum number of answers you can submit. Changing this will immedately restart the game.")
                    
                    TextField("Answer Length", value: $answerLength, format: .number)
                        .help("The length of number string to guess. Changing this will immedately restart the game.")
                    
                    if answerLength < 3 || answerLength > 8 {
                        Text("Answer Length must be between 3 and 8")
                            .foregroundStyle(.red)
                    }
                }
                .padding()
            }
            
            Tab("Advance", systemImage: "gearshape.2") {
                Form {
                    Toggle("Enable Hard Mode", isOn: $enableHardMode)
                        .help("This show Cows And Bulls score the most recent only.")
                    
                    Toggle("Show Guess Count", isOn: $showGuessCount)
                        .help("Adds a footer below your guesses showing the total.")
                }
                .padding()
            }
        }
        .frame(width: 400)
    }
}

#Preview {
    SettingsView()
}
