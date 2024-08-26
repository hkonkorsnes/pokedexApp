//
//  Extensions.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) from bundle.")
        }
        
        return loadedData
    }
}

extension TypeDetail {
    // Connects Pokémon type to a color
    func color() -> Color {
        switch name.lowercased() {
        case "normal":
            return Color.gray
        case "fire":
            return Color.red
        case "water":
            return Color.blue
        case "grass":
            return Color.green
        case "ice":
            return Color.teal
        case "electric":
            return Color.yellow
        case "psychic":
            return Color.pink
        case "dragon":
            return Color.indigo
        case "poison":
            return Color.purple
        case "fighting":
            return Color.brown
        case "rock":
            return Color.brown
        case "flying":
            return Color.mint
        case "bug":
            return Color.green
        case "ghost":
            return Color.purple
        default:
            return Color.gray
        }
    }
}
