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
    @StateObject var viewModel = PokemonViewModel()
    
    var body: some View {
        TabView {
            NavigationStack {
                PokedexView()
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
        .environmentObject(viewModel)
    }
}

#Preview {
    PokedexTabView()
}
