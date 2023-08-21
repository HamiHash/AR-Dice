//
//  ViewController.swift
//  ARDicee
//
//  Created by Hamed Hashemi on 8/20/23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        //        // creating object
        //        let sphere = SCNSphere(radius: 0.2)
        //        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        //        let material = SCNMaterial() // setting material
        //        material.diffuse.contents = UIImage(named: "art.scnassets/earth.jpg") // channging color
        //        sphere.materials = [material] // setting the created material to cube
        //
        //
        //
        //        // craeting the space
        //        let node = SCNNode()
        //        node.position = SCNVector3(0, 0.1, -0.5) // setting its position
        //        node.geometry = sphere // adding the created cube object to node
        //
        //        sceneView.scene.rootNode.addChildNode(node) // adding the created node to scene view's root node
        
        sceneView.autoenablesDefaultLighting = true // enable default lighting to objects so its more realisitic

        // Create a new scene
            let diceScene = SCNScene(named: "art.scnassets/dice.scn")!
            // Node
            let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true)!
            diceNode.position = SCNVector3(0, 0, -0.1)

            // Set the scene to the view
            sceneView.scene.rootNode.addChildNode(diceNode)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        print(ARWorldTrackingConfiguration.isSupported)
        
        // this will enable horizental detection
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Pause the view's session
//        sceneView.session.pause()
//    }
    
    // Detected a horizontal space
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        <#code#>
//    }
}
