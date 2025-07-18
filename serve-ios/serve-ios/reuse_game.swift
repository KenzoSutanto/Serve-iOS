import SwiftUI

// MARK: - Models

enum StationType: String, CaseIterable, Identifiable {
    case craft, garden, home
    var id: String { rawValue }
    var color: Color {
        switch self {
        case .craft: return .purple
        case .garden: return .green
        case .home: return .blue
        }
    }
    var iconName: String {
        switch self {
        case .craft: return "paintpalette"
        case .garden: return "leaf"
        case .home: return "house"
        }
    }
}

struct ReuseStation: Identifiable {
    let id = UUID()
    let type: StationType
    let position: CGPoint
}

struct ReuseItem: Identifiable, Equatable {
    let id: Int
    let name: String
    let image: String
    let isReusable: Bool
    let reuseOptions: [String]?
    var position: CGPoint = .zero

    static let initialList: [ReuseItem] = [
        // reusables
        .init(id: 1, name: "Cardboard Box", image: "shippingbox", isReusable: true, reuseOptions: ["Play House","Storage Bin","Art Canvas"]),
        .init(id: 2, name: "Glass Jar", image: "jar", isReusable: true, reuseOptions: ["Pencil Holder","Vase","Terrarium"]),
        .init(id: 3, name: "Old T-Shirt", image: "tshirt", isReusable: true, reuseOptions: ["Rags","Tote Bag","Quilt"]),
        .init(id: 4, name: "Egg Carton", image: "cube.box.fill", isReusable: true, reuseOptions: ["Seed Starter","Paint Palette","Organizer"]),
        .init(id: 5, name: "Plastic Bottle", image: "drop.fill", isReusable: true, reuseOptions: ["Bird Feeder","Watering Can","Piggy Bank"]),
        .init(id: 6, name: "Newspaper", image: "newspaper.fill", isReusable: true, reuseOptions: ["Gift Wrap","Paper Mache","Compost"]),
        .init(id: 7, name: "Tin Can", image: "music.note", isReusable: true, reuseOptions: ["Wind Chime","Pencil Holder","Plant Pot"]),
        .init(id: 8, name: "Wine Cork", image: "pin.fill", isReusable: true, reuseOptions: ["Bulletin Board","Craft Stamps","Mini Figures"]),
        // non-reusables
        .init(id: 9, name: "Banana Peel", image: "leaf.fill", isReusable: false, reuseOptions: nil),
        .init(id: 10, name: "Broken Glass", image: "flame.fill", isReusable: false, reuseOptions: nil)
    ]
}

// MARK: - Main Game View

struct FinalReuseGameView: View {
    @State private var items = ReuseItem.initialList
    @State private var score = 0
    @State private var showSuccess = false
    @State private var showFailure = false
    @State private var showCannotReuse = false
    @State private var reuseIdeas: [String] = []
    @State private var currentItemName = ""
    private let margin: CGFloat = 50

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let zoneHeight = size.height * 0.2
            let binZone = CGRect(x: 0, y: size.height - zoneHeight, width: size.width / 2, height: zoneHeight)
            let homeZone = CGRect(x: size.width / 2, y: size.height - zoneHeight, width: size.width / 2, height: zoneHeight)
            let binPos = CGPoint(x: binZone.midX, y: binZone.midY)
            let homePos = CGPoint(x: homeZone.midX, y: homeZone.midY)
            let topStations: [ReuseStation] = [
                .init(type: .craft, position: CGPoint(x: margin, y: margin)),
                .init(type: .garden, position: CGPoint(x: size.width - margin, y: margin))
            ]

            ZStack {
                // Background Image
                Image("Green_Forest_1")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                // Top stations
                ForEach(topStations) { station in
                    StationView(station: station)
                }

                // Bottom zones
                Rectangle()
                    .fill(Color.red.opacity(0.3))
                    .frame(width: size.width/2, height: zoneHeight)
                    .position(x: binZone.midX, y: binZone.midY)
                Rectangle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: size.width/2, height: zoneHeight)
                    .position(x: homeZone.midX, y: homeZone.midY)

                // Bin & home icons
                Image(systemName: "trash.fill")
                    .font(.system(size: 40)).foregroundColor(.white)
                    .position(binPos)
                Image(systemName: StationType.home.iconName)
                    .font(.system(size: 40)).foregroundColor(.white)
                    .position(homePos)

                // Draggable items
                ForEach(items) { item in
                    ItemView(item: item)
                        .position(item.position)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let x = min(max(margin, value.location.x), size.width - margin)
                                    let y = min(max(margin, value.location.y), size.height - margin)
                                    if let idx = items.firstIndex(of: item) {
                                        items[idx].position = CGPoint(x: x, y: y)
                                    }
                                }
                                .onEnded { value in
                                    handleDrop(at: value.location, in: size, binZone: binZone, homeZone: homeZone, topStations: topStations, item: item)
                                }
                        )
                }

                // Score
                VStack {
                    Text("Score: \(score)")
                        .font(.title).bold().padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                    Spacer()
                }

                // Centered Popups
                if showSuccess {
                    FeedbackPopup(title: "Great Job!", message: "You reused this item!", pointsMessage: "You can reuse this for:", points: reuseIdeas, color: .green) {
                        showSuccess = false
                    }
                    .position(x: size.width / 2, y: size.height / 2)
                }
                
                if showFailure {
                    FeedbackPopup(title: "Oh no!", message: "Try again!", pointsMessage: "You can reuse this for:", points: [], color: .red) {
                        showFailure = false
                    }
                    .position(x: size.width / 2, y: size.height / 2)
                }
                
                if showCannotReuse {
                    FeedbackPopup(title: "Can't Reuse!", message: "You can't reuse \(currentItemName). Put it in the bin!", pointsMessage: "You can reuse this for:", points: [], color: .orange) {
                        showCannotReuse = false
                    }
                    .position(x: size.width / 2, y: size.height / 2)
                }
            }
            .onAppear {
                let maxY = size.height - zoneHeight - margin
                for idx in items.indices {
                    let x = CGFloat.random(in: margin...(size.width - margin))
                    let y = CGFloat.random(in: margin...maxY)
                    items[idx].position = CGPoint(x: x, y: y)
                }
            }
        }
    }

    // MARK: - Drop Logic
    private func handleDrop(at point: CGPoint, in size: CGSize, binZone: CGRect, homeZone: CGRect, topStations: [ReuseStation], item: ReuseItem) {
        let zoneHeight = size.height * 0.2
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }

        if binZone.contains(point) {
            if !item.isReusable {
                // Correctly put non-reusable in bin
                score += 1
                items.remove(at: idx)
                showSuccess = true
                reuseIdeas = []
            } else {
                // Incorrectly put reusable in bin
                showCannotReuse = true
                currentItemName = item.name
                score -= 1
            }
        }
        else if homeZone.contains(point) {
            if item.isReusable {
                // Correctly reused item
                showSuccess = true
                reuseIdeas = item.reuseOptions ?? []
                score += 1
                items.remove(at: idx)
            } else {
                // Incorrectly tried to reuse non-reusable
                showCannotReuse = true
                currentItemName = item.name
                score -= 1
            }
        }
        else {
            // Check if dropped on craft/garden stations
            for station in topStations {
                let rect = CGRect(x: station.position.x - 40,
                                 y: station.position.y - 40,
                                 width: 80, height: 80)
                if rect.contains(point) {
                    if item.isReusable {
                        // Correctly reused at station
                        showSuccess = true
                        reuseIdeas = item.reuseOptions ?? []
                        score += 1
                        items.remove(at: idx)
                    } else {
                        // Incorrectly tried to reuse non-reusable
                        showCannotReuse = true
                        currentItemName = item.name
                        score -= 1
                    }
                    return
                }
            }
            
            // Reset if no valid drop
            let maxY = size.height - zoneHeight - margin
            items[idx].position = CGPoint(
                x: CGFloat.random(in: margin...(size.width - margin)),
                y: CGFloat.random(in: margin...maxY)
            )
        }
    }
}

// MARK: - Subviews

struct StationView: View {
    let station: ReuseStation
    var body: some View {
        Image(systemName: station.type.iconName)
            .font(.system(size: 40))
            .foregroundColor(station.type.color)
            .position(station.position)
    }
}

struct ItemView: View {
    let item: ReuseItem
    var body: some View {
        Image(systemName: item.image)
            .resizable().scaledToFit()
            .frame(width: 80, height: 80)
            .padding(10)
            .background(item.isReusable ? Color.orange.opacity(0.7) : Color.gray.opacity(0.7))
            .cornerRadius(10)
            .shadow(radius: 3)
    }
}

struct FeedbackPopup: View {
    let title: String
    let message: String
    let pointsMessage: String?
    let points: [String]
    let color: Color
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            
            Text(message)
                .font(.title2)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            if !points.isEmpty {
                Text(pointsMessage ?? "")
                    .font(.headline)
                    .foregroundColor(.white)
                
                ForEach(points, id: \.self) { idea in
                    Text("• \(idea)")
                        .foregroundColor(.white)
                }
            }
            
            Button(action: action) {
                Text("OK")
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(color)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)

        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(width: 300)
    }
}

// MARK: - Preview

struct FinalReuseGameView_Previews: PreviewProvider {
    static var previews: some View {
        FinalReuseGameView()
    }
}
