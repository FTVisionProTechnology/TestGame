import RealityKit
import SwiftUI
import RealityKitContent

class BirdEntity: Entity {

    let orbit = Entity()
    let placeHolder = Entity()
    private var bird = Entity()
    private var audioPlaybackController: AudioPlaybackController?

    @MainActor
    required init() {
        super.init()
    }

    init(name: String) async {
        super.init()
        
        guard let bird = try? await Entity(named: "Bird_With_Audio", in: realityKitContentBundle) else { return }
        self.bird = bird
        if let animation = bird.availableAnimations.first {
            bird.playAnimation(animation.repeat())
        }

        self.name = name

        placeHolder.position = [0, 0, -Constants.Chaser.moveRadius]
        placeHolder.addChild(bird)
        orbit.addChild(placeHolder)
        addChild(orbit)

        if let spatialAudioEntity = bird.findEntity(named: "SpatialAudio"),
           let audio = try? await AudioFileResource(named: "Bird_Call_1") {
            audioPlaybackController = spatialAudioEntity.prepareAudio(audio)
        }
    }

    func playAudio() {
        audioPlaybackController?.play()
    }

    func stopAudio() {
        audioPlaybackController?.stop()
    }

}
