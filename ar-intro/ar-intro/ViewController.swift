//
//  ViewController.swift
//  ar-intro
//
//  Created by Prayash Thapa on 10/3/17.
//  Copyright © 2017 Prayash Thapa. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate, SCNSceneRendererDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var boxNode = SCNNode()
    var planes = [UUID: Plane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func setupScene() {
        // Setup the ARSCNViewDelegate - this gives us callbacks to handle new
        // geometry creation
        self.sceneView.delegate = self
        
        // Adds default lighting to scene
        self.sceneView.autoenablesDefaultLighting = true
        
        // Show statistics such as fps and timing information
        self.sceneView.showsStatistics = true
        
        // Show debug information for feature tracking
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        // Create a new scene by loading it from scene assets
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Define a box geometry
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
        
        // Create the node for the scene
        boxNode = SCNNode(geometry: boxGeometry)
        
        // Position it as desired
        boxNode.position = SCNVector3Make(0, 0.25, -0.5)
        
        // Attach to scene's root node
        scene.rootNode.addChildNode(boxNode)
        
        // Set the scene to the view
        self.sceneView.scene = scene
        sceneView.isPlaying = true
    }
    
    func setupSession() {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Specify that we want to track horizontal planes. Setting this will cause
        // the ARSCNViewDelegate methods to be called when planes are detected!
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Animate the rotation of the cube
        let rotValue = Float(time).truncatingRemainder(dividingBy: Float.pi)
        boxNode.rotation = SCNVector4Make(rotValue, 1.0, 1.0, Float.pi)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // When a new plane is detected we create a new SceneKit plane to visualize it in 3D
        let plane = Plane.init(with: planeAnchor)
        planes[anchor.identifier] = plane
        node.addChildNode(plane)
        print(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let plane = planes[anchor.identifier] {
            // When an anchor is updated we need to also update our 3D geometry too. For example
            // the width and height of the plane detection may have changed so we need to update
            // our SceneKit geometry to match that
            plane.update(anchor: anchor as! ARPlaneAnchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let _ = planes[anchor.identifier] {
            // Nodes will be removed if multiple planes that are detected to all be part of a larger plane are merged
            planes.remove(at: planes.index(forKey: anchor.identifier)!)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}
