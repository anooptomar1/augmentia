//
//  Plane.swift
//  ar-intro
//
//  Created by Prayash Thapa on 10/4/17.
//  Copyright © 2017 Prayash Thapa. All rights reserved.
//

import ARKit
import SceneKit

class Plane: SCNNode
{
    var anchor: ARPlaneAnchor?
    var planeGeometry: SCNPlane?
    
    init(with anchor: ARPlaneAnchor) {
        super.init()
        
        self.anchor = anchor
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.y))
        
        // Instead of just visualizing the grid as a gray plane, we will render
        // it in some Tron style colours.
        let material = SCNMaterial()
        let img = UIImage(named: "tron_grid")
        material.diffuse.contents = img
        self.planeGeometry!.materials = [material]
        
        let planeNode = SCNNode(geometry: planeGeometry!)
        planeNode.position = SCNVector3Make(anchor.center.x, anchor.center.y, anchor.center.z)
        
        // Planes in SceneKit are vertical by default so we need to rotate 90degrees to match
        // planes in ARKit
        planeNode.transform = SCNMatrix4MakeRotation(Float(-.pi / 2.0), 1.0, 0.0, 0.0)
        addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(anchor: ARPlaneAnchor) {
        // As the user moves around the extend and location of the plane
        // may be updated. We need to update our 3D geometry to match the
        // new parameters of the plane.
        self.planeGeometry?.width = CGFloat(anchor.extent.x)
        self.planeGeometry?.height = CGFloat(anchor.extent.z)
        
        // When the plane is first created it's center is 0,0,0 and the nodes
        // transform contains the translation parameters. As the plane is updated
        // the planes translation remains the same but it's center is updated so
        // we need to update the 3D geometry position
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        self.setTextureScale()
    }
    
    func setTextureScale() {
        let width = Float(self.planeGeometry!.width)
        let height = Float(self.planeGeometry!.height)
        
        if let material = self.planeGeometry?.materials.first {
            // As the width/height of the plane updates, we want our tron grid material to
            // cover the entire plane, repeating the texture over and over. Also if the
            // grid is less than 1 unit, we don't want to squash the texture to fit, so
            // scaling updates the texture co-ordinates to crop the texture in that case
            material.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1)
            material.diffuse.wrapS = .repeat
            material.diffuse.wrapT = .repeat
        }
        
    }
}
