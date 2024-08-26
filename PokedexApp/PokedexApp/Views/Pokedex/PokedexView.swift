//
//  PokedexView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct PokedexView: View {
    @StateObject var viewModel: PokedexViewModel
    @Environment(\.modelContext) var modelContext
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    init() {
        self._viewModel = StateObject(wrappedValue: PokedexViewModel())
    }

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
                                pokemon: pokemon,
                                store: FavoritePokemonStore(
                                    modelContext: modelContext
                            )
                        )
                    ) {
                        PokedexCellView(pokemon: pokemon)
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
    }
}

#Preview {
    PokedexView()
}
