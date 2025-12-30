import Cocoa

var answer = ""

answer = (0...9)
    .shuffled()
    .prefix(4)
    .map(String.init)
    .joined()


var bulls = 0
var cows = 0

let guess = "1532"
if answer == guess {
    bulls = 4
    cows = 0
    //return
} else {
    let guessArray = guess.split(separator: "")
    let answerArray = answer.split(separator: "")
    for i in 0..<4 {
        if guessArray[i] == answerArray[i] {
            bulls += 1
        }
        
        if answerArray.contains(guessArray[i]) {
            cows += 1
        }
    }
}

print("Bulls: \(bulls)")
print("Cows: \(cows)")
