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
    
    var activeCharacter: Character?

    func printTeam() {
        for character in team {
            let typeName = typeString(type: typeOfCharacter(character: character)) ?? "Unknown"
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
        print("\(playerName) create your team of three characters !")

        while team.count < 3 {
            print("Enter a character name :")
            guard let name = readLine(), !name.isEmpty else {
                print("Invalid name ! Please try again !")
                continue
            }

            //var characterType: String?
            var character: Character?
            while character == nil {
                print("Choose the type of the character you just named (1. Warrior, 2. Magus, 3. Colossus, 4. Dwarf):")
                let typeInput = readLine()

                switch typeInput {
                case "1":
                    character = Warrior(name: name)
                    //characterType = "Warrior"
                case "2":
                    character = Magus(name: name)
                    //characterType = "Magus"
                case "3":
                    character = Colossus(name: name)
                    //characterType = "Colossus"
                case "4":
                    character = Dwarf(name: name)
                    //characterType = "Dwarf"
                default:
                    print("Invalid choice! Please enter a number between 1 and 4.\n")
                    continue //optionel, pas utile en l'état
                }
            }

            if let character = character {
                team.append(character)
                let characterType = String(describing: type(of: character))
                print("\(character.name) who is a \(characterType) has been added to your team.")
                print("Your team is composed of :")
                printTeam()
            }
        }

        print("\(playerName), your team is composed of the following characters:")
        printTeam()
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

//       func chooseCharacterForHeal() -> Character? {
//           print("To heal, choose a character from your team by its name:")
//           return chooseCharacter()
//       }
    
    func chooseCharacterForHeal(player: Player, healer: Magus) -> Character? {
        var characterChosen: Character? = nil
        while characterChosen == nil || characterChosen === healer {
            print("To heal, choose a character from your team by its number (you cannot heal yourself):")
            for (index, character) in player.team.enumerated() {
                print("\(index + 1). \(character.name) (\(character.lifePoints) life points)")
            }
            
            if let choice = readLine(), let choiceInt = Int(choice), choiceInt > 0 && choiceInt <= player.team.count {
                characterChosen = player.team[choiceInt - 1]
            } else {
                print("Invalid choice! Please try again!")
            }
            
            if characterChosen === healer {
                print("You cannot heal yourself! Please choose another character.")
                characterChosen = nil // reset the choice
            }
        }
        return characterChosen
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
                if target !== magus {
                    magus.heal(target: target)
                    print("\(magus.name) healed \(target.name) by 20 points!")
                } else {
                    print("A magus cannot heal himself")
                }
            }
        default:
            print("Invalid choice!")
        }
    }
}
