//
//  LaunchScreenView.swift
//  esotericApp
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import Foundation
import SwiftUI

struct LaunchScreenView: View {
    
    @EnvironmentObject var mainModel: MainViewModel
    
    
    var body: some View {
        ZStack {

            VStack(alignment: .leading) {
                Text("Winst")
                    .font(.system(size: 60, weight: .black, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.textColor)
               
                if let git = mainModel.git {
                    AsyncImage(url: URL(string: git.creatorOfTheWeek.profileHeaderImageURL)) { phase in
                        switch phase {
                            case .empty:
                                VStack(alignment: .center) {
                                    ProgressView()
                                }.frame(maxWidth: .infinity)
                            case .success(let image):
                             
                                ZStack(alignment:.bottomLeading) {
                                    
                                    
                                    ZStack() {
                                        
                                        image
                                            .resizable()
                                            .padding()
                                            .aspectRatio(1/1, contentMode: .fit)
                                            .blur(radius: 40)
                                            //.scaleEffect(0.9)
                                            .offset(y: 30)
                                            .brightness(0.19)
                                            .contrast(1.4)
                                            .saturation(1.9)
                                            .opacity(0.8)
                                        image
                                            .resizable()
                                            .aspectRatio(1/1, contentMode: .fit)
                                            .cornerRadius(31)
                                    }
                              
                                    HStack(spacing: 10) {
                                        
                                        VStack(alignment: .leading) {
                                            Text(git.creatorOfTheWeek.profileName)
                                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                                .foregroundColor(.white)
                                            Text("L_PhotoOfTheWeek")
                                                .font(.system(size: 9, weight: .ultraLight, design: .rounded))
                                                .foregroundColor(.white)
                                        }
                                    }.padding(.horizontal,15)
                                        .padding(.vertical,7)
                                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 40))
                                        .padding()
                                }.padding(30)
                            case .failure:
                                EmptyView()
                            @unknown default:
                                EmptyView()
                        }
                    }
                } else {
                    EmptyView()
                }
                
             
                
                
            }
        }.background {
            Image("LounchScreenBG").resizable().aspectRatio(contentMode: .fill)
        }
    }
}


struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
