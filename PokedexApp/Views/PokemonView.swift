import SwiftUI

struct PokemonView: View {
    @EnvironmentObject var viewModel: PokemonViewModel
    let pokemon: Pokemon
    let dimensions: Double = 160
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(viewModel.getPokemonIndex(pokemon: pokemon)).png")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: dimensions, height: dimensions)
            } placeholder: {
                ProgressView()
                    .frame(width: dimensions, height: dimensions)
            }
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text("\(pokemon.name.capitalized)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding(.bottom, 8)
        }
    }
}

#Preview {
    PokemonView(pokemon: Pokemon.samplePokemon)
        .environmentObject(PokemonViewModel())
}
