import SwiftUI

class CardsTableViewModel: ObservableObject {

    enum DeckType {
        case OneCard, ThreeCards, TarotReader, CardOfTheDay
    }
    
    var gpt = GPTService()
    @Published var text: String = ""
    @Published var isOpenCardsAvalable: Bool = false
    @Published var isGPTloading: Bool = false
    @Published var cards: [Tarot] = []
    @Published var isSelected = false
    @Published var activePageIndex: Int = 0

    var cardsNum: Int
    var selectedCardsNumber: Int = 0
    var selectedCards: [Int: Tarot?] = [:]

    let tilePadding: CGFloat = 45
    let tileWidth: CGFloat = screenWidthPart(2.5)
    let tileHeight: CGFloat = screenPart(3)
    
    @Published var showModalView = false
    let deckType: CardsTableViewModel.DeckType
    
    init(deckType: CardsTableViewModel.DeckType) {
        self.deckType = deckType
        self.cards = tarotDB.shuffled()
        switch deckType {
            case .OneCard:
                self.cardsNum = 1
                for index in 1...cardsNum {
                    selectedCards[index] = nil
                }
            case .ThreeCards:
                self.cardsNum = 3
                for index in 1...cardsNum {
                    selectedCards[index] = nil
                }
            case .TarotReader:
                self.cardsNum = 3
                for index in 1...cardsNum {
                    selectedCards[index] = nil
                }
                select()
                select()
                select()
                activePageIndex = 0
                isSelected = true
            case .CardOfTheDay:
                self.cardsNum = 1
                for index in 1...cardsNum {
                    selectedCards[index] = nil
                }
        }
    }
    
    func openCards() {
        if selectedCardsNumber != cardsNum { return }
        withAnimation {
            isSelected = true
        }
    }
    
    func select() {
        if selectedCardsNumber == cardsNum { return }
        
        let index = (0...76).randomElement()!
        withAnimation {
            let item = self.cards.remove(at: index)
            self.selectedCards[selectedCardsNumber] = item
            activePageIndex = selectedCardsNumber
        }
        
        selectedCardsNumber += 1
        
        if selectedCardsNumber == cardsNum {
            isOpenCardsAvalable = true
        }
    }

    func getTaroInfo() {
        if text.isEmpty == false {
            showModalView = true
            return
        }
        var names: String = ""
        selectedCards.forEach { (key: Int, value: Tarot?) in
            names.append("\(value!.name),")
        }
        if names.isEmpty {
            return
        }
        var promt: String = ""
        
        switch deckType {
                
            case .OneCard:
                if  User.language == "ru" {
                    promt = "мне выпала карта таро \(names). Что эта карта может значить? Ответь в паре предложений."
                } else {
                    promt = "I got the tarot card: \(names).  What does this card mean? Answer in a couple of sentences."
                }
            case .ThreeCards:
                if  User.language == "ru" {
                    promt = "мне выпали карты таро \(names). Что эти карты вместе могут значить? Ответь в паре предложений."
                } else {
                    promt = "I got the few tarot cards from the deck: \(names). What could these cards together mean?"
                }
            case .TarotReader:
                let storage = StorageService.shared
                let key = SavingKeys.question.rawValue
                guard let question = storage.loadQuestion(key: key) else {
                    return
                }
                
                if  User.language == "ru" {
                    promt = """
        Ты - женщина таролог, мистический маг.
        Мой запрос: "\(question)".
        Мне выпали карты таро: \(names).
        Что эти карты вместе могут значить в рамках моего запроса?
        Какой вывод из этого можно сделать?
        """
                } else {
                    promt = """
        You are a female tarologist, a mystical magician.
        My query is "\(question)".
        I got the tarot cards: \(names).
        What can these cards together mean as part of my request?
        What conclusion can be drawn from this?
        """
                }
            case .CardOfTheDay:
                if  User.language == "ru" {
                    promt = "Я гадаю на картах таро. Мне выпала карта дня: \(names). Что эта карта дня может значить? Сделай вывод и рекомендации на день."
                } else {
                    promt = "I'm reading tarot cards. I got the card of the day: \(names). What does this map of the day mean? Make a conclusion and recommendations for the day."
                }
        }
        
     
        self.isGPTloading = true
        
        gpt.test(promt: promt) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let content):
                        DayConterService().copleteThisDay()
                        FreeUsetageService.shared.incrementCounter()
                    if content.isEmpty {
                        self.text = "Туман не рассеялся"
                    } else {
                        self.text = content
                        self.isGPTloading = false
                        self.showModalView = true
                        if self.deckType == .TarotReader {
                            StorageService.shared.clearSavedData()
                        }
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.text = "Туман не рассеялся"
                }
            }
        }
    }
}

struct CardsTableView: View {
    
    @StateObject var model: CardsTableViewModel
    
    var body: some View {
        ZStack {
            TaroDeckBackGroundView()
            
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    
                    VStack(spacing: -10) {
                        switch model.deckType {
                                
                            case .OneCard:
                            H1TitleView(textColor: .accentColor,text: Texts.HomeView.oneCard, alignment: .center)
                                if model.isOpenCardsAvalable == false {
                                    ArticleView(text: Texts.CardsTableView.chooseOneCard, alignment: .leading).opacity(0.6)
                                } else {
                                    ArticleView(text: Texts.CardsTableView.tapToOpen, alignment: .leading)
                                }
                                
                            case .ThreeCards:
                                H1TitleView(textColor: .accentColor,text: Texts.HomeView.threeCard, alignment: .center)
                                if model.isOpenCardsAvalable == false {
                                    ArticleView(text: Texts.CardsTableView.chooseThreeCard, alignment: .leading).opacity(0.6)
                                } else {
                                    ArticleView(text: Texts.CardsTableView.tapToOpen, alignment: .leading)
                                }
                            case .TarotReader:
                                H1TitleView(textColor: .accentColor,text: Texts.CardsTableView.yourTarotSpread, alignment: .center)
                                if model.isOpenCardsAvalable == false {
                                    ArticleView(text: Texts.CardsTableView.personalTarotReading, alignment: .leading).opacity(0.6)
                                } else {
                                    ArticleView(text: Texts.CardsTableView.tapToOpen, alignment: .leading)
                                }
                            case .CardOfTheDay:
                            H1TitleView(textColor: .accentColor,text: Texts.HomeView.cardOfDay, alignment: .center)
                                if model.isOpenCardsAvalable == false {
                                    ArticleView(text: Texts.CardsTableView.spaceRequest, alignment: .leading).opacity(0.6)
                                } else {
                                    ArticleView(text: Texts.CardsTableView.tapToOpen, alignment: .leading)
                                }
                        }
                        
                    }
                    
                }
                Spacer()
                ZStack {
                   
                    PagingScrollView(activePageIndex  : $model.activePageIndex,
                                     tileWidth        : model.tileWidth,
                                     tilePadding      : model.tilePadding) {
                        
                        ForEach(model.selectedCards.map({
                            return $1!
                        })) { card in
                            CardFlipHero(isSelected: $model.isSelected,
                                         text: card.image)
                            .onTapGesture {
                                Haptics.shared.play(.heavy)
                                    model.openCards()
                                
                            }
                            .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                        }
                        
                    }
                    
                } .frame(height: model.tileHeight)
                    .offset(y:-20)
                
                
                if model.isSelected == false {
                    VStack() {
                        ChooseYourCardArtView()
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: -20) {
                                ForEach(model.cards, id: \.id) { card in
                                 
                                        FakeCardView()
                                            .onTapGesture {
                                                model.select()
                                                Haptics.shared.play(.heavy)
                                            }
                                            
                                    
                                }
                            }.frame(height: screenPart(4.2))
                        }.frame(height: screenPart(7.2)).scrollIndicators(.hidden)
                        SwipeCardsCardArtView()
                    }
                } else {
                    VStack {
                        Image("art_delimiter8").resizable().aspectRatio(contentMode: .fit).frame(height: 6)
                        ZStack{
                            Button(action: {
                                model.getTaroInfo()
                            }, label: {
                                Text("Открыть предсказание")
                            }).DefButtonStyle()
                            
                        }
                        Image("art_delimiter8").resizable().aspectRatio(contentMode: .fit).frame(height: 6)
                    }.frame(height: screenPart(4))
                }
                Spacer()
            }
            if model.isGPTloading {
                LoadingIndicator().transition(.opacity)
            }
        }

        .sheet(isPresented: $model.showModalView, content: {
            ScrollView(.vertical, content: {
                VStack(alignment: .center) {
                                        
                    ForEach((model.selectedCards.map({ (key: Int, value: Tarot?) in
                        return value
                    }) as! [Tarot]), id: \.id) { card in
                        ShineTitleView(text: card.name, alignment: .center)
                    }
                    
                    Image("art_delimiter2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 15)
                        .offset(y:-10)
                    
                    
                    ArticleView(text: model.text)
                    
                }.padding(.horizontal, 40).padding(.vertical, 50)
            })
            .presentationBackground(alignment: .bottom) {
                TarotReaderBackGroundView()
            }
            .presentationCornerRadius(5)
            .presentationDetents([.medium, .large])
        }).onAppear(perform: {
            if model.deckType == .TarotReader {
                UIApplication.shared.applicationIconBadgeNumber = 0
                
            }
        })
    }
}


#Preview {
    NavigationStack {
        CardsTableView(model: CardsTableViewModel(deckType: .ThreeCards))
    }.preferredColorScheme(.dark)
}
