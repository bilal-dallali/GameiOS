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
    var currentPlayer: Player
    var opposingPlayer: Player
    var roundsPlayed: Int = 0
    var totalDamage: Int = 0
    var totalHealing: Int = 0
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
        self.currentPlayer = player1 // it can be the player2 but we consider the starting one is the player1
        self.opposingPlayer = player2
    }
    
    // Choose a character from your team
    func chooseCharacterFromYourTeam(player: Player, excludingCharacter: Character? = nil) -> Character? {
        var characterChosen: Character? = nil
        while characterChosen == nil {
            print("To command, choose a character from your team by its number:")
            for (index, character) in player.team.enumerated() {
                // Check if the character is not the one to exclude
                if character !== excludingCharacter {
                    print("\(index + 1). \(character.name) (\(character.lifePoints) life points)")
                }
            }
            
            if let choice = readLine(), let choiceInt = Int(choice), choiceInt > 0 && choiceInt <= player.team.count {
                let selectedCharacter = player.team[choiceInt - 1]
                // Ensure the selected character is not the excluded character
                if selectedCharacter !== excludingCharacter {
                    characterChosen = selectedCharacter
                } else {
                    print("Invalid choice! You cannot select this character. Please try again!")
                }
            } else {
                print("Invalid choice! Please try again!")
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
                // Check if the active character is a Magus
                if let magus = activeCharacter as? Magus {
                    // Ask the player if they want to attack or heal
                    print("Do you want to (1) Attack or (2) Heal?")
                    if let choice = readLine(), let choiceInt = Int(choice) {
                        switch choiceInt {
                        case 1:
                            // Proceed with attack
                            if let target = chooseCharacterFromOpponentTeam(player: opposingPlayer) {
                                magus.attack(otherCharacter: target, from: opposingPlayer.team)
                                opposingPlayer.removeDeadCharacters()
                            }
                        case 2:
                            // Proceed with heal, excluding the Magus from the list
                            if let target = chooseCharacterFromYourTeam(player: currentPlayer, excludingCharacter: magus) {
                                magus.heal(target: target)
                            }
                        default:
                            print("Invalid choice! Please try again!")
                        }
                    }
                } else {
                    // If the character is not a Magus, proceed with attack
                    if let target = chooseCharacterFromOpponentTeam(player: opposingPlayer) {
                        activeCharacter.attack(otherCharacter: target, from: opposingPlayer.team)
                        opposingPlayer.removeDeadCharacters()
                    }
                }
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
