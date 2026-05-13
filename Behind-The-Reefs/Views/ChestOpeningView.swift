import SwiftUI

struct ChestOpeningView: View {
    
    @State private var chestOpened = false
    @State private var translateKeys = false
    @State private var fadeKeys = false
    
    // State per key
    @State private var rotatedKeys: [Bool] = Array(repeating: false, count: 5)
    
    var body: some View {
        
        VStack {
            
            // Chest
            Image(
                chestOpened
                ? "chestOpened"
                : "chestClosed"
            )
            .resizable()
            .scaledToFit()
            .frame(width: 400)
            
            
            // Keys
            HStack(spacing: 14) {
                
                ForEach(0..<5, id: \.self) { index in
                    
                    Image("Behind_the_Reefs_Keys-0\(index + 1)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                    
                        // Rotate one by one
                        .rotationEffect(
                            .degrees(rotatedKeys[index] ? 180 : 30)
                        )
                    
                        // Move together
                        .offset(
                            y: translateKeys ? -40 : 0
                        )
                    
                        // Fade together
                        .opacity(fadeKeys ? 0 : 1)
                    
                        .animation(
                            .easeInOut(duration: 1),
                            value: rotatedKeys[index]
                        )
                        .animation(
                            .easeInOut(duration: 1),
                            value: translateKeys
                        )
                        .animation(
                            .easeOut(duration: 0.75),
                            value: fadeKeys
                        )
                }
            }
            .padding(.bottom, 30)
        }
        .onAppear {
            
            // Rotate one by one
            for index in 0..<5 {
                
                DispatchQueue.main.asyncAfter(
                    deadline: .now()+0.5 + Double(index) * 0.15
                ) {
                    rotatedKeys[index] = true
                }
            }
            
            // Move all together
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
                translateKeys = true
            }
            
            // Fade all together
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.50) {
                fadeKeys = true
            }
            
            // Open chest
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                chestOpened = true
            }
        }
    }
}

struct NewGameAlertView_Previews: PreviewProvider {
    static var previews: some View {
        ChestOpeningView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
