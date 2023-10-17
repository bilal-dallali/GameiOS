//
//  players.swift
//  Game
//
//  Created by Bilal Dallali on 01/10/2023.
//

import Foundation

class Player {
    var team = [Character]()
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func typeString(type: Int) -> String? {
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
            return nil
        }
    }

    func printTeam() {
        for character in team {
            let typeName = typeString(type: typeOfCharacter(character: character))
            print("- \(character.name) who is a \(typeName)")
        }
    }

    func typeOfCharacter(character: Character) -> Int {
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

    
    // Create team
    func createTeam(for playerName: String) {
        print("\(playerName) create team of three characters")
        
        var teamCount = 0
        
        while teamCount < 3 {
            print("Enter a character name:")
            let name: String = readLine() ?? ""
            
            var character: Character? = nil
            
            while character == nil {
                print("Choose the type of the character you just named (1. Warrior, 2. Magus, 3. Colossus, 4. Dwarf):")
                
                guard let typeInput = readLine(), let type = Int(typeInput) else {
                    print("Invalid input ! Please enter a number.")
                    continue
                }
                
                switch type {
                case 1:
                    character = Warrior(name: name)
                case 2:
                    character = Magus(name: name)
                case 3:
                    character = Colossus(name: name)
                case 4:
                    character = Dwarf(name: name)
                default:
                    print("Invalid choice ! Please choose a number between 1 and 4 to have the corresponding character in your team")
                    continue
                }
            }
            
            team.append(character!)
            teamCount += 1
            print("\(character!.name) is a \(typeString(type: type) ?? "Unknown") has been added to your team")
            print("\(playerName) your team is composed of those characters :")
            printTeam()
        }
    }
    
    func removeDeadCharacters() {
        self.team = self.team.filter { $0.isAlive }
    }

    
    // Checking if my team is still alive
    func teamIsAlive() -> Bool {
        return team.contains { $0.isAlive }
    }
    
    func selectActionFor(character: Character) -> Int {
           if let _ = character as? Magus {
               print("Do you want to (1) Attack or (2) Heal?")
               return Int(readLine() ?? "") ?? 0
           }
           return 1
       }

       
       func chooseCharacterForAttack() -> Character? {
           print("To attack, choose a character from your team by its name:")
           return chooseCharacter()
       }

       func chooseCharacterForHeal() -> Character? {
           print("To heal, choose a character from your team by its name:")
           return chooseCharacter()
       }

       private func chooseCharacter() -> Character? {
           printTeam()
           if let choice = readLine(), let chosenCharacter = team.first(where: {$0.name == choice}) {
               return chosenCharacter
           }
           print("Invalid choice!")
           return nil
       }
    
    func performAction(for character: Character, against opponent: Player, in game: Game) {
        switch selectActionFor(character: character) {
        case 1:
            if let target = game.chooseCharacterFromOpponentTeam(player: opponent) {
                character.attack(otherCharacter: target, from: opponent.team)
                opponent.removeDeadCharacters() // Remove characters from the opponent's team that have died.
            }
        case 2:
            if let magus = character as? Magus,
               let target = game.chooseCharacterFromYourTeam(player: self) {
                magus.heal(target: target)
                print("\(magus.name) healed \(target.name) by 20 points!")
            }
        default:
            print("Invalid choice!")
        }
    }
}
