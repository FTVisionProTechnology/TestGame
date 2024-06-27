/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The app's main SwiftUI view for displaying an immersive environment.
*/
import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    var loader: EnvironmentLoader

    @Environment(\.scenePhase) var scenePhase
    @Environment(\.openWindow) var openWindow

    var body: some View {
        RealityView { content in
            content.add(try! await loader.getEntity())
            
            for i in (0..<5) {
                let bird = await BirdEntity(name: "00\(i)")
                bird.scale *= 2
                bird.position.x = Float(i)
                bird.position.y = 2.0
                bird.position.z = -2.0
                
                bird.components.set(
                    ChaserComponent(
                        chaseSpeed: Constants.Chaser.chaseSpeed,
                        circleSpeed: Constants.Chaser.circleSpeed,
                        orbit: bird.orbit,
                        placeHolder: bird.placeHolder)
                )
                
                content.add(bird)
            }
            
        }.onDisappear {
            // Re-opening the window if the
            // ImmersiveSpace is closed (with the Digital Crown)
            openWindow(id: "Window")
        }
    }
}

#Preview {
    ImmersiveView(loader: .init())
        .previewLayout(.sizeThatFits)
}
