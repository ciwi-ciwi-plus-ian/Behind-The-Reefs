import SwiftUI
import SpriteKit

private extension Font {
    static let snigletBody  = Font.custom("Sniglet-Regular", size: 15)
    static let snigletTitle = Font.custom("Sniglet-Regular", size: 17)
}

struct TutorialView: View { 
    
    @Environment(NavigationRouter.self) private var router
    
    @State private var showLoading = true
    @State private var animateTriangles = false
    @State private var tutorialStep: Int = 1
    @State private var tutorialScene = TutorialScene()
    @State private var tutorialStep3Completed = false
    @State private var showCollection = false
    @Binding var isPresented: Bool
     
    private static let sortAreaWidth: CGFloat = 520
    
    var body: some View {
        GeometryReader { proxy in
            let sortRect = CGRect(
                x: (proxy.size.width - Self.sortAreaWidth) / 2,
                y: 0,
                width: Self.sortAreaWidth,
                height: proxy.size.height
            )
            ZStack {
                backgroundImage(size: proxy.size)
                overlayView(sortRect: sortRect)
                if tutorialStep >= 3 {
                    tutorialSceneView()
                        .zIndex(1)
                }
                navigationBar
                    .allowsHitTesting(!showLoading)
                if tutorialStep != 3 {
                    nextButton
                        .allowsHitTesting(!showLoading)
                }
                if tutorialStep < 4 {
                    skipButton
                        .allowsHitTesting(!showLoading)
                }
                if showLoading {
                    Color.black.opacity(0.7) 
                        .ignoresSafeArea()
                        .zIndex(9)
 
                    LoadingGameView()
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .zIndex(10)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    showLoading = false
                                }
                            }
                        }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea() 
        .onTapGesture {
            if tutorialStep != 3 && !showLoading { advance() }
        }
        .onChange(of: tutorialStep) { _, newStep in
            if newStep == 3 { configureTutorialScene() }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showCollection) {
            CollectionView()
        }
    }
    
    private func backgroundImage(size: CGSize) -> some View {
        Image(tutorialStep < 3 ? "PuzzleScreen" : "PuzzleScreen")
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipped()
            .ignoresSafeArea()
    }
    
    private var navigationBar: some View {
        VStack {
            HStack(alignment: .center) {
                Button { router.goToMainMenu() } label: {
                    Image("homeIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                }
                .padding(.leading, 16)
                .opacity(tutorialStep == 1 ? 1.0 : 0.3)
                
                if tutorialStep == 1 {
                    Text("Tap home to return\nto the main menu")
                        .font(.snigletBody)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 8)
                }
                
                Spacer()
                
                if tutorialStep == 2 {
                    Text("Tap here to view\nyour collected items")
                        .font(.snigletBody)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing, 8)
                }
                
                Button { showCollection = true } label: {
                    Image("treasureChestIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                }
                .padding(.trailing, 16)
                .opacity(tutorialStep == 2 ? 1.0 : 0.3)
            }
            .padding(.horizontal, 32)
            .padding()
            Spacer()
        }
    }
    
    private var nextButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: advance) {
                    Text(tutorialStep < 4 ? "Next" : "Got it!")
                        .font(.snigletTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 8)
                        .background(tutorialStep < 4 ? Color.white.opacity(0.25) : Color.black.opacity(0.55))
                        .clipShape(Capsule())
                }
                .disabled(tutorialStep == 3 && !tutorialStep3Completed)
                
                .padding()
                Spacer()
            }
        }
        .zIndex(2)
    }
    
    private var skipButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    router.navigate(to: .puzzle)
                } label: {
                    Text("➜  Skip Tutorial")
                        .font(.snigletTitle)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 32)
            .padding()
        }
        .zIndex(2)
    }
    
    private func creatureItems(sortRect: CGRect, screenWidth: CGFloat) -> some View {
        let bottomY = sortRect.midY + 100
        let size: CGFloat = 80
        
        let chocoX: CGFloat  = sortRect.minX + sortRect.width * 0.25
        let purpleX: CGFloat = sortRect.minX + sortRect.width * 0.9
        
        return ZStack {
            creatureImage("itemChoco",  x: chocoX,  y: bottomY, size: size)
            creatureImage("itemPurple", x: purpleX, y: bottomY, size: size)
        }
    }
    
    private func creatureImage(_ name: String, x: CGFloat, y: CGFloat, size: CGFloat) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .position(x: x, y: y)
    }
    
    @ViewBuilder
    private func overlayView(sortRect: CGRect) -> some View {
        if tutorialStep >= 3 {
            ZStack {
                Color.black.opacity(0.75)
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: sortRect.width, height: sortRect.height)
                    .position(x: sortRect.midX, y: sortRect.midY)
                    .blendMode(.destinationOut)
                if tutorialStep == 3 {
                    Text("Drag and drop\nyour items here")
                        .font(.snigletTitle)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: sortRect.width)
                        .position(x: sortRect.midX, y: sortRect.midY)
                    Image("bobbingTriangle")
                        .resizable()
                        .scaledToFit().frame(width: 475).offset(y: animateTriangles ? 100 : 120)
                }
                else {
                    Text("You've done it!\nNow you're all set!")
                        .font(.snigletTitle)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: sortRect.width)
                        .position(x: sortRect.midX, y: sortRect.midY)
                }
                
            }
            .compositingGroup()
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 2)
                    .repeatForever(autoreverses: true)
                ) {
                    animateTriangles.toggle()
                }
            }
        } else {
            Color.black.opacity(0.75)
                .ignoresSafeArea()
        }
    }
    
    private func configureTutorialScene() {
        tutorialStep3Completed = false
        tutorialScene = TutorialScene()
        tutorialScene.isDragEnabled = true
        tutorialScene.onTutorialCompleted = { completed in
            if completed {
                DispatchQueue.main.async {
                    tutorialScene.isDragEnabled = false
                    tutorialStep3Completed = true
                    tutorialStep = 4
                    withAnimation(.easeInOut(duration: 0.4)) { tutorialStep = 4 }
                }
            }
        }
    }
    
    private func tutorialSceneView() -> some View {
        SpriteView(scene: tutorialScene, options: [.allowsTransparency])
            .ignoresSafeArea()
            .onAppear {
                if tutorialStep >= 3, tutorialStep3Completed == false {
                    configureTutorialScene()
                }
            }
    }
    
    private func advance() {
        if tutorialStep == 3 && !tutorialStep3Completed { return }
        if tutorialStep < 4 {
            withAnimation(.easeInOut(duration: 0.4)) { tutorialStep += 1 }
        } else {
            router.navigate(to: .puzzle)
        }
    }
}

#Preview(traits: .landscapeRight) {
    TutorialView(isPresented: .constant(true))
        .environment(NavigationRouter())
}
