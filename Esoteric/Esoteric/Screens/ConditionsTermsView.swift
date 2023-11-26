//
//  ConditionsTermsView.swift
//  esotericApp
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import Foundation
import SwiftUI
import RevenueCat

struct ConditionsTermsView: View {
    @Environment(\.openURL) var openURL
    
    
    var body: some View {
        ScreenContentView(color: .clear) {
            
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            SectionTitleView(textColor: .white, text: "Есть вопросы?", alignment: .leading)
                            Image("art_delimiter8").resizable().aspectRatio(contentMode: .fill)
                        }
                        Button {
                            if let url = URL(string: "https://t.me/imbalanceFighter") {
                                openURL(url)
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "envelope.fill")
                              
                                Text("Написать нам").multilineTextAlignment(.leading)
                                
                                Spacer()
                                Image(systemName: "chevron.right")
                                
                            }  .foregroundColor(.buttonBlue)
                                .font(.custom("ElMessiri-Bold", size: 18))
                        }
                    }
                    HStack(spacing: 10) {
                        Image(systemName: "doc.fill")
                        Link(destination: URL(string: "end_user_license_agreement_url".remote())!) {
                            Text("License").multilineTextAlignment(.leading)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                        
                    }  .foregroundColor(.textColor)
                        .font(.custom("ElMessiri-Bold", size: 18))
                    
                    HStack(spacing: 10) {
                        Image(systemName: "doc.fill")
                        Link(destination: URL(string: "privacy_policy_url".remote())!) {
                            Text("Privacy Policy").multilineTextAlignment(.leading)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }  .foregroundColor(.textColor)
                        .font(.custom("ElMessiri-Bold", size: 18))
                    
                    HStack(spacing: 10) {
                        Image(systemName: "doc.fill")
                        Link(destination: URL(string: "Terms_Conditions_url".remote())!) {
                            Text("Terms Conditionsl").multilineTextAlignment(.leading)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    } .foregroundColor(.textColor)
                        .font(.custom("ElMessiri-Bold", size: 18))
                    Button {
                        Purchases.shared.restorePurchases()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                            Text("Restore purchase")
                        }.font(.custom("ElMessiri-Bold", size: 18)).foregroundColor(.buttonRed)
                    }
                    
                    
                }
                
            }.frame(maxWidth: .infinity)
            
            
        }
    }
}

struct ConditionsTermsView_Previews: PreviewProvider {
    static var previews: some View {
        ConditionsTermsView()
    }
}
