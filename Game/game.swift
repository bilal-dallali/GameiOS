//
//  game.swift
//  Game
//
//  Created by Bilal Dallali on 01/10/2023.
//

import Foundation

class Game {
    let player1: Player
    let player2: Player
    var roundsPlayed: Int = 0
    var totalDamage: Int = 0
    var totalHealing: Int = 0
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    // Choose a character from your team
    func chooseCharacterFromYourTeam(player: Player) -> Character? {
        var characterChosen: Character? = nil
        while characterChosen == nil {
            print("To command, choose a character from your team by its number:")
            for (index, character) in player.team.enumerated() {
                print("\(index + 1). \(character.name) (\(character.lifePoints) life points)")
            }
            
            if let choice = readLine(), let choiceInt = Int(choice), choiceInt > 0 && choiceInt <= player.team.count {
                characterChosen = player.team[choiceInt - 1]
            } else {
                print("Invalid choice ! Please try again !")
            }
        }
        return characterChosen
    }

    
    // Choose a character from opponent's team
    func chooseCharacterFromOpponentTeam(player: Player) -> Character? {
        var characterChosen: Character? = nil
        while characterChosen == nil {
            print("To attack, choose a character from the opponent's team by its number:")
            for (index, character) in player.team.enumerated() {
                print("\(index + 1). \(character.name) (\(character.lifePoints) life points)")
            }
            
            if let choice = readLine(), let choiceInt = Int(choice), choiceInt > 0 && choiceInt <= player.team.count {
                characterChosen = player.team[choiceInt - 1]
            } else {
                print("Invalid choice ! Please try again !")
            }
        }
        return characterChosen
    }

    // Start the game
    func fight() {
        print("The game starts")
        player1.createTeam(for: "Player1")
        player2.createTeam(for: "Player2")
        
        var currentPlayer = player1
        var opposingPlayer = player2
        
        while player1.teamIsAlive() && player2.teamIsAlive() {
            roundsPlayed += 1
            print("Round \(roundsPlayed):")
            print("\(currentPlayer.name)'s turn!")
            
            if let activeCharacter = chooseCharacterFromYourTeam(player: currentPlayer) {
                currentPlayer.performAction(for: activeCharacter, against: opposingPlayer, in: self)
            }
            
            // Swap players
            (currentPlayer, opposingPlayer) = (opposingPlayer, currentPlayer)
            
        }
        
        print("\(player1.teamIsAlive() ? player1.name : player2.name) wins the game\n")
        displayGameStatistics()
    }
    
    func displayGameStatistics() {
        print("Game statistics:")
        print("Total rounds Played: \(roundsPlayed)\n")
        
        // fonction à refactoriser
        print("\(player1.name)'s Team:")
        if player1.team.isEmpty {
            print("- There are no character remaining in this team\n")
        }
        for character in player1.team {
            print("\(character.name) who is a \(typeString(type: typeOfCharacter(character: character))) with \(character.lifePoints) life points.")
        }
        
        print("\(player2.name)'s Team:")
        if player2.team.isEmpty {
            print("- There are no characters remaining in this team\n")
        }
        
        for character in player2.team {
            print("- \(character.name) who is a \(typeString(type: typeOfCharacter(character: character))) with \(character.lifePoints) life points.")
        }
    }
    
    // eventuellement -> character
    private func typeString(type: Int) -> String {
        switch type {
        case 1:
            return "Warrior"
        case 2:
            return "Magus"
        case 3:
            return "Colossus"
        case 4:
            return "Dwarf"
        default:
            return "Unknown"
        }
    }
    
    enum CharacterType : String, CaseIterable {
    case Warrior
    case Magus
    case Colossus
    case Dwarf
        var identifier: Int {
            switch self {
            case .Warrior:
                return 1
            case .Magus:
                return 2
            case .Colossus:
                return 3
            case .Dwarf:
                return 4
            }
        }
    }

    private func typeOfCharacter(character: Character) -> Int {
        switch character {
        case is Warrior:
            return 1
        case is Magus:
            return 2
        case is Colossus:
            return 3
        case is Dwarf:
            return 4
        default:
            return 0
        }
    }
}
