//
//  ViewController.swift
//  ar-intro
//
//  Created by Prayash Thapa on 10/3/17.
//  Copyright © 2017 Prayash Thapa. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, SCNSceneRendererDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var boxNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
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
        
        // Adds default lighting to scene
        sceneView.autoenablesDefaultLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.isPlaying = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let rotValue = Float(time).truncatingRemainder(dividingBy: Float.pi)
        boxNode.rotation = SCNVector4Make(rotValue, 1.0, 1.0, Float.pi)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
