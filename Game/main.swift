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
    var isAlive: Bool {
        return lifePoints > 0
    }
    
    init(name: String, lifePoints: Int, weapon: Weapon) {
        self.name = name
        self.lifePoints = lifePoints
        self.weapon = weapon
    }
    
    func attack() {
        print("attack")
    }
}

class Warrior: Character {
    init(name: String) {
        super.init(name: name, lifePoints: 100, weapon: Weapon(name: "Sword", damage: 10))
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
    var team: [Character] = []
    var isAlive: Bool
    
    init(isAlive: Bool) {
        self.isAlive = isAlive
    }
    
    // Create team
    func createTeam() {
        print("create team of three characters")
        for _ in 1...3 {
            print("enter a character name:")
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
                print("\(character.name) is a \(type) has been added to your team")
                print("Your team is composed of those characters ")
            }
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
    
    // Start the game
    func start() {
        print("The game starts")
        player1.createTeam()
        player2.createTeam()
    }
}


let player1: Player = Player(isAlive: true)
let player2: Player = Player(isAlive: true)
let game = Game(player1: player1, player2: player2)
game.start()

//var test: String = readLine() ?? ""
//
//print("readline: \(test)")
