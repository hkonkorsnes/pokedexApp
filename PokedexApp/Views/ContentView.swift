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
                            PokeDexView(pokemon: pokemon)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.filteredPokemon.count)
                .navigationTitle("PokéDex")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu(content: {
                            Button(role: .none) {
                                viewModel.isShiny.toggle()
                                print("Shiny shown: \(viewModel.isShiny)")
                            } label: {
                                Label("Toggle shiny variants", systemImage: "sparkles")
                            }
                        }, label: {
                            Image(systemName: "ellipsis.circle")
                                .imageScale(.large)
                        })
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
