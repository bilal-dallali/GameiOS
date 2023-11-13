//
//  characters.swift
//  Game
//
//  Created by Bilal Dallali on 29/09/2023.
//

import Foundation

class Character {
    let name: String
    var lifePoints: Int
    let weapon: Weapon
    
    // Check if the character is alive
    var isAlive: Bool {
        return lifePoints > 0
    }
    
    init(name: String, lifePoints: Int, weapon: Weapon) {
        self.name = name
        self.lifePoints = lifePoints
        self.weapon = weapon
    }
    
    func attack(otherCharacter: Character, from opponentTeam: [Character]) {
        
        otherCharacter.lifePoints -= self.weapon.damage
        
        print("\(self.name) attacked \(otherCharacter.name) with \(self.weapon.name) causing \(self.weapon.damage) damage!")
        
        if !otherCharacter.isAlive {
            print("\(otherCharacter.name) has died ☠️\n")
        } else {
            print("\(otherCharacter.name) has \(otherCharacter.lifePoints) life points remaining!")
        }
    }

}

class Warrior: Character {
    init(name: String) {
        super.init(name: name, lifePoints: 100, weapon: Weapon(name: "Sword ⚔️", damage: 50))
        // Damage = 10 but we can put 50 for the tests so the game doesn't last forever
    }
}

class Magus: Character {
    init(name: String) {
        super.init(name: name, lifePoints: 150, weapon: Weapon(name: "Sceptre ", damage: 5))
    }
    
    func heal(target: Character) {
        if target === self {
            print("A Magus cannot heal himself!")
        } else {
            target.lifePoints += 20
            print("\(self.name) heals \(target.name), \(target.name) is healed by 20 life points! ❤️‍🩹")
        }
    }
}

class Colossus: Character {
    init(name: String) {
        super.init(name: name, lifePoints: 250, weapon: Weapon(name: "Hammer 🔨", damage: 5))
    }
}

class Dwarf: Character {
    init(name: String) {
        super.init(name: name, lifePoints: 60, weapon: Weapon(name: "Axe 🪓", damage: 20))
    }
}
