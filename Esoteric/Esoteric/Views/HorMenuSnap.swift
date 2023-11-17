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
        cards = [HorMenuSnapCard(title: "Ваш таролог",
                                 subTitle: "Получите расклад таролога",
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
                   Text(card.subTitle).font(.custom("ElMessiri-Regular", size: 19))
                }.foregroundColor(.textColor)

                Button {
                    Haptics.shared.play(.light)
                } label: {
                    HStack {
                        Text("Выбрать").bold().foregroundColor(.white)
                    }
                }.DefButtonStyle()
                
            }.padding()
        }
      

        .frame(width: 260, height: 300)
        .cornerRadius(25)
    }
}


struct HorMenuSnap: View {
    
    let onboardData = HorMenuSnapData()
    
    @State public var activePageIndex: Int = 0
    
    let tilePadding: CGFloat = 25
    let tileWidth: CGFloat = 260

    var body: some View {
        
        
        PagingScrollView(activePageIndex: self.$activePageIndex, tileWidth:self.tileWidth, tilePadding: self.tilePadding){
            ForEach(onboardData.cards) { card in
                GeometryReader { geometry2 in
                    let g = geometry2.frame(in: .global).minX
                    HorMenuSnapCardView(card: card)
                      //  .rotation3DEffect(Angle(degrees: Double((g - self.tileWidth*0.5) / -10 )),
                //                                axis: (x: 2, y: 11, z: 1))
                        .scaleEffect(activePageIndex == onboardData.cards.firstIndex(of: card) ?? 0 ? 1.05 : 1)
                }
            }
        }//.offset(x:-40)

    }
}

struct FrameMeasurePreferenceKey: PreferenceKey {
    typealias Value = [String: CGRect]

    static var defaultValue: Value = Value()

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { current, new in
            new
        }
    }
}

struct MeasureGeometry: View {
    let space: CoordinateSpace
    let identifier: String
    // this dummy view will measure the view and store its width to preference value
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: FrameMeasurePreferenceKey.self, value: [identifier: geometry.frame(in: space)])
        }
    }
}

struct PagingScrollView: View {
    let items: [AnyView]

    public init<Data, id,  Content: View>(activePageIndex:Binding<Int>, tileWidth:CGFloat, tilePadding: CGFloat, @ViewBuilder content: () -> ForEach<Data, id, Content>) {
        let views = content()
        self.items = views.data.map({ AnyView(views.content($0)) })
        
        let itemCount = views.data.count
        
        self._activePageIndex = activePageIndex
        
        self.tileWidth = tileWidth
        self.tilePadding = tilePadding
        self.itemCount = itemCount
    }
      
    /// index of current page 0..N-1
    @Binding var activePageIndex : Int
    
    /// pageWidth==frameWidth used to properly compute offsets
    @State var pageWidth: CGFloat = 0
    
    /// width of item / tile
    let tileWidth : CGFloat
    
    /// padding between items
    private let tilePadding : CGFloat
        
    private let itemCount : Int
    
    /// some damping factor to reduce liveness
    private let scrollDampingFactor: CGFloat = 0.66
    
    /// drag offset during drag gesture
    @State private var dragOffset : CGFloat = 0
    
    
    func offsetForPageIndex(_ index: Int)->CGFloat {
        return -self.baseTileOffset(index: index)
    }
    
    func indexPageForOffset(_ offset : CGFloat) -> Int {
        guard self.itemCount>0 else {
            return 0
        }
        let offset = self.logicalScrollOffset(trueOffset: offset)
        let floatIndex = (offset)/(tileWidth+tilePadding)
        var computedIndex = Int(round(floatIndex))
        computedIndex = max(computedIndex, 0)
        return min(computedIndex, self.itemCount-1)
    }
    
    /// current scroll offset applied on items
    func currentScrollOffset(activePageIndex: Int, dragoffset: CGFloat)->CGFloat {
        return self.offsetForPageIndex(activePageIndex) + dragOffset
    }
    
    /// logical offset startin at 0 for the first item - this makes computing the page index easier
    func logicalScrollOffset(trueOffset: CGFloat)->CGFloat {
        return (trueOffset) * -1.0
    }
    
    private let animation = Animation.interpolatingSpring(mass: 0.1, stiffness: 20, damping: 1.5, initialVelocity: 0)
   
    func baseTileOffset(index: Int) -> CGFloat {
        return CGFloat(index)*(self.tileWidth + self.tilePadding)
    }
    
    var body: some View {
        
            ZStack(alignment: .center)  {
                let globalOffset = self.currentScrollOffset(activePageIndex: self.activePageIndex, dragoffset: self.dragOffset)
                ForEach(0..<self.items.count, id:\.self) { index in
                   
                    self.items[index]
                        .frame(width: self.tileWidth)
                        .offset(x: self.baseTileOffset(index: index) + globalOffset)
                        /*.simultaneousGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        withAnimation(self.animation) {
                                            self.activePageIndex = index
                                            self.dragOffset = 0
                                        }
                                    }
                            )*/
                }
            }
            .background(
                MeasureGeometry(space: .local, identifier: "container")
            )
            .onPreferenceChange(FrameMeasurePreferenceKey.self) {
                guard let frame = $0["container"] else { return }
                self.pageWidth = frame.size.width
            }
            
            .background(Color.black.opacity(0.00001)) // hack - this allows gesture recognizing even when background is transparent
            .simultaneousGesture( DragGesture(minimumDistance: 1, coordinateSpace: .local) // can be changed to simultaneous gesture to work with buttons
                .onChanged { value in
                    self.dragOffset = value.translation.width
                }
                .onEnded { value in
                    // compute nearest index
                    let velocityDiff = (value.predictedEndTranslation.width - self.dragOffset)*self.scrollDampingFactor
                    let targetOffset = self.currentScrollOffset(activePageIndex: self.activePageIndex, dragoffset: self.dragOffset)
                    
                    withAnimation(self.animation){
                        self.dragOffset = 0
                        self.activePageIndex = self.indexPageForOffset(targetOffset+velocityDiff)
                    }
                }
            )
    }
}

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
