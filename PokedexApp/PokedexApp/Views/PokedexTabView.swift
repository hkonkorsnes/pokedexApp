//
//  PokedexTabView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct PokedexTabView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        TabView {
            NavigationStack {
                PokedexView(viewModel: PokedexViewModel())
            }
            .tabItem {
                Label("Pokédex", systemImage: "list.dash")
            }
            
            NavigationStack {
                RandomPokemonView(viewModel: RandomPokemonViewModel())
                    .navigationTitle("Who's that Pokémon?")
            }
            .tabItem {
                Label("Who", systemImage: "person.fill.questionmark")
            }
            
            NavigationStack {
                FavoritedPokemonView(
                    viewModel: FavoritedPokemonViewModel(
                        favoritedPokemonStore: FavoritePokemonStore(modelContext: modelContext)
                    )
                )
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
