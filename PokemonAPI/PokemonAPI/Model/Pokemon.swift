//
//  Pokemon.swift
//  PokemonAPI
//
//  Created by Mondale on 5/15/20.
//  Copyright © 2020 Mondale. All rights reserved.
//

import Foundation

struct PokemonList: Codable {
    let next: String?
    let results: [Pokemon]
}

struct Pokemon : Codable{
    let name: String
    let url: String
}


