import SwiftUI

final class PokemonDetailViewModel: ObservableObject {
    let pokemon: Pokemon
    private let pokemonManager = PokemonManager()

    @Published var pokemonDetails: DetailedPokemon? = nil
    @Published var pokemonSpecies: PokemonSpecies? = nil
    @Published var showError: Bool = false
    @Published var favoritedPokemon: [Pokemon] = []
    @Published var isShiny = false

    private var store: FavoritePokemonStore

    init(pokemon: Pokemon, favoritedPokemonStore: FavoritePokemonStore) {
        self.pokemon = pokemon
        self.store = favoritedPokemonStore
    }

    func onAppear() {
        store.fetchPokemon()
        favoritedPokemon = store.favorites
    }

    func addFavorite(pokemon: Pokemon) {
        store.save(pokemon: pokemon)
        favoritedPokemon = store.favorites
    }

    func toggleFavoritePokemon(_ pokemon: Pokemon) {
        if isPokemonFavorited(pokemon) {
            store.delete(pokemon: pokemon)
        } else {
            store.save(pokemon: pokemon)
        }

        store.fetchPokemon()
        favoritedPokemon = store.favorites
    }

    func isPokemonFavorited(_ pokemonToCheck: Pokemon) -> Bool {
        store.fetchPokemon()
        return store.favorites.contains { pokemon in
            pokemonToCheck.id == pokemon.id
        }
    }

    func formatHeightWeight(value: Int) -> String {
        let dValue = Double(value)
        return String(format: "%.2f", dValue / 10)
    }

    func fetchPokemonImageURL() -> String {
        let index = pokemonDetails?.id ?? 0
        let baseUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
        return isShiny ? "\(baseUrl)shiny/\(index).png" : "\(baseUrl)\(index).png"
    }

    func fetchPokemonDetails() {
        fetchDetails(pokemon: pokemon) { details in
            if let details = details {
                self.pokemonDetails = details
                self.fetchPokemonSpecies(details.species.url)
            } else {
                self.showError = true
            }
        }
    }

    func fetchDetails(pokemon: Pokemon, completion: @escaping (DetailedPokemon?) -> Void) {
        if let details = pokemonDetails {
            completion(details)
            return
        }

        pokemonManager.fetchDetailedPokemon(url: pokemon.url) { data in
            DispatchQueue.main.async {
                if let data = data {
                    self.pokemonDetails = data
                    completion(data)
                } else {
                    completion(nil)
                }
            }
        }
    }

    func fetchPokemonSpecies(_ url: String) {
        fetchSpecies(url: url) { species in
            if let species = species {
                self.pokemonSpecies = species
            } else {
                self.showError = true
            }
        }
    }

    func fetchSpecies(url: String, completion: @escaping (PokemonSpecies?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            let decoder = JSONDecoder()
            if let species = try? decoder.decode(PokemonSpecies.self, from: data) {
                DispatchQueue.main.async {
                    completion(species)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }

    // Connects Pokémon type to a color
    func color(forType type: String) -> Color {
        switch type.lowercased() {
        case "fire":
            return Color.red
        case "water":
            return Color.blue
        case "grass":
            return Color.green
        case "electric":
            return Color.yellow
        case "psychic":
            return Color.purple
        case "ice":
            return Color.cyan
        case "dragon":
            return Color.orange
        case "dark":
            return Color.gray
        case "fairy":
            return Color.pink
        case "normal":
            return Color.brown
        default:
            return Color.gray
        }
    }
}
