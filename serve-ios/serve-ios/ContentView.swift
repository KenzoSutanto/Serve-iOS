import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
    }
}


struct HomeView: View {
    let game = createGame()
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .overlay(
                        Image("Green_Forest_1")
                            .resizable()
                            .scaledToFill()
                    )
                    .ignoresSafeArea()
                VStack(spacing: geo.size.height * 0.0146) {
                    Spacer()
                
                    VStack(spacing: 8) {
                        Text("Hello!")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                        Text("Welcome back!")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer().frame(height: geo.size.height * 0.0146)
                    

                    VStack(spacing: geo.size.height * 0.0146) {
                        NavigationLink("Recycle") {
                            recycle_game()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        NavigationLink("Reuse") {
                            ReuseGameView()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        NavigationLink("Reduce") {
                            ReduceGameView(game: game)
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                    .frame(maxWidth: geo.size.width * 0.390)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
        }
    }
}

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

