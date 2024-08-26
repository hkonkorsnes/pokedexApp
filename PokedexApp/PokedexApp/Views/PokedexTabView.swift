//
//  PokedexTabView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct PokedexTabView: View {
    @Environment(\.modelContext) var modelContext

    var body: some View {
        TabView {
            NavigationStack {
                PokedexView()
                    .navigationTitle("Pokédex")
            }
            .tabItem {
                Label("Pokédex", systemImage: "list.dash")
            }

            NavigationStack {
                RandomPokemonView()
                    .navigationTitle("Who's that Pokémon?")
            }
            .tabItem {
                Label("Who", systemImage: "person.fill.questionmark")
            }

            NavigationStack {
                FavoritedPokemonView(store: FavoritePokemonStore(modelContext: modelContext))
                    .navigationTitle("Saved Pokémon")
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
        }
    }
}

#Preview {
    PokedexTabView()
}
