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
        let audio = try? await AudioFileResource(named: "/Root/Bird_Call_Group/Bird_Call_1_wav", from: "Bird_With_Audio.usda", in: realityKitContentBundle)
        if let spatialAudioEntity = bird.findEntity(named: "SpatialAudio"),
           let audio = audio {
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
