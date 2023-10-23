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
        if target === self {
            print("A Magus cannot heal himself!")
        } else {
            target.lifePoints += 20
            print("\(self.name) heals \(target.name), \(target.name) gains 20 life points!")
        }
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
