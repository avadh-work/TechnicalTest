//
//  CharacterListView.swift
//  TechnicalTest
//
//  Created by Avadh Bambhroliya on 31/03/25.
//

import SwiftUI

/// A SwiftUI view that displays a list of characters.
/// Fetches data from `CharacterViewModel` and supports pagination.
struct CharacterListView: View {
    /// The view model responsible for fetching character data.
    @StateObject var viewModel = CharacterViewModel()
    
    var body: some View {
        NavigationView {
            List {
                // Through the list of characters and displays each one
                ForEach(viewModel.characters) { character in
                    NavigationLink(destination: CharacterDetailView(character: character)) {
                        HStack {
                            // Loads and displays character image asynchronously
                            AsyncImage(url: URL(string: character.image ?? "")) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            
                            // Displays character name
                            Text(character.name ?? "")
                        }
                    }
                }
                
                // Load More button for pagination if there are more characters to fetch
                if viewModel.nextURL != nil {
                    Button(action: {
                        viewModel.loadNextPage()
                    }) {
                        HStack {
                            Spacer()
                            Text("Load More")
                                .foregroundColor(.blue)
                                .padding()
                            Spacer()
                        }
                    }
                    .padding(.top)
                }
            }
            .onAppear {
                // Fetches the initial list of characters when the view appears
                viewModel.loadCharacters()
            }
            .navigationTitle("Characters")
        }
    }
}


#Preview {
    CharacterListView()
}
