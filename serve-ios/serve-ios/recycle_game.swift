//
//  recycle_game.swift
//  serve-ios
//
//  Created by Kenzo on 16/7/25.
//

import SwiftUI

enum RecycleType: String, CaseIterable {
    case paper, plastic, glass, metal
}

struct RecycleItem: Identifiable, Equatable {
    let id: Int
    let name: String
    let image: String
    let type: RecycleType
    let recycleTips: [String]
    var offset: CGSize = .zero
    var dragOffset: CGSize = .zero
    
    static let initialList: [RecycleItem] = [
        .init(id: 1, name: "Carboard Box", image: "shippingbox", type: .paper, recycleTips: ["Make sure the box is clean"]),
        .init(id: 2, name: "Used Paper", image: "document.on.document", type: .paper, recycleTips: ["Make sure the paper is clean"]),
        .init(id: 3, name: "Glass Bottle", image: "wineglass", type: .glass, recycleTips: ["Clean the bottle thoroughly", "Dry it completely"]),
        .init(id: 4, name: "Plastic Bottle", image: "waterbottle", type: .plastic, recycleTips: ["Clean the bottle thoroughly", "Dry it completely"]),
        .init(id: 5, name: "Aluminium Can", image: "cylinder", type: .metal, recycleTips: ["Clean the can thoroughly", "Dry it completely"])
    ]
}


struct recycle_game: View {
    
    @State var items: [RecycleItem] = RecycleItem.initialList
    
    private let margin: CGFloat = 50
    
    @State private var showSuccess = false
    @State private var showFailure = false
    @State private var showCannotReuse = false
    @State private var recycleTips:[String] = []
    
    var body: some View {
        GeometryReader{ geo in
            let size = geo.size
            
            let binWidth: CGFloat = size.width/4
            let binHeight: CGFloat = size.height*0.2
            let startX: CGFloat = 0
            let binY = size.height - binHeight
            
            let binRects: [RecycleType: CGRect] = [
                .paper: CGRect(x: startX, y: binY, width: binWidth, height: binHeight),
                .plastic: CGRect(x: startX + (binWidth), y: binY, width: binWidth, height: binHeight),
                .glass: CGRect(x: startX + 2 * (binWidth), y: binY, width: binWidth, height: binHeight),
                .metal: CGRect(x: startX + 3 * (binWidth), y: binY, width: binWidth, height: binHeight)
            ]
            
            
            ZStack{
                Rectangle()
                    .fill(Color.green)
                    .overlay(
                        Image("Green_Forest_1")
                            .resizable()
                            .scaledToFill()
                    )
                    .ignoresSafeArea()
                    .frame(width: geo.size.width, height: geo.size.height)
                
                
                ForEach(RecycleType.allCases, id: \.self) { type in
                    if let rect = binRects[type] {
                        ZStack {
                            
                            Rectangle()
                                .fill(binColor(for: type).opacity(0.6))
                                .frame(width: rect.width, height: rect.height)
                                .position(x: rect.midX, y: rect.midY)
                            
                            VStack(spacing: 10) {
                                Image(systemName: type == .paper ? "doc.fill" :
                                     type == .plastic ? "waterbottle.fill" :
                                     type == .glass ? "wineglass.fill" : "tray.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 3, x: 0, y: 2)
                                
                                Text(type.rawValue.uppercased())
                                    .font(.system(size: 28, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.7), radius: 4, x: 0, y: 2)
                                    .padding(8)
                                    .background(
                                        Capsule()
                                            .fill(binColor(for: type).opacity(0.9))
                                            .shadow(radius: 5)
                                    )
                            }
                            .position(x: rect.midX, y: rect.midY - 20)
                        }
                    }
                }
                
                
                ForEach(items) { item in
                    VStack {
                        Image(systemName: item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(10)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                        
                        Text(item.name)
                            .font(.system(size: 32, weight: .black))
                            .foregroundColor(.black)
                    }
                    .position(x: item.offset.width + item.dragOffset.width,
                             y: item.offset.height + item.dragOffset.height)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if let indx = items.firstIndex(of: item) {
                                    items[indx].dragOffset = value.translation
                                }
                            }
                            .onEnded { value in
                                if let indx = items.firstIndex(of: item) {
                                    items[indx].offset.width += value.translation.width
                                    items[indx].offset.height += value.translation.height
                                    items[indx].dragOffset = .zero
                                    handleDrop(indx: indx, at: value.location, size: geo.size, binRects: binRects)
                                }
                            }
                    )
                }
                .onAppear {
                    let maxY = size.height - binHeight - margin
                    let maxX = size.width - margin
                    for i in items.indices {
                        items[i].offset = CGSize(width: CGFloat.random(in: margin...maxX),
                                               height: CGFloat.random(in: margin...maxY))
                    }
                }
                if showSuccess {
                    FeedbackPopup(title: "Great Job!", message: "You recycled this item!", pointsMessage: "Before Recycling:", points: recycleTips, color: .green) {
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
            }
        }
    }
    

    
    private func handleDrop(indx: Int, at point: CGPoint, size: CGSize, binRects: [RecycleType:CGRect]){
        
        for type in RecycleType.allCases{
            if let rect = binRects[type]{
                if rect.contains(point){
                    if items[indx].type == type{
                        showSuccess = true
                        recycleTips = items[indx].recycleTips
                        items.remove(at: indx)
                    }
                    else{
                        showFailure = true
                        let maxY = size.height - size.height*0.2 - margin
                        let maxX = size.width - margin
                        items[indx].offset = CGSize(width: CGFloat.random(in: margin...maxX), height: CGFloat.random(in: margin...maxY))
                    }
                    return
                }
            }
        }
    }
    
    
    private func binColor(for type: RecycleType) -> Color {
        switch type {
            case .paper: return .blue
            case .plastic: return .yellow
            case .glass: return .green
            case .metal: return .gray
        }
    }
    
}

#Preview {
    recycle_game()
}
