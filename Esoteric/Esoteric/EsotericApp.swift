



//
//  APP.swift
//  esotericApp
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import SwiftUI
import FirebaseCore
import FirebaseRemoteConfig
import RevenueCat

@main
struct EsotericApp: App {

    @StateObject var model = MainViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() { }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if model.isLoadingComplete, model.needToPresentOnboarding == false {
                    if model.needToPresentTarotSpread {
                        NavigationStack {
                            TarotSpreadReady(model: CardsTableViewModel(cardsNum: 3))
                        }.transition(.opacity)
                    } else {
                        NavigationStack {
                            HomeView()
                                .environmentObject(model)
                        }.transition(.opacity)
                    }
                }

                if model.isLoadingComplete,  model.needToPresentOnboarding {
                    OnboardingView().environmentObject(model).transition(.opacity)
                }

                if model.isLoadingComplete == false {
                    LaunchScreenView()
                        .transition(.opacity)
                        .environmentObject(model)
                }


            }.preferredColorScheme(.dark)
                .animation(.easeInOut, value: model.screenTransitionAnimation)
                .onAppear {
                    let user = User.shared
                    user.getTime()
                    user.saveTime()
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        var firebasePlistFileName = ""
        #if DEBUG
        firebasePlistFileName = "GoogleService-Info-Debug"
        #else
        firebasePlistFileName = "GoogleService-Info-Release"
        #endif

        guard let filePath = Bundle.main.path(forResource: firebasePlistFileName, ofType: "plist"),
            let options = FirebaseOptions(contentsOfFile: filePath)
        else {
            fatalError("Couldn't load config file")
        }
        FirebaseApp.configure(options: options)
        PurchasesHelper.configure()
        
        PurchasesHelper.isSubscribed {
            User.shared.isProUser = $0
        }
        return true
    }

//    func applicationDidBecomeActive(_ application: UIApplication) {
//        checkApplicationState(application.applicationState)
//    }

//    func checkApplicationState(_ applicationState: UIApplication.State) {
//        switch applicationState {
//        case .background:
//            break
//        case .inactive:
//            break
//        case .active:
//            UIApplication.shared.applicationIconBadgeNumber = 0
//        @unknown default:
//            break
//        }
//    }
}

class MainViewModel: ObservableObject {
    
    let githubfetcher = GithubFetcher()
    @Published var git: GithubAppData? = nil
    var isGitFetchComplete: Bool = false
    var isFirebaseFetchComplete: Bool = false
    @Published var isLoadingComplete: Bool = false
    @Published var needToPresentOnboarding = false
    @Published var screenTransitionAnimation = false
    @Published var needToPresentTarotSpread = false
    let storageService = LocalStorageService.shared

    init() {
        Task {
            try await startFetching()
        }
        githubfetcher.getRawTextFromGithub { [weak self] data in
            DispatchQueue.main.async {
                self?.git = data
                self?.isGitFetchComplete = true
                self?.checkIfEveryLoadingCompleted()
            }
        }
    }
    
    private func startFetching() async throws {
        
        let rc = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        rc.configSettings = settings
        
        do {
            let config = try await rc.fetchAndActivate()
            switch config {
                case .successFetchedFromRemote:
                    print( rc.configValue(forKey: "appLink").stringValue as Any)
                 
                    self.isFirebaseFetchComplete = true
                    self.checkIfEveryLoadingCompleted()
                    
                    return
                case .successUsingPreFetchedData:
                    print( rc.configValue(forKey: "appLink").stringValue as Any)
                
                    self.isFirebaseFetchComplete = true
                    self.checkIfEveryLoadingCompleted()
                    return
                default:
                    print("Error activating")
                    return
            }
        } catch let error {
            print("Error fetching: \(error.localizedDescription)")
        }
    }
    
    func checkIfEveryLoadingCompleted(){
        if isGitFetchComplete && isFirebaseFetchComplete {
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                self.isLoadingComplete = true
                self.checkIfNeedToShowOnboarding()
                self.checkIfNeedToShowSpread()
                self.screenTransitionAnimation.toggle()
            })
            
        }
    }

    func checkIfNeedToShowSpread() {
        let currentTimeInterval = Date().timeIntervalSince1970
        let dataDiff = (storageService.loadQuestion(key: SavingKeys.question.rawValue)?.time ?? 0) - currentTimeInterval
        needToPresentTarotSpread = dataDiff == NotificationIntervals.fiveSec.rawValue
    }

    func checkIfNeedToShowOnboarding(){
        let OnboardingWasShowed = UserDefaults.standard.bool(forKey: "OnboardingWasShowed")
        if OnboardingWasShowed == false {
            needToPresentOnboarding = true
        }
    }
    
}
