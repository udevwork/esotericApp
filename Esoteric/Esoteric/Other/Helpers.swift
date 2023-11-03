//
//  Helpers.swift
//  esotericApp
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import Foundation
import FirebaseAnalytics
import FirebaseRemoteConfig
import UIKit
import SwiftUI
import RevenueCat

let horPadding: CGFloat = 40
let verPadding: CGFloat = 10

let BGColor = Color(uiColor: UIColor(hex: "F4F8FE")!)
let EditorBGColor = Color(uiColor: UIColor(hex: "f5f8fc")!)

let BGEditorColor = Color(uiColor: UIColor(hex: "bfbfbf")!)


let accentColor2 = Color(uiColor: UIColor(hex: "323735")!)

class AnalyticsWrapper {
    
    static func onPhotoSave(){
        Analytics.logEvent("save_photo", parameters: nil)
    }
    
    static func OnSelectTemplate(_ templateName: String){
        var parameters: [String : Any] = ["template_name": templateName]
        Analytics.logEvent("select_tepmplate", parameters: parameters)
    }
    
    static func onScreanAppear(_ screenName: String){
        var parameters: [String : Any] = ["screen_name": screenName]
        Analytics.logEvent("on_screan_appear", parameters: parameters)
    }
    
}

typealias HexadecimalString = String

extension UIColor {
    
    convenience init?(hex: HexadecimalString) {
        //prepare the hex string
        var hexProcessed = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexProcessed = hexProcessed.replacingOccurrences(of: "#", with: "")
        
        //set up variables
        //-
        //unsigned integer
        var rgb: UInt32 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        //alpha default = 1.0
        var a: CGFloat = 1.0
        let length = hexProcessed.count
        
        //Scanning the string with scanner for unsigned values
        guard Scanner(string: hexProcessed).scanHexInt32(&rgb) else {
            return nil
        }
        
        //extract colors based on hex lenght
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        //Creating UIColor instance with extracted values
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    
    // MARK: - Computed Properties
    
    var hexString: HexadecimalString? {
        return hexString()
    }
    
    // MARK: - From UIColor to Hex String
    
    //One param: indicates if alpha value is included or not (bool)
    
    func hexString(alpha: Bool = false) -> HexadecimalString? {
        
        //Safely unwrapping because components property is type [CGFloat]?
        //Also mage sure that it contains a minimum of 3 components
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        //extract colors
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        //if there is an alpha value extract it too
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        //create return string, round values with lroundf
        //REMEMBER: - String formats:
        // % defines the format specifier
        // 02 defines the length of the string
        // l casts the value to an unsigned long
        // X prints the value in hexadecimal
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        }
        return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}

extension Color {
    
    static let lightGray = Color(uiColor: UIColor(hex: "E8F0FE")!)

    static let buttonBlue = Color(uiColor: UIColor(hex: "5A9CFF")!)
    static let buttonGreen = Color(uiColor: UIColor(hex: "14D6A7")!)
    static let buttonRed = Color(uiColor: UIColor(hex: "E44561")!)
    static let buttonGray = Color(uiColor: UIColor(hex: "464646")!)
    
    static let shadowColor = Color(uiColor: UIColor(hex: "E3EBF3")!)
    static let textColor = Color(uiColor: UIColor(hex: "193B68")!)
    static let secondaryTextColor = Color(uiColor: UIColor(hex: "929FB3")!)
    
   
    
}


class PurchasesHelper {
    
    public static var package: Package? = nil
    public static var storeProduct: StoreProduct? = nil
    public static var promoOffer: PromotionalOffer? = nil
    
    public static func configure() {
        
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_wuAXIwjhiGzZaJfIGEVpaiMltWW")
        
        // fetch subscription
        Purchases.shared.getOfferings { (offerings, error) in
            if let packages = offerings?.current?.availablePackages {
                if !packages.isEmpty, let firstPackage = packages.first {
                    
                    let product = firstPackage.storeProduct
                    PurchasesHelper.package = firstPackage
                    PurchasesHelper.storeProduct = product
                    
                    // get trial
                    if let discount = product.discounts.first {
                        Purchases.shared.getPromotionalOffer(forProductDiscount: discount, product: product) { (promoOffer, error) in
                            PurchasesHelper.promoOffer = promoOffer
                        }
                    }
                }
            }
        }
    }
    
    public static func eligibility(_ completion: @escaping (IntroEligibilityStatus) -> Void){
        guard let product = PurchasesHelper.storeProduct else { return }
        Purchases.shared.checkTrialOrIntroDiscountEligibility(product: product, completion: completion)
    }
    
    public static func subscribe(_ completion: @escaping PurchaseCompletedBlock){
        guard let product = PurchasesHelper.storeProduct else { return }
        Purchases.shared.purchase(product: product, completion: completion)
    }
    
    public static func isSubscribed(_ completion: @escaping (Bool)->()){
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            completion(customerInfo?.entitlements.all["PRO"]?.isActive ?? false)
        }
    }
    
    public static func trial(_ completion: @escaping PurchaseCompletedBlock){
        guard let promo = PurchasesHelper.promoOffer else { return }
        guard let package = PurchasesHelper.package else { return }
        Purchases.shared.purchase(package: package, promotionalOffer: promo, completion: completion)
    }
    
}


struct GithubAppData: Codable {
    var favoriteCreators: [FavoriteCreator]
    var creatorOfTheWeek: FavoriteCreator
}

struct FavoriteCreator: Codable, Hashable {
    var id: String
    var profileName: String
    var profileDescription: String
    var profileLink: String
    var profileAvatarImageURL: String
    var profileHeaderImageURL: String
    var technicalInfo: String
}


class GithubFetcher {
    

    func getRawTextFromGithub(_ completion: @escaping (GithubAppData?)->()) {
        let urlString = "https://raw.githubusercontent.com/udevwork/InstaSwipeDB/main/data"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
            } else if let data = data {
                do {
                    // Декодирование полученных данных
                    let result = try JSONDecoder().decode(GithubAppData.self, from: data)
                    print(result.favoriteCreators.first!.profileAvatarImageURL)
                    completion(result)
                } catch {
                    print("Error during JSON serialization: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
}

extension String {
    
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
    
    func remote(def: String = "") -> String {
        RemoteConfig.remoteConfig().configValue(forKey: self).stringValue ?? def
    }
    
    func remoteBool() -> Bool {
        RemoteConfig.remoteConfig().configValue(forKey: self).boolValue
    }
    
}

//
//if info?.entitlements.all["PRO"]?.isActive == true {
//    User.shared.isProUser = true
//}

// TODO: - Make it localized
extension SubscriptionPeriod {
    func periodToText() -> String {
        switch self.unit {
            case .day:
                return "L_day"
            case .week:
                return "L_week"
            case .month:
                return "L_month"
            case .year:
                return "L_year"
        }
    }
}
