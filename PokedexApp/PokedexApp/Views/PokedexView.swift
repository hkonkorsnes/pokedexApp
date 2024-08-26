//
//  PokedexView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct PokedexView: View {
    @EnvironmentObject var viewModel: PokemonViewModel
    @Environment(\.modelContext) var modelContext
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    private var columns: [GridItem] {
        if dynamicTypeSize.isAccessibilitySize {
            return [
                GridItem(.flexible())
            ]
        }

        return [
            GridItem(.adaptive(minimum: 150))
        ]
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.filteredPokemon) { pokemon in
                    NavigationLink(
                        destination: PokemonDetailView(
                            viewModel: PokemonDetailViewModel(
                                favoritedPokemonStore: FavoritePokemonStore(
                                    modelContext: modelContext
                                )
                            ), pokemon: pokemon
                        )
                    ) {
                        PokedexCellView(pokemon: pokemon)
                    }
                }
            }
            .padding()
            .navigationTitle("Pokédex")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: {
                            viewModel.isShiny.toggle()
                        }) {
                            Label("Toggle shiny variants", systemImage: "sparkles")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText)
    }
}

#Preview {
    PokedexView()
        .environmentObject(PokemonViewModel())
}
