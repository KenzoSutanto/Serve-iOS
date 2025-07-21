import SwiftUI


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


struct ReuseGameView: View {
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
            let topStations: [ReuseStation] = [
                .init(type: .craft, position: CGPoint(x: margin, y: margin)),
                .init(type: .garden, position: CGPoint(x: size.width - margin, y: margin))
            ]

            ZStack {
                Image("Green_Forest_1")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                ForEach(topStations) { station in
                    StationView(station: station)
                }


                ZStack {
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.red, .orange]),
                              startPoint: .top, endPoint: .bottom))
                        .opacity(0.6)
                        .frame(width: size.width/2, height: zoneHeight)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 5, x: 0, y: 3)
                        
                        Text("TRASH")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.7), radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(LinearGradient(gradient: Gradient(colors: [.red, .orange]),
                                          startPoint: .leading, endPoint: .trailing))
                                    .shadow(radius: 5)
                            )
                    }
                }
                .position(x: binZone.midX, y: binZone.midY - 10)

                ZStack {
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                              startPoint: .top, endPoint: .bottom))
                        .opacity(0.6)
                        .frame(width: size.width/2, height: zoneHeight)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 5, x: 0, y: 3)
                        
                        Text("REUSE")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.7), radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                          startPoint: .leading, endPoint: .trailing))
                                    .shadow(radius: 5)
                            )
                    }
                }
                .position(x: homeZone.midX, y: homeZone.midY - 10)
                // Draggable items
                ForEach(items) { item in
                    ItemView(item: item, name: item.name)
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
                
                VStack {
                    Text("Score: \(score)")
                        .font(.title).bold().padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                    Spacer()
                }

                if showSuccess {
                    FeedbackPopup(title: "Great Job!", message: "You reused/disposed of this item!", pointsMessage: "You can reuse this for:", points: reuseIdeas, color: .green) {
                        showSuccess = false
                    }
                    .position(x: size.width / 2, y: size.height / 2)
                }
                
                if showFailure {
                    FeedbackPopup(title: "Oh no!", message: "Try again!", pointsMessage: "", points: [], color: .red) {
                        showFailure = false
                    }
                    .position(x: size.width / 2, y: size.height / 2)
                }
                
                if showCannotReuse {
                    FeedbackPopup(title: "Can't Reuse!", message: "You can't reuse \(currentItemName). Put it in the bin!", pointsMessage: "", points: [], color: .orange) {
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

    private func handleDrop(at point: CGPoint, in size: CGSize, binZone: CGRect, homeZone: CGRect, topStations: [ReuseStation], item: ReuseItem) {
        let zoneHeight = size.height * 0.2
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }

        if binZone.contains(point) {
            if !item.isReusable {
                score += 1
                items.remove(at: idx)
                showSuccess = true
                reuseIdeas = []
            } else {
                showCannotReuse = true
                currentItemName = item.name
                score -= 1
            }
        }
        else if homeZone.contains(point) {
            if item.isReusable {
                showSuccess = true
                reuseIdeas = item.reuseOptions ?? []
                score += 1
                items.remove(at: idx)
            } else {
                showCannotReuse = true
                currentItemName = item.name
                score -= 1
            }
        }
        else {
            for station in topStations {
                let rect = CGRect(x: station.position.x - 40,
                                 y: station.position.y - 40,
                                 width: 80, height: 80)
                if rect.contains(point) {
                    if item.isReusable {
                        showSuccess = true
                        reuseIdeas = item.reuseOptions ?? []
                        score += 1
                        items.remove(at: idx)
                    } else {
                        showCannotReuse = true
                        currentItemName = item.name
                        score -= 1
                    }
                    return
                }
            }

            let maxY = size.height - zoneHeight - margin
            items[idx].position = CGPoint(
                x: CGFloat.random(in: margin...(size.width - margin)),
                y: CGFloat.random(in: margin...maxY)
            )
        }
    }
}


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
    let name: String
    var body: some View {
        VStack {
            Image(systemName: item.image)
                .resizable().scaledToFit()
                .frame(width: 80, height: 80)
                .padding(10)
                .background(item.isReusable ? Color.orange.opacity(0.7) : Color.gray.opacity(0.7))
                .cornerRadius(10)
                .shadow(radius: 3)
            
            Text(name)
                .font(.system(size: 32, weight: .black))
                .foregroundColor(.black)
            
        }
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
                
                ForEach(points, id: \ .self) { idea in
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


struct ReuseGameView_Previews: PreviewProvider {
    static var previews: some View {
        ReuseGameView()
    }
}

