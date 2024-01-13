//
//  ChatHome.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 07.01.2024.
//

import SwiftUI

class HomeViews { }

extension HomeViews {
    struct MenuItem: View {
        
        var text: String = "test"
        var subtext: String = "empty"
        var icon: String = "icloud.square.fill"
        
        var body: some View {
            VStack(alignment:.leading,spacing: 15, content: {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20, alignment: .center)
                    .offset(x:5)
                VStack(alignment:.leading, content: {
                    Text(text)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    Text(subtext)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)

                })
            }).padding(.horizontal,20)
            .padding(.vertical,20)
                .background(Color(uiColor: UIColor(hex: "2D2E38")!))
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .circular))
            
        }
    }
}

extension HomeViews {
    struct TextInputItem: View {
        
        @State private var username: String = ""
        @FocusState var focus: FocusElement?
        
        var onSubmit : (String)->()
        
        var body: some View {
            VStack(alignment:.leading,spacing: 20, content: {
                TextField("Ask your question", text: $username)
                .focused($focus, equals: .name)
            }).onSubmit {
                onSubmit(username)
                username = ""
            }
            .padding(.horizontal,20)
            .padding(.vertical,20)
            .background(Color(uiColor: UIColor(hex: "2D2E38")!))
            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .circular))
            
        }
    }
}

extension HomeViews {
    struct ChatTextItem: View {
        var text: String = "test"
        var body: some View {
            Text(text)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal,20)
                .padding(.vertical,10)
        }
    }
}

extension HomeViews {
    struct ChatVariantItem: View {
        var text: String = "test"
        var body: some View {
            Text(text)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal,20)
                .padding(.vertical,10)
                .padding(10)
                .background(.white.opacity(0.1))
                .cornerRadius(20)
                .padding(10)
        }
    }
}

extension HomeViews {
    struct ChatTitleItem: View {
        var text: String = "test"
        var body: some View {
            Text(text)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal,20)
                .padding(.vertical,10)
        }
    }
}

extension HomeViews {
    struct ChatErrorItem: View {
        var text: String = "test"
        var body: some View {
            Text(text)
                .foregroundStyle(Color.red.opacity(0.5))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal,20)
                .padding(.vertical,10)
        }
    }
}

extension HomeViews {
    struct CalendarDayItem: View {
        var text: String
        var body: some View {
            VStack(spacing:1) {
                Text("jun").font(.system(size: 8)).italic()
                Text(text).bold()
                Circle().frame(width: 4, height: 4).background(.white).cornerRadius(2)
            }.frame(maxWidth: .infinity)
        }
    }
}

extension HomeViews {
    struct TypingIndicatorView: View {
        let dotSize: CGFloat = 6
        let animationDuration = 0.6
        let delayBetweenDots = 0.2

        @State private var activeDotIndex = 0
        @State private var timer: Timer?
        
        var body: some View {
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .frame(width: dotSize, height: dotSize)
                        .foregroundColor(activeDotIndex == index ? .white : .gray)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal,20)
                .padding(.vertical,10)
                .onAppear {
                    timer =  Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
                        withAnimation {
                            activeDotIndex = (activeDotIndex + 1) % 3
                        }
                    }
                }
                .onDisappear {
                    timer?.invalidate()
                    timer = nil
                }
        }
    }
    
  
}

struct MessageViewModel: Identifiable, Hashable {
    enum ViewType {
        case Title
        case Article
        case Variant
        case QuizVariant
        case Loading
        case Error
    }
    var id = UUID()
    var data: String
    var type: ViewType
}

class ChatHomeModel: ObservableObject {
    
    @Published var messages: [MessageViewModel] = [.init(data: "Привет, Денис!", type: .Title),
                                                   .init(data: "Начнем?", type: .Title),
                                                   .init(data: "Не забудь пройти дневную терапию.", type: .Article)]
    @Published var loading: Bool = false
    
    @Published var diaryMode: Bool = false
    @Published var diaryStep: Int = 0
    
    var gpt = GPTService()
    
    init() {
     
    }
    
    func nextEmoDiaryStep() {
        switch diaryStep {
            case 0:
                self.clearChat()
                diaryMode = true
                messages.append(.init(data: "Начнем заполнять дневник!", type: .Title))
                messages.append(.init(data: "Пиши ответы на вопросы используя поле для вообда текста внизу", type: .Article))
                messages.append(.init(data: "Достаточно ли я зарабатываю?", type: .Title))
            case 1:
                messages.append(.init(data: "Есть ли у меня установка на рост?", type: .Title))
            case 2:
                messages.append(.init(data: "На сколько я здоров?", type: .Title))
            case 3:
                diaryMode = false
                diaryStep = 0
                messages.append(.init(data: "Все готово!", type: .Title))
            default:
                print("")
        }
    }
    
    
    func randomTarotCard() {
        appendLoading()
        let randomcard = tarotDBEN.randomElement()!.name
        let promt = "мне выпала карта таро \"\(randomcard)\" обьясни ее значение в двух предложениях."
        let format = TarotCardResponse.format()
        gpt.ask(promt: promt, format: format) { result in
            withAnimation {
                switch result {
                    case .success(let str):
                        if let tarot = str["cardDescription"] as? String {
                            self.messages.append(.init(data: tarot, type: .Article))
                        } else {
                            self.appendError()
                        }
                    case .failure(let err):
                        self.appendError(err.localizedDescription)
                }
            }
            self.removeLoading()
        }
    }
    
    var _lastGeneratedSituation: String = ""
    
    func dailytest() {
        clearChat()
        appendLoading()

        let text = "Напиши вымышленную ситуацию для проверки психологического состояния пользователя, в которой пользователью придется себя представить и как-то поступить. Это должна быть сложная и провокационная с точки зрения психилогии ситуация. Так же напиши от 3х до 5ти вариантов того, как бы пользователь мог бы поступить в этой ситуации. Позже мы будем анализировать выбор варианта пользователя. Это все нужно что бы учится контролировать свои эмоции. Текст ситуации запиши в поле \"generatedSituation\", а варианты запиши в массив \"variants\"."
     
        let promt = [GPTService.Message.lang(User.language),
                     GPTService.Message.json(format: SituationResponse.format()),
                     GPTService.Message(.user, text),
                     GPTService.Message(.system, "Ты - психолог"),
                     GPTService.Message(.system, "Ответ максимум 800 символов")]
     
        gpt.ask(messages: promt) { result in
            withAnimation {
                switch result {
                    case .success(let str):
                        
                        if let situation = str["generatedSituation"] as? String,
                           let variants = (str["variants"] as? [String]) {
                            self.messages.append(.init(data: "Ситуация", type:.Title))
                            self.messages.append(.init(data: situation, type: .Article))
                            self._lastGeneratedSituation = situation
                            
                            variants.forEach { variant in
                                self.messages.append(.init(data: variant, type: .Variant))
                            }
                        } else {
                            self.appendError()
                        }
                    case .failure(let err):
                        self.appendError(err.localizedDescription)
                }
            }
            self.removeLoading()
        }
    }
    
    func QuizNowYourself() {
        clearChat()
        appendLoading()

        let promt = [GPTService.Message.lang(User.language),
                     GPTService.Message(.user, "Проведем упражнение на самосознание для пользователя. Ты должен сгенерировать один сложный, глубокий, провокационный, психологический вопрос, благодаря которому, пользователь сможет лучше узнать себя. Помести текст вопроса в поле \"generatedQuestion\". Придумай несколько вероятных ответов на вопрос который ты сгенерировал и помести их (варианты ответа) в массив строк \"variants\"."),
                     GPTService.Message.json(format: QuizKnowYourselfResponse.format()),
                     GPTService.Message(.system, "Ты - психолог"),
                     GPTService.Message(.system, "Ответ максимум 400 символов")]
     
        gpt.ask(messages: promt) { result in
            withAnimation {
                switch result {
                    case .success(let str):
                        if let situation = str["generatedQuestion"] as? String,
                           let variants = (str["variants"] as? [String]) {
                            self.messages.append(.init(data: "Вопрос самосознания", type: .Title))
                            self.messages.append(.init(data: situation, type: .Article))
                            self._lastGeneratedSituation = situation
                            variants.forEach { variant in
                                self.messages.append(.init(data: variant, type: .QuizVariant))
                            }
                        } else {
                            self.appendError()
                        }
                    case .failure(let err):
                        self.appendError(err.localizedDescription)
                }
            }
            self.removeLoading()
        }
    }
 
    func chooseQuizVariant(_ variant: String) {
        removeAllButtons()
        appendLoading()
 
        let format = CharacterResponse.format()
        
        let promt = [GPTService.Message.json(format: format),
                     GPTService.Message.lang(User.language),
                     GPTService.Message(.system, "Помести свой текст ответа в поле \"characteristics\""),
                     GPTService.Message(.system, "Ты - психолог"),
                     GPTService.Message(.user, "Пользователю задали вопрос: \(messages[1].data)), на что он ответил: \(variant). Напиши характеристику чеолвека, давй советы, проведи глубокий психологический анализ")]
     
        gpt.ask(messages: promt) { result in
            withAnimation {
                switch result {
                    case .success(let str):
                        
                        if let situation = str["characteristics"] as? String {
                            self.messages.append(.init(data: "Характеристика", type: .Title))
                            self.messages.append(.init(data: situation, type: .Article))

                        } else {
                            self.appendError()
                        }
                        
                    case .failure(let err):
                        self.appendError(err.localizedDescription)
                }
            }
            self.removeLoading()
        }
    }
    
    func chooseVariant(_ variant: String) {
        removeAllButtons()
        appendLoading()
        let promt = "Мы поставили человека в ситуацию: \"\(_lastGeneratedSituation)\". При этом человек выбрал поступить так: \"\(variant)\". Как это характеризует человека? Дай совет по контролю эмоций. Запиши свой ответ в поле characteristics"
        let format = CharacterResponse.format()
        gpt.ask(promt: promt, format: format) { result in
            withAnimation {
                switch result {
                    case .success(let str):
                        if let situation = str["characteristics"] as? String {
                            self.messages.append(.init(data: "Характеристика", type: .Title))
                            self.messages.append(.init(data: situation, type: .Article))
                            self._lastGeneratedSituation = situation
                        } else {
                            self.appendError()
                        }
                        
                    case .failure(let err):
                        self.appendError(err.localizedDescription)
                }
            }
            self.removeLoading()
        }
    }
   
    func askCastomQuestion(_ question: String) {
        
        if diaryMode {
            self.diaryStep += 1
            self.nextEmoDiaryStep()
            return
        }
        
        
        appendLoading()
        let format = CastomQuestionResponse.format()
        
        let promt = [GPTService.Message.json(format: format),
                     GPTService.Message.lang(User.language),
                     GPTService.Message(.system, "Отвечай только если юзер спрашивает на темы: психология, человеческие взаимоотношения, чувства, философия, душевные переживания. Если вопрос пользователя не связан с этими темами - ответь что не можешь ответить и предложи варианты вопросов на эти темы"),
                     GPTService.Message(.system, "Помести текст ответа в поле \"answer\""),
                     GPTService.Message(.system, "ответ максимум 600 символов"),
                     GPTService.Message(.user, question)]
     
        gpt.ask(messages: promt) { result in
            withAnimation {
                switch result {
                    case .success(let str):
                        if let situation = str["answer"] as? String {
                            self.messages.append(.init(data: question, type: .Title))
                            self.messages.append(.init(data: situation, type: .Article))
                        } else {
                            self.appendError()
                        }
                    case .failure(let err):
                        self.appendError(err.localizedDescription)
                }
            }
            self.removeLoading()
        }
    }
    
    func appendLoading(){
        loading = true
        withAnimation {
            messages.append(.init(data: "Loading...", type: .Loading))
        }
    }
    func removeLoading(){
        withAnimation {
            messages.removeAll { $0.type == .Loading }
        }
        loading = false
    }
    func appendError(_ err: String = "please retry"){
        withAnimation {
            messages.append(.init(data: err, type: .Error))
        }
    }
    func clearChat(){
        withAnimation {
            messages.removeAll()
        }
    }
    func removeAllButtons(){
        withAnimation {
            messages.removeAll { $0.type == .Variant && $0.type == .QuizVariant }
        }
        loading = false
    }
}


struct ChatHome: View {
    
    @StateObject var model: ChatHomeModel = ChatHomeModel()
    @State private var selectedTab = 0
    @FocusState var focus: FocusElement?
    
    var body: some View {
        ZStack {
           
            ScrollViewReader { proxy in
                
                ScrollView(.vertical) {
                    
                    HStack(content: {
                        HStack(alignment: .center, spacing: 3) {
                            HomeViews.CalendarDayItem(text: "14").opacity(0.2)
                            HomeViews.CalendarDayItem(text: "15").opacity(0.6)
                            HomeViews.CalendarDayItem(text: "16")
                                .frame(maxWidth: .infinity)
                                .padding(5)
                                .background(Color(uiColor: UIColor(hex: "5D6178")!))
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 0)
                            HomeViews.CalendarDayItem(text: "17").opacity(0.6)
                            HomeViews.CalendarDayItem(text: "18").opacity(0.2)
                        }.frame(height: 55)
                    }).background(Color(uiColor: UIColor(hex: "2D2E38")!))
                        .cornerRadius(15)
                        .padding(10)
                    
                    
                    VStack(alignment: .leading, spacing: 3, content: {
                        
                        
                        ForEach(model.messages, id: \.id) { item in
                            
                            if item.type == .Variant {
                                Button {
                                    self.model.chooseVariant(item.data)
                                } label: {
                                    HomeViews.ChatVariantItem(text: item.data)
                                }.transition(.slide)
                                
                            } else if item.type == .Article {
                                HomeViews.ChatTextItem(text: item.data).transition(.slide)
                            } else if item.type == .QuizVariant {
                                Button {
                                    self.model.chooseQuizVariant(item.data)
                                } label: {
                                    HomeViews.ChatVariantItem(text: item.data)
                                }.transition(.slide)
                            } else if item.type == .Title {
                                HomeViews.ChatTitleItem(text: item.data).transition(.slide)
                            } else if item.type == .Error {
                                HomeViews.ChatErrorItem(text: item.data).transition(.opacity)
                            } else if item.type == .Loading {
                                HomeViews.TypingIndicatorView().transition(.opacity)
                            }
                            
                        }
                    })
                    Rectangle().frame(width: 0, height: 400, alignment: .center)
                        .id("SPACE")
                        .onChange(of: model.messages.count) { count in
                            withAnimation {
                                proxy.scrollTo("SPACE", anchor: .bottom)
                            }
                        }
                }.scrollIndicators(.hidden)
                    
            }
            VStack(spacing: 1) {
                Spacer()
               
                HomeViews.TextInputItem(focus: _focus, onSubmit: model.askCastomQuestion).padding(2)
                if (self.focus != .name) {
                    
                    TabView(selection: $selectedTab) {
                        Grid(alignment: .top, horizontalSpacing: 5, verticalSpacing: 5) {
                            GridRow {
                                Button(action: model.dailytest, label: {
                                    HomeViews.MenuItem(text: "Therapy",
                                                       subtext: "Daily test",
                                                       icon: "flame.fill")
                                }).disabled(model.loading)
                                
                                Button(action: model.randomTarotCard, label: {
                                    HomeViews.MenuItem(text: "Tarot",
                                                       subtext: "Choose card",
                                                       icon: "rectangle.portrait.fill")
                                }).disabled(model.loading)
                            }
                            GridRow {
                                
                                Button(action: model.QuizNowYourself, label: {
                                    HomeViews.MenuItem(text: "Quiz",
                                                       subtext: "know yourself",
                                                       icon: "person.fill")
                                }).disabled(model.loading)
                                
                                Button(action: model.nextEmoDiaryStep, label: {
                                    HomeViews.MenuItem(text: "Diary",
                                                       subtext: "Emotional diary",
                                                       icon: "book.fill")
                                }).disabled(model.loading)
                            }
                        }.padding(2).tag(1).offset(y:-25)
                        
                        Grid(alignment: .top, horizontalSpacing: 5, verticalSpacing: 5) {
                            GridRow {
                                Button(action: {}, label: {
                                    HomeViews.MenuItem(text: "Generate")
                                }).disabled(model.loading)
                                Button(action: {}, label: {
                                    HomeViews.MenuItem(text: "Change")
                                }).disabled(model.loading)
                            }
                            GridRow {
                                Button(action: {}, label: {
                                    HomeViews.MenuItem(text: "Remove")
                                }).disabled(model.loading)
                                Button(action: {}, label: {
                                    HomeViews.MenuItem(text: "Profile")
                                }).disabled(model.loading)
                            }
                        }.padding(2).tag(2).offset(y:-25)
                        
                        
                    }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .frame(height: 280)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color(uiColor: UIColor(hex: "3D3D4A")!).opacity(0),
                                                                       Color(uiColor: UIColor(hex: "3D3D4A")!),
                                                                       Color(uiColor: UIColor(hex: "3D3D4A")!),
                                                                       Color(uiColor: UIColor(hex: "3D3D4A")!)]), startPoint: .top, endPoint: .bottom)
                        )
                }
              
            }
        }.background(Color(uiColor: UIColor(hex: "3D3D4A")!))
    }
}

#Preview {
    ChatHome().preferredColorScheme(.dark)
}


enum FocusElement: Hashable {
    case name
}
