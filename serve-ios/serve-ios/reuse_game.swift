import SwiftUI

struct ReuseGameView: View {
    // Reusable items
    @State private var items = [
        ReuseItem(id: 1, name: "Cardboard Box", image: "shippingbox", originalUse: "Shipping", reuseOptions: ["Play House", "Storage Bin", "Art Canvas"], position: CGPoint(x: 50, y: 100)),
        ReuseItem(id: 2, name: "Glass Jar", image: "jar", originalUse: "Food Storage", reuseOptions: ["Pencil Holder", "Vase", "Terrarium"], position: CGPoint(x: 150, y: 100)),
        ReuseItem(id: 3, name: "Old T-Shirt", image: "tshirt", originalUse: "Clothing", reuseOptions: ["Rags", "Tote Bag", "Quilt"], position: CGPoint(x: 250, y: 100)),
        ReuseItem(id: 4, name: "Egg Carton", image: "egg", originalUse: "Holding Eggs", reuseOptions: ["Seed Starter", "Paint Palette", "Organizer"], position: CGPoint(x: 350, y: 100)),
        ReuseItem(id: 5, name: "Plastic Bottle", image: "waterbottle", originalUse: "Drinking", reuseOptions: ["Bird Feeder", "Watering Can", "Piggy Bank"], position: CGPoint(x: 450, y: 100))
    ]
    
    // Reuse stations
    let stations = [
        ReuseStation(type: .craft, position: CGPoint(x: 100, y: 600)),
        ReuseStation(type: .garden, position: CGPoint(x: 300, y: 600)),
        ReuseStation(type: .home, position: CGPoint(x: 500, y: 600))
    ]
    
    // Game state
    @State private var showingSuccess = false
    @State private var showingIdeas = false
    @State private var currentItem: ReuseItem?
    @State private var score = 0
    @State private var itemsReused = 0
    @State private var reuseIdeas: [String] = []
    
    var body: some View {
        ZStack {
            // Background
            Image("Green_Forest_1")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)
            
            // Game area
            GeometryReader { geometry in
                // Draggable items
                ForEach(items) { item in
                    Image(systemName: item.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.orange.opacity(0.7))
                        .cornerRadius(10)
                        .position(item.position)
                        .shadow(radius: 3)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    currentItem = item
                                    if let index = items.firstIndex(where: { $0.id == item.id }) {
                                        items[index].position = value.location
                                    }
                                }
                                .onEnded { value in
                                    checkDropLocation(value.location)
                                }
                        )
                }
                
                // Reuse stations
                ForEach(stations, id: \.type) { station in
                    ReuseStationView(station: station)
                        .position(station.position)
                }
                
                // Score display
                VStack {
                    Text("Reuse It!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 2)
                    
                    Text("Items Reused: \(score)")
                        .font(.title)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 2)
                        .padding()
                    
                    Spacer()
                }
                .frame(width: geometry.size.width)
            }
            
            // Success message with reuse ideas
            if showingSuccess {
                SuccessMessageView(reuseIdeas: reuseIdeas, action: {
                    showingSuccess = false
                    if itemsReused == items.count {
                        resetGame()
                    }
                })
            }
        }
    }
    
    private func checkDropLocation(_ location: CGPoint) {
        guard let currentItem = currentItem else { return }
        
        for station in stations {
            let stationRect = CGRect(x: station.position.x - 50, y: station.position.y - 75, width: 100, height: 150)
            
            if stationRect.contains(location) {
                // Any station is correct for reuse (we're encouraging creative thinking)
                score += 1
                itemsReused += 1
                reuseIdeas = currentItem.reuseOptions
                removeItem(currentItem)
                showingSuccess = true
                return
            }
        }
        
        // Dropped outside any station - return to original position
        resetCurrentItemPosition()
    }
    
    private func removeItem(_ item: ReuseItem) {
        items.removeAll { $0.id == item.id }
    }
    
    private func resetCurrentItemPosition() {
        guard let currentItem = currentItem else { return }
        
        if let index = items.firstIndex(where: { $0.id == currentItem.id }) {
            items[index].position = currentItem.position
        }
    }
    
    private func resetGame() {
        items = [
            ReuseItem(id: 1, name: "Cardboard Box", image: "shippingbox", originalUse: "Shipping", reuseOptions: ["Play House", "Storage Bin", "Art Canvas"], position: CGPoint(x: 50, y: 100)),
            ReuseItem(id: 2, name: "Glass Jar", image: "jar", originalUse: "Food Storage", reuseOptions: ["Pencil Holder", "Vase", "Terrarium"], position: CGPoint(x: 150, y: 100)),
            ReuseItem(id: 3, name: "Old T-Shirt", image: "tshirt", originalUse: "Clothing", reuseOptions: ["Rags", "Tote Bag", "Quilt"], position: CGPoint(x: 250, y: 100)),
            ReuseItem(id: 4, name: "Egg Carton", image: "egg", originalUse: "Holding Eggs", reuseOptions: ["Seed Starter", "Paint Palette", "Organizer"], position: CGPoint(x: 350, y: 100)),
            ReuseItem(id: 5, name: "Plastic Bottle", image: "waterbottle", originalUse: "Drinking", reuseOptions: ["Bird Feeder", "Watering Can", "Piggy Bank"], position: CGPoint(x: 450, y: 100))
        ]
        itemsReused = 0
    }
}

// MARK: - Models and Enums

enum StationType: String, CaseIterable, Identifiable {
    case craft, garden, home
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .craft: return .purple
        case .garden: return .green
        case .home: return .blue
        }
    }
    
    var icon: String {
        switch self {
        case .craft: return "paintpalette"
        case .garden: return "leaf"
        case .home: return "house"
        }
    }
    
    var title: String {
        switch self {
        case .craft: return "Craft Station"
        case .garden: return "Garden Area"
        case .home: return "Home Use"
        }
    }
}

struct ReuseStation {
    let type: StationType
    let position: CGPoint
}

struct ReuseItem: Identifiable {
    let id: Int
    let name: String
    let image: String
    let originalUse: String
    let reuseOptions: [String]
    var position: CGPoint
}

// MARK: - Subviews

struct ReuseStationView: View {
    let station: ReuseStation
    
    var body: some View {
        VStack {
            Image(systemName: station.type.icon)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .padding()
                .background(station.type.color)
                .clipShape(Circle())
            
            Text(station.type.title)
                .font(.headline)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2)
                .frame(width: 100)
                .multilineTextAlignment(.center)
        }
    }
}

struct SuccessMessageView: View {
    let reuseIdeas: [String]
    let action: () -> Void
    
    var body: some View {
        VStack {
            Text("Great Idea!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.green)
                .padding()
            
            Text("You can reuse this for:")
                .font(.title2)
                .foregroundColor(.white)
            
            ForEach(reuseIdeas, id: \.self) { idea in
                Text("• \(idea)")
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 5)
            
            Button(action: action) {
                Text("OK")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .frame(width: 300, height: 300)
        .background(Color.black.opacity(0.8))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

// MARK: - Preview

struct ReuseGameView_Previews: PreviewProvider {
    static var previews: some View {
        ReuseGameView()
    }
}
