import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject var viewModel: PokemonViewModel
    let pokemon: Pokemon

    var body: some View {
        VStack {
            PokeDexView(pokemon: pokemon)

            VStack(alignment: .leading, spacing: 10) {
                Text("**ID**: \(viewModel.pokemonDetails?.id ?? 0)")
                Text("**Weight**: \(viewModel.formatHeightWeight(value: viewModel.pokemonDetails?.weight ?? 0)) kg")
                Text("**Height**: \(viewModel.formatHeightWeight(value: viewModel.pokemonDetails?.height ?? 0)) m")
                Text("**Type**: \(viewModel.pokemonDetails?.types.map { $0.type.name.capitalized }.joined(separator: ", ") ?? "Unknown")")
            }

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleFavoritePokemon(pokemon)
                    // Toggle the save state
                    addFavorite()
                }) {
                    Image(systemName: viewModel.isPokemonFavorited(pokemon) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isPokemonFavorited(pokemon) ? .red : .gray)
                }
            }
        }
        .onAppear {
            viewModel.getDetails(pokemon: pokemon)
        }
    }

    func addFavorite() {
        let pokemon = Pokemon(name: "Gyarados", url: "https://pokeapi.co/api/v2/pokemon/130/")
    }
}

#Preview {
    PokemonDetailView(pokemon: Pokemon.samplePokemon)
        .environmentObject(PokemonViewModel())
}
