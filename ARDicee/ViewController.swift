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
    
    @IBOutlet weak var text: UITextField!
    @IBOutlet var sceneView: ARSCNView!
    
    var diceArray: [SCNNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
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
    
    // Detected an acnhor
    // anchor is like a tile and you can use that tile to place objects on it
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // if the new anchor is type of plaine anchor
        guard let planeAnchor = anchor as? ARPlaneAnchor else {// downcast anchor it to plane anchor
            fatalError("anchor is not plain")
        }
        // Converting our plain anchor to a scene plain so that we can use it with Scenekit
//        let plane = SCNPlane(width: CGFloat(planeAnchor.planeExtent.width), height: CGFloat(planeAnchor.planeExtent.height))
        
        // Node
//        let planeNode = SCNNode()
//        planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        // rotating the node from being a 2D vertical object to a horizontal object, so it can fit the anchor
        // pi = 180º  so->  pi/2 = 90º ("-" is for making it clock wise) and 1 in the x spot means that we want to rotate it around the x axis
//        planeNode.transform = SCNMatrix4MakeRotation((-Float.pi/2), Float(1), 0, 0)
        // Material
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        // Node
//        plane.materials = [material]
//        node.geometry = plane
        DispatchQueue.main.async {
            self.text.text = "Surface detected"
        }
//        node.addChildNode(planeNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocatoin = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocatoin, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                addDice(location: hitResult)
            }
        }
    }
    
    func addDice(location: ARHitTestResult) {
        let diceScene = SCNScene(named: "art.scnassets/dice.scn")!
        // Node
        let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true)!
        diceNode.position = SCNVector3(
            location.worldTransform.columns.3.x,
            location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
            location.worldTransform.columns.3.z)
        
        diceArray.append(diceNode)
        
        // Set the scene to the view
        sceneView.scene.rootNode.addChildNode(diceNode)
        
        roll(diceNode)
    }
    
    // If user press roll button
    @IBAction func rollPressed(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    // roll all dices with phone shake
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    @IBAction func removeAll(_ sender: UIBarButtonItem) {
        for dice in diceArray {
            dice.removeFromParentNode()
        }
    }
    
    // function to roll all the available dices
    func rollAll() {
        if diceArray.isEmpty == false {
            for dice in diceArray {
                roll(dice)
            }
        }
    }
    
    // this will rokk the first time dice appears
    func roll(_ diceNode : SCNNode) {
        let randomX = (Float(arc4random_uniform(4) + 1)) * (Float.pi/2)
        let randomZ = (Float(arc4random_uniform(4) + 1)) * (Float.pi/2)
        diceNode.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 3), y: 0, z: CGFloat(randomZ * 2), duration: 0.5))
    }
}
