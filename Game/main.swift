//
//  main.swift
//  Game
//
//  Created by Bilal Dallali on 29/09/2023.
//

import Foundation

struct Weapon {
    let name: String
    let damage: Int
}

class Character {
    let name: String
    var lifePoints: Int
    let weapon: Weapon
    
    // Vérifier si le personnage est en vie
    var isAlive: Bool {
        return lifePoints > 0
    }
    
    init(name: String, lifePoints: Int, weapon: Weapon) {
        self.name = name
        self.lifePoints = lifePoints
        self.weapon = weapon
    }
    
    func attack(otherCharacter: Character, from opponentTeam: [Character]) {
        print("attack")
        
        otherCharacter.lifePoints -= self.weapon.damage
        
        print("\(self.name) attacked \(otherCharacter.name) with \(self.weapon.name) causing \(self.weapon.damage) damage!")
        
        if !otherCharacter.isAlive {
            print("\(otherCharacter.name) has died")
        } else {
            print("\(otherCharacter.name) has \(otherCharacter.lifePoints) life points remaining!")
        }
    }

}

class Warrior: Character {
    init(name: String) {
        super.init(name: name, lifePoints: 100, weapon: Weapon(name: "Sword", damage: 50))
    }
}

class Magus: Character {
    init(name: String) {
        super.init(name: name, lifePoints: 150, weapon: Weapon(name: "Sceptre", damage: 5))
    }
    
    func heal(target: Character) {
        target.lifePoints += 20
    }
}

class Colossus: Character {
    init(name: String) {
        super.init(name: name, lifePoints: 250, weapon: Weapon(name: "Hammer", damage: 5))
    }
}

class Dwarf: Character {
    init(name: String) {
        super.init(name: name, lifePoints: 60, weapon: Weapon(name: "Axe", damage: 20))
    }
}

class Player {
    var team = [Character]()
    let name: String
    //var isAlive: Bool = true
    
    init(name: String) {
//        self.isAlive = isAlive
        self.name = name
    }
    
    func typeString(type: Int) -> String {
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
        for _ in 1...3 {
            print("Enter a character name:")
            let name: String = readLine() ?? ""
            print("Choose the type of the character you just named (1. Warrior, 2. Magus, 3. Colossus, 4. Dwarf):")
            let type: Int = Int(readLine() ?? "") ?? 0
            
            var character: Character?
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
                print("Invalid choice!")
                continue
            }
            
            if let character: Character = character {
                team.append(character)
                print("\(character.name) is a \(typeString(type: type)) has been added to your team")
                print("\(playerName) your team is composed of those characters ")
                printTeam()
            }
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
        print("To command, choose a character from your team by its name:")
        player.printTeam()
        if let choice = readLine(), let chosenCharacter = player.team.first(where: {$0.name == choice}) {
            return chosenCharacter
        }
        print("Invalid choice!")
        return nil
    }
    
    // Choose a character from opponent's team
    func chooseCharacterFromOpponentTeam(player: Player) -> Character? {
        print("To attack, choose a character from the opponent's team by its name:")
        player.printTeam()
        if let choice = readLine(), let chosenCharacter = player.team.first(where: {$0.name == choice}) {
            return chosenCharacter
        }
        print("Invalid choice!")
        return nil
    }
    
    // Start the game
    func fight() {
        print("The game starts")
        player1.createTeam(for: "Player1")
        player2.createTeam(for: "Player2")
        
        var currentPlayer = player1
        var opposingPlayer = player2
        
        while player1.teamIsAlive() && player2.teamIsAlive() {
            print("\(currentPlayer.name)'s turn!")
            
            if let activeCharacter = chooseCharacterFromYourTeam(player: currentPlayer) {
                currentPlayer.performAction(for: activeCharacter, against: opposingPlayer, in: self)
            }
            
            // Swap players
            (currentPlayer, opposingPlayer) = (opposingPlayer, currentPlayer)
            
        }
//        if player1.teamIsAlive() {
//            print("\(player1.name) wins")
//        } else {
//            print("\(player2.name) wins")
//        }
        print(player1.teamIsAlive() ? player1.name : player2.name)
    }
    
    func displayGameStatistics() {
        print("Game statistics")
        print("Total rounds Played: \(roundsPlayed)")
        print("\(player1.name)'s Team:")
        
        for character in player1.team {
            print("\(character.name) who is a \(typeString(type: typeOfCharacter(character: character))) with \(character.lifePoints) life points.")
        }
        
        print("\(player2.name)'s Team:")
        
        for character in player2.team {
            print("\(character.name) who is a \(typeString(type: typeOfCharacter(character: character))) with \(character.lifePoints) life points.")
        }
    }
    
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


let player1: Player = Player(name: "player1")
let player2: Player = Player(name: "player2")
let game = Game(player1: player1, player2: player2)
game.fight()
