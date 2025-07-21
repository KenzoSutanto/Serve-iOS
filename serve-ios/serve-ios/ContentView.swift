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
                VStack {
                    Spacer()
                    
                    // Header
                    VStack(spacing: 10) {
                        Text("Hello!")
                            .font(.system(size: geo.size.width * 0.097, weight: .heavy, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Welcome to our game!")
                            .font(.system(size: geo.size.width * 0.097, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 40)
                    
                    VStack(spacing: geo.size.height * 0.058) {
                        NavigationLink {
                            recycle_game()
                        } label: {
                            Text("RECYCLE")
                                .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.12)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                                .shadow(radius: 5)
                                .font(.system(size: min(geo.size.width, geo.size.height) * 0.06,
                                              weight: .heavy,
                                              design: .rounded))
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .frame(width: geo.size.width * 0.3, height: geo.size.width * 0.1)
                        .padding()
                        
                        NavigationLink {
                            ReuseGameView()
                        } label: {
                            Text("REUSE")
                                .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.12)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                                .shadow(radius: 5)
                                .font(.system(size: min(geo.size.width, geo.size.height) * 0.06,
                                              weight: .heavy,
                                              design: .rounded))
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .frame(width: geo.size.width * 0.3, height: geo.size.width * 0.1)
                        .padding()
                        
                        NavigationLink {
                            ReduceGameView(game: game)
                        } label: {
                            Text("REDUCE")
                                .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.12)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                                .shadow(radius: 5)
                                .font(.system(size: min(geo.size.width, geo.size.height) * 0.06,
                                              weight: .heavy,
                                              design: .rounded))
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .frame(width: geo.size.width * 0.3, height: geo.size.width * 0.1)
                        .padding()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.green)
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

