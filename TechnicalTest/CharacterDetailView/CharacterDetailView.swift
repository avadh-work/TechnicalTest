//
//  CharacterDetailView.swift
//  TechnicalTest
//
//  Created by Avadh Bambhroliya on 31/03/25.
//

import SwiftUI

/// A SwiftUI view that displays detailed information about a character.
struct CharacterDetailView: View {
    /// The character to display.
    let character: Character

    /// Define a two-column grid layout.
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 20) {
            // Displays the character image asynchronously
            AsyncImage(url: URL(string: character.image ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
            .clipShape(Circle())

            // Displays the character name using a UIKit-based label
            CustomLabelView(text: character.name ?? "")

            // Episodes Grid
            if let episodes = character.episode, !episodes.isEmpty {
                Text("Episodes")
                    .font(.title)
                    .padding(.top)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(episodes, id: \ .self) { episode in
                            Text(episodeName(episodeUrl: episode) ?? "")
                                .font(.system(size: 20).bold())
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .frame(height: 80)
                                .background(randomColor())
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
    }
    
    /// Extracts the episode number from the given URL.
    /// - Parameter episodeUrl: The URL of the episode.
    /// - Returns: The extracted episode number formatted as "Episode X".
    private func episodeName(episodeUrl: String) -> String? {
        if let lastComponent = episodeUrl.split(separator: "/").last {
            return "Episode \(lastComponent)"
        }
        return nil
    }

    /// Generates a random background color for capsules.
    /// - Returns: A randomly selected `Color` from a predefined set.
    private func randomColor() -> Color {
        let colors: [Color] = [.red, .blue, .green, .purple, .orange, .pink, .indigo, .teal]
        return colors.randomElement() ?? .gray
    }
}

// MARK: UIKit component
/// A custom UILabel subclass that applies consistent styling.
class CustomLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    /// Sets up the label appearance.
    private func setup() {
        textColor = .black
        font = UIFont.boldSystemFont(ofSize: 24)
        textAlignment = .center
    }
}

/// A SwiftUI wrapper for the UIKit-based `CustomLabel`.
struct CustomLabelView: UIViewRepresentable {
    /// The text to display in the label.
    let text: String

    /// Creates and configures the `CustomLabel`.
    func makeUIView(context: Context) -> CustomLabel {
        let label = CustomLabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.numberOfLines = 0 // Allow multiple lines if needed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    /// Updates the label with new text.
    func updateUIView(_ uiView: CustomLabel, context: Context) {
        uiView.text = text
    }
}


#Preview {
    CharacterDetailView(character: Character.standardValue)
}
