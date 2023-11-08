//
//  HorMenuSnap.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 08.11.2023.
//

import SwiftUI

struct HorMenuSnapCard: Codable, Identifiable, Equatable {

    var id: UUID = UUID()
    var title: String
    var subTitle: String
    var image: String
    var colorHex: String
}

class HorMenuSnapData: ObservableObject {
    
    let cards: [HorMenuSnapCard]
    
    var primary: HorMenuSnapCard {
        cards.first!
    }
    
    init() {
        cards = [HorMenuSnapCard(title: "Start",
                                 subTitle: "Contained no UIScene configuration dictionary",
                                 image: "art1",
                                 colorHex: "202628"), // green
                 HorMenuSnapCard(title: "Timer",
                                 subTitle: "Your experience with AVPlayer has been, from the beginning, a love/hate thing, hasn’t it?",
                                 image: "art2",
                                 colorHex: "202628"), // red
                 HorMenuSnapCard(title: "Think",
                                 subTitle: "Maybe you’ve reached a point in your experience with AVPlayer that demanded you to fade in.",
                                 image: "art3",
                                 colorHex: "202628")] // blue
    }
}

struct HorMenuSnapCardView: View {
    
    var card: HorMenuSnapCard
    
    var body: some View {

        ZStack(alignment: .leading) {
            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 260, height: 300)
            
            LinearGradient(gradient: Gradient(colors: [
                Color(uiColor: UIColor(hex: card.colorHex)!),
                Color(uiColor: UIColor(hex: card.colorHex)!).opacity(0.9),
                Color(uiColor: UIColor(hex: card.colorHex)!).opacity(0)
            ]), startPoint: .bottomLeading, endPoint: .topTrailing)
            
            VStack(alignment: .leading, spacing: 30) {
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                   Text(card.title).font(.custom("ElMessiri-Bold", size: 35))
                   Text(card.subTitle).font(.custom("ElMessiri-Regular", size: 14))
                }.foregroundColor(.textColor)

                Button {
                    Haptics.shared.play(.light)
                } label: {
                    HStack {
                        Text("Гадать").bold().foregroundColor(.white)
                    }
                }.frame(height: 20).DefButtonStyle()
            }.padding(20)
        }

        .frame(width: 260, height: 300)
        .cornerRadius(25)
    }
}


struct HorMenuSnap: View {
    
    let onboardData = HorMenuSnapData()
    
    @State private var scrollEffectValue: Double = 13
    @State public var activePageIndex: Int = 0
    
    let itemWidth: CGFloat = 260
    let itemPadding: CGFloat = 20
    
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 25) {
           
                GeometryReader { geometry in
                    AdaptivePagingScrollView(currentPageIndex: self.$activePageIndex,
                                             itemsAmount: self.onboardData.cards.count - 1,
                                             itemWidth: self.itemWidth,
                                             itemPadding: self.itemPadding,
                                             pageWidth: geometry.size.width) {
                        ForEach(onboardData.cards) { card in
                            GeometryReader { screen in
                                HorMenuSnapCardView(card: card)
                                   
                                    .scaleEffect(activePageIndex == onboardData.cards.firstIndex(of: card) ?? 0 ? 1.05 : 1)
                            }
                        }
                    }
                }
                
                Spacer()

            }.offset(x:-43)
        }.background(Color.clear)
    }
}

struct AdaptivePagingScrollView: View {
    
    private let items: [AnyView]
    private let itemPadding: CGFloat
    private let itemSpacing: CGFloat
    private let itemWidth: CGFloat
    private let itemsAmount: Int
    private let contentWidth: CGFloat
    
    private let leadingOffset: CGFloat
    private let scrollDampingFactor: CGFloat = 0.66
    
    @Binding var currentPageIndex: Int
    
    @State private var currentScrollOffset: CGFloat = 0
    @State private var gestureDragOffset: CGFloat = 0
        
    private func countOffset(for pageIndex: Int) -> CGFloat {
        
        let activePageOffset = CGFloat(pageIndex) * (itemWidth + itemPadding)
        return leadingOffset - activePageOffset
    }
    
    private func countPageIndex(for offset: CGFloat) -> Int {
        
        guard itemsAmount > 0 else { return 0 }
        
        let offset = countLogicalOffset(offset)
        let floatIndex = (offset)/(itemWidth + itemPadding)
        
        var index = Int(round(floatIndex))
        if max(index, 0) > itemsAmount {
            index = itemsAmount
        }
        
        return min(max(index, 0), itemsAmount - 1)
    }
    
    private func countCurrentScrollOffset() -> CGFloat {
        return countOffset(for: currentPageIndex) + gestureDragOffset
    }
    
    private func countLogicalOffset(_ trueOffset: CGFloat) -> CGFloat {
        return (trueOffset-leadingOffset) * -1.0
    }
    
    init<A: View>(currentPageIndex: Binding<Int>,
                  itemsAmount: Int,
                  itemWidth: CGFloat,
                  itemPadding: CGFloat,
                  pageWidth: CGFloat,
                  @ViewBuilder content: () -> A) {
        
        let views = content()
        self.items = [AnyView(views)]
        
        self._currentPageIndex = currentPageIndex
         
        self.itemsAmount = itemsAmount
        self.itemSpacing = itemPadding
        self.itemWidth = itemWidth
        self.itemPadding = itemPadding
        self.contentWidth = (itemWidth+itemPadding)*CGFloat(itemsAmount)
        
        let itemRemain = (pageWidth-itemWidth-2*itemPadding)/2
        self.leadingOffset = itemRemain + itemPadding
    }
    
    
    var body: some View {
        GeometryReader { viewGeometry in
            HStack(alignment: .center, spacing: itemSpacing) {
                ForEach(items.indices, id: \.self) { itemIndex in
                    items[itemIndex].frame(width: itemWidth)
                }
            }
        }
        .onAppear {
            currentScrollOffset = countOffset(for: currentPageIndex)
        }
        .background(Color.black.opacity(0.00001)) // hack - this allows gesture recognizing even when background is transparent
        .frame(width: contentWidth)
        .offset(x: self.currentScrollOffset, y: 0)
        .simultaneousGesture(
            DragGesture(minimumDistance: 1, coordinateSpace: .local)
                .onChanged { value in
                    gestureDragOffset = value.translation.width
                    currentScrollOffset = countCurrentScrollOffset()
                }
                .onEnded { value in
                    let cleanOffset = (value.predictedEndTranslation.width - gestureDragOffset)
                    let velocityDiff = cleanOffset * scrollDampingFactor
                    
                    var newPageIndex = countPageIndex(for: currentScrollOffset + velocityDiff)
                    
                    let currentItemOffset = CGFloat(currentPageIndex) * (itemWidth + itemPadding)
                    
                    if currentScrollOffset < -(currentItemOffset),
                       newPageIndex == currentPageIndex {
                        newPageIndex += 1
                    }
                    
                    gestureDragOffset = 0
                    
                    withAnimation(.interpolatingSpring(mass: 0.1,
                                                       stiffness: 20,
                                                       damping: 1.5,
                                                       initialVelocity: 0)) {
                        self.currentPageIndex = newPageIndex
                        self.currentScrollOffset = self.countCurrentScrollOffset()
                    }
                }
        )
    }
}

import UIKit

class Haptics {
    static let shared = Haptics()
    
    private init() { }

    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}


#Preview {
    HorMenuSnap()
}
