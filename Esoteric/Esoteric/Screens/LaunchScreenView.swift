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
            BackGroundView().opacity(0.5)
            VStack(alignment: .leading) {
               
                
                Image("Logo")
                    .resizable()
                    .padding()
                    .aspectRatio(1/1, contentMode: .fit)
                Text("TAROT")
                    .font(.custom("ElMessiri-Bold", size: 60))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.textColor)

            }
        }
    }
}


struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView().preferredColorScheme(.dark)
    }
}
