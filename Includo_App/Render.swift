import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView(frame: .zero)

        // Create a scene
        let scene = SCNScene()
        scnView.scene = scene

        // Add a light source
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 100, y: 100, z: 100)
        scene.rootNode.addChildNode(lightNode)

        // Add cubes in a grid
        for i in 0...3 {
            for j in 0...3 {
                let cube = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0.1)
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.red
                cube.materials = [material]
                let cubeNode = SCNNode(geometry: cube)
                cubeNode.position = SCNVector3(x: Float(30 * i), y: Float(30 * j), z: 0)
                scene.rootNode.addChildNode(cubeNode)
            }
        }

        // Camera control and default lighting
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true

        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update code if needed
    }
}

struct ContentView: View {
    var body: some View {
        SceneKitView()
            .edgesIgnoringSafeArea(.all) // Ensure it takes full space if needed
    }
}
#Preview {
    ContentView()
}

