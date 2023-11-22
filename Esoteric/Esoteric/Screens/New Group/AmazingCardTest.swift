//
//  AmazingCardTest.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 15.11.2023.
//

import SwiftUI
import CoreMotion

func fuck(_ color: UIColor, intensity: CGFloat = 0.8) -> Gradient {
    
    let i = min(max(intensity, 0), 1)
    
    let colors = [
        color.withAlphaComponent(1.0 * i),
        color.withAlphaComponent(0.00 * i),
        color.withAlphaComponent(1.0 * i),
        color.withAlphaComponent(0.00 * i),
        color.withAlphaComponent(1.0 * i),
        color.withAlphaComponent(0.00 * i)
    ]
    
    return Gradient(colors: colors.map { Color($0) })
}

struct AmazingCardTest: View {
   
    var body: some View {
        AmazingCardBack(text: "card0")
           
    }
}


struct AmazingCardBack: View {
    
    @StateObject var manager = MotionManager()
    let tileWidth: CGFloat = screenWidthPart(2.5)
    let tileHeight: CGFloat = screenPart(3)
    
    var text : String
    var body: some View {

        
            VStack() {
                ZStack {
                    ZStack {
                        Image("card-img-back")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                        Image("\(text)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blendMode(.colorDodge)
                            .opacity(0.9)
                           
                    }
                    ZStack {
                        Image("gold")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                        Rectangle()
                            
                            .shiny(fuck(.black))
                            .frame(width: tileWidth, height: tileHeight)
                    }
                    
                    .mask {
                        ZStack {
                            Image("\(text)-mask")
                                .resizable()
                        }
                    }
        
            
                }
            }
            .frame(width: tileWidth, height: tileHeight)
            .clipShape(RoundedRectangle(cornerRadius: 10))
           
        
    }
}


struct ParallaxMotionModifier: ViewModifier {
    
    @StateObject var manager: MotionManager
    var magnitude: Double
    
    func body(content: Content) -> some View {
        content
            .offset(x: CGFloat(manager.roll * magnitude),
                    y: CGFloat(manager.pitch * magnitude))
    }
}

class MotionManager: ObservableObject {

    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    
    private var manager: CMMotionManager

    init() {
        self.manager = CMMotionManager()
        self.manager.deviceMotionUpdateInterval = 1/60
        self.manager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
            guard error == nil else {
                print(error!)
                return
            }

            if let motionData = motionData {
                self.pitch = motionData.attitude.pitch
                self.roll = motionData.attitude.roll
            }
        }

    }
}

#Preview {
    AmazingCardTest()
}
