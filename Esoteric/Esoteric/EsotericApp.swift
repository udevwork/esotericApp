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
                    NavigationStack {
                        HomeView()
                    }.transition(.opacity)
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
}

class MainViewModel: ObservableObject {
    
    @Published var isLoadingComplete        : Bool = false
    @Published var needToPresentOnboarding  : Bool = false
    @Published var screenTransitionAnimation: Bool = false
    
    var isFirebaseFetchComplete: Bool = false
    let storageService = StorageService.shared

    init() {
        Task { try await startFetching() }
        DayConterService().checkIfMissDay()
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
        if isFirebaseFetchComplete {
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                self.isLoadingComplete = true
                self.checkIfNeedToShowOnboarding()
                self.screenTransitionAnimation.toggle()
            })
        }
    }

    func checkIfNeedToShowOnboarding(){
        let OnboardingWasShowed = UserDefaults.standard.bool(forKey: "OnboardingWasShowed")
        if OnboardingWasShowed == false {
            needToPresentOnboarding = true
        }
    }
}
