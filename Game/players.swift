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
                print("⚠️ Invalid name ! Please try again !")
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
                case "2":
                    character = Magus(name: name)
                case "3":
                    character = Colossus(name: name)
                case "4":
                    character = Dwarf(name: name)
                default:
                    print("⚠️ Invalid choice! Please enter a number between 1 and 4.\n")
                    continue //optionel, pas utile en l'état
                }
            }

            if let character = character {
                team.append(character)
                let characterType = String(describing: type(of: character))
                print("\(character.name) who is a \(characterType) has been added to your team.\n")
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
    
    func chooseCharacterForHeal(player: Player, healer: Magus) -> Character? {
        var characterChosen: Character? = nil
        while characterChosen == nil {
            print("To heal, choose a character from your team by its number (you cannot heal yourself):")
            // Filter out the healer from the list of characters
            let healableCharacters = player.team.filter { $0 !== healer && $0.isAlive }
            for (index, character) in healableCharacters.enumerated() {
                print("\(index + 1). \(character.name) (\(character.lifePoints) life points)")
            }
            
            if let choice = readLine(), let choiceInt = Int(choice), choiceInt > 0 && choiceInt <= healableCharacters.count {
                characterChosen = healableCharacters[choiceInt - 1]
            } else {
                print("⚠️ Invalid choice! Please try again!")
            }
        }
        return characterChosen
    }
    
    func performAction(for character: Character, against opponent: Player, in game: Game) {
        var actionSuccess = false

        while !actionSuccess {
            // Check if the character is a Magus and prompt for action choice.
            if let magus = character as? Magus {
                print("Do you want to (1) Attack or (2) Heal?")
                if let choice = readLine() {
                    switch choice {
                    case "1":
                        // Attack logic
                        if let target = game.chooseCharacterFromOpponentTeam(player: opponent) {
                            magus.attack(otherCharacter: target, from: opponent.team)
                            opponent.removeDeadCharacters()
                            actionSuccess = true
                        }
                    case "2":

                        // Present a list of characters from the player's team, excluding the Magus
                        let healableCharacters = team.filter { $0 !== magus && $0.isAlive }
                        if healableCharacters.isEmpty {
                            print("There is no characters to heal.")
                            continue
                        }
                        print("To heal, choose a character from your team by its number:")
                        for (index, character) in healableCharacters.enumerated() {
                            print("\(index + 1). \(character.name) (\(character.lifePoints) life points)")
                        }
                        if let choice = readLine(), let choiceInt = Int(choice), choiceInt > 0 && choiceInt <= healableCharacters.count {
                            let characterToHeal = healableCharacters[choiceInt - 1]
                            magus.heal(target: characterToHeal)
                            actionSuccess = true
                        } else {
                            print("⚠️ Invalid choice! Please try again.")
                        }
                    default:
                        print("⚠️ Invalid choice! Please try again.")
                    }
                }
            } else {
                // If the character is not a Magus, proceed with the attack logic.
                if let target = game.chooseCharacterFromOpponentTeam(player: opponent) {
                    character.attack(otherCharacter: target, from: opponent.team)
                    opponent.removeDeadCharacters()
                    actionSuccess = true
                }
            }
        }
    }
    
    private func chooseCharacter() -> Character? {
        printTeam()
        if let choice = readLine(), let chosenCharacter = team.first(where: {$0.name == choice}) {
            return chosenCharacter
        }
        print("⚠️ Invalid choice!")
        return nil
    }

}
