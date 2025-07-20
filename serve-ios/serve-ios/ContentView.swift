import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // Home Tab
            NavigationStack {
                HomeView()
            }
            .toolbar(.hidden, for: .navigationBar) // Hide top bar
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            // Recycle Tab
            NavigationStack {
                recycle_game()
            }
            .toolbar(.hidden, for: .navigationBar)
            .tabItem {
                Label("Recycle", systemImage: "arrow.2.circlepath")
            }

            // Reuse Tab
            NavigationStack {
                FinalReuseGameView()
            }
            .toolbar(.hidden, for: .navigationBar)
            .tabItem {
                Label("Reuse", systemImage: "arrow.2.circlepath.circle")
            }

            // Reduce Tab
            NavigationStack {
                ReduceGameMenuView()
            }
            .toolbar(.hidden, for: .navigationBar)
            .tabItem {
                Label("Reduce", systemImage: "scalemass")
            }
        }
    }
}

// MARK: - Home View
struct HomeView: View {
    var body: some View {
        ZStack {
            Image("Green_Forest_1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // Centered Title
                VStack(spacing: 8) {
                    Text("Hello!")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                    Text("Welcome back!")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                }

                Spacer().frame(height: 20)

                // Buttons
                VStack(spacing: 20) {
                    NavigationLink("Recycle") {
                        recycle_game()
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    NavigationLink("Reuse") {
                        FinalReuseGameView()
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    NavigationLink("Reduce") {
                        ReduceGameMenuView()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .frame(maxWidth: 400)
                .padding(.horizontal)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

// MARK: - Button Style
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.7))
            .cornerRadius(40)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

