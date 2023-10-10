//
//  main.swift
//  Game
//
//  Created by Bilal Dallali on 29/09/2023.
//

import Foundation

let player1: Player = Player(name: "player1")
let player2: Player = Player(name: "player2")
let game = Game(player1: player1, player2: player2)
game.fight()
