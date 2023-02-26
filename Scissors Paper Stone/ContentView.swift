//
//  ContentView.swift
//  Scissors Paper Stone
//
//  Created by Prakhar Trivedi on 26/2/23.
//

import SwiftUI

enum WeaponChoice: String {
    case scissors = "scissors", paper = "paper", stone = "granite"
}

enum GameResult {
    case player, computer, draw
}

struct WeaponImage: View {
    var weapon: WeaponChoice
    
    var body: some View {
        Image(weapon.rawValue)
            .resizable()
            .frame(width: 60, height: 60)
    }
}

struct ContentView: View {
    let availableWeaponChoices: [WeaponChoice] = [.scissors, .paper, .stone]
    
    @State var welcomeAlertShown: Bool = false
    @State var welcomeAlertShowing: Bool = true
    @State var playerScore: Int = 0
    @State var computerScore: Int = 0
    @State var turnsCount: Int = 1
    
    @State var computerChoice: String = "question-mark"
    @State var playerChoice: String = "question-mark"
    
    @State var playerShouldWin: Bool = Bool.random()
    @State var doingChoiceReveal: Bool = false
    @State var gameResult: GameResult? = nil
    
    @State var gameOverAlertTitle: String = ""
    @State var gameOverAlertMessage: String = ""
    @State var gameOverAlertShowing: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Text("Round \(turnsCount)/10")
                    .font(.title3)
                Spacer()
                Text("Computer" + (gameResult == .computer ? " WINS!": gameResult == .player ? " loses.": ": \(computerScore)"))
                    .font(.title2.weight(.bold))
                    .foregroundColor(gameResult == .computer ? .green: gameResult == .player ? .red: .primary)
                Spacer()
                Image(computerChoice)
                    .resizable()
                    .frame(width: 100, height: 100)
                Spacer()
            }
            ZStack {
                if gameResult == .draw {
                    Text("DRAW!")
                        .font(.largeTitle.weight(.black))
                        .foregroundColor(.red)
                } else {
                    Divider()
                }
            }
            VStack {
                Spacer()
                
                Image(playerChoice)
                    .resizable()
                    .frame(width: 100, height: 100)
                Spacer()
                if !doingChoiceReveal {
                    HStack(spacing: 20) {
                        ForEach(0..<3) { number in
                            Button {
                                triggerChoiceReveal(playerWeaponChoice: availableWeaponChoices[number])
                            } label: {
                                WeaponImage(weapon: availableWeaponChoices[number])
                            }
                        }
                    }
                }
                Spacer()
                Text("You" + (gameResult == .player ? " WIN!": gameResult == .computer ? " lose.": ": \(playerScore)"))
                    .font(.title2.weight(.bold))
                    .foregroundColor(gameResult == .player ? .green: gameResult == .computer ? .red: .primary)
                Spacer()
                if gameResult == nil {
                    Text(playerShouldWin ? "You have to WIN this round. Choose your weapon accordingly.": "You have to LOSE this round. Choose your weapon accordingly.")
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                } else {
                    Button("Continue >") {
                        if turnsCount == 10 {
                            if playerScore > computerScore {
                                gameOverAlertTitle = "You won!!!"
                                gameOverAlertMessage = "You beat the computer by \(playerScore - computerScore) point(s)!"
                            } else if computerScore > playerScore {
                                gameOverAlertTitle = "You lost! :("
                                gameOverAlertMessage = "You lost to the computer by \(computerScore - playerScore) points(s)!"
                            } else {
                                gameOverAlertTitle = "You drew with the computer!"
                                gameOverAlertMessage = "Looks like you are just as smart as your phone, not that I was doubting you of course!"
                            }
                            
                            gameOverAlertShowing = true
                        } else {
                            resetGame()
                        }
                    }
                }
            }
            Spacer()
        }
        .alert(gameOverAlertTitle, isPresented: $gameOverAlertShowing) {
            Button {
                resetGame(resetScore: true)
            } label: {
                Text("Play again!")
            }
        } message: {
            Text(gameOverAlertMessage)
        }
        .alert("Welcome to Complex Scissors Paper Stone!", isPresented: $welcomeAlertShowing) {
            Button("Play!") {
                welcomeAlertShown = true
            }
        } message: {
            Text("In this game, the app will tell you what you have to do; if the app tells you to win, you have to try and select a weapon that will get you to win. If the app tells you to lose, you have to select a weapon that will get you to lose, and because you did what was expected of you, you *actually* win! This is a brain teasing game that adds an additional level of fun to Scissors, Paper, Stone!")
        }
    }
    
    func triggerChoiceReveal(playerWeaponChoice: WeaponChoice) {
        playerChoice = playerWeaponChoice.rawValue
        computerChoice = availableWeaponChoices.randomElement()?.rawValue ?? "question-mark"
        
        let playerWeapon = playerWeaponChoice
        let computerWeapon = WeaponChoice(rawValue: computerChoice)!
        
        // Determine who won the round
        var winner: GameResult? = nil
        if playerWeapon == computerWeapon {
            winner = .draw
        } else if playerWeapon == .scissors && computerWeapon == .stone {
            winner = .computer
        } else if playerWeapon == .stone && computerWeapon == .scissors {
            winner = .player
        } else if playerWeapon == .paper && computerWeapon == .scissors {
            winner = .computer
        } else if playerWeapon == .scissors && computerWeapon == .paper {
            winner = .player
        } else if playerWeapon == .stone && computerWeapon == .paper {
            winner = .computer
        } else if playerWeapon == .paper && computerWeapon == .stone {
            winner = .player
        }
        
        // Determine who actually won the round based on whether the player was supposed to win
        if winner == .draw {
            gameResult = .draw
        } else if playerShouldWin && winner == .player {
            gameResult = .player
        } else if !playerShouldWin && winner == .computer {
            gameResult = .player
        } else {
            gameResult = .computer
        }
        
        // Add up the points for the respective player
        if gameResult == .player {
            playerScore += 1
        } else if gameResult == .computer {
            computerScore += 1
        }
        
        // Reveal the round result to the user
        doingChoiceReveal = true
    }
    
    func resetGame(resetScore: Bool = false) {
        if resetScore == true {
            computerScore = 0
            playerScore = 0
            turnsCount = 1
        } else {
            turnsCount += 1
        }
        
        gameResult = nil
        doingChoiceReveal = false
        computerChoice = "question-mark"
        playerChoice = "question-mark"
        playerShouldWin = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
