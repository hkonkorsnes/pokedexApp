//
//  PokedexView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct PokedexView: View {
    @ObservedObject var viewModel: PokedexViewModel
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
                                pokemon: pokemon,
                                favoritedPokemonStore: FavoritePokemonStore(
                                    modelContext: modelContext
                                )
                            )
                        )
                    ) {
                        PokedexCellView(pokemon: pokemon, viewModel: viewModel)
                    }
                    .buttonStyle(.plain)
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
        .onAppear {
            viewModel.fetchAllPokemonDetails()
        }
    }
}

#Preview {
    PokedexView(viewModel: PokedexViewModel())
}
