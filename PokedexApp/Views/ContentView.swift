//
//  ContentView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PokemonViewModel()
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                    ForEach(viewModel.filteredPokemon) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)
                        ) {
                            PokemonView(pokemon: pokemon)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.filteredPokemon.count)
                .navigationTitle("PokéDex")
            }
            .searchable(text: $viewModel.searchText)
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
