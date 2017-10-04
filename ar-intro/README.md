# Intro to [ARKit](https://developer.apple.com/documentation/arkit)

## Tools
- ARKit
- SceneKit

## Core Classes

**ARSCNView**:
The `ARSCNView` class provides the easiest way to create augmented reality experiences that blend virtual 3D content with a device camera view of the real world. When you run the view's provided ARSession object:
The view automatically renders the live video feed from the device camera as the scene background.
The world coordinate system of the view's SceneKit scene directly responds to the AR world coordinate system established by the session configuration.
The view automatically moves its SceneKit camera to match the real-world movement of the device.
Because ARKit automatically matches SceneKit space to the real world, placing a virtual object such that it appears to maintain a real-world position requires only setting that object's SceneKit position appropriately.

**ARSession**:
A shared object that manages the device camera and motion processing needed for augmented reality experiences.
An ARSession object coordinates the major processes that ARKit performs on your behalf to create an augmented reality experience. These processes include reading data from the device's motion sensing hardware, controlling the device's built-in camera, and performing image analysis on captured camera images. The session synthesizes all of these results to establish a correspondence between the real-world space the device inhabits and a virtual space where you model AR content.
Every AR experience built with ARKit requires a single ARSession object. If you use an ARSCNView or ARSKView object to easily build the visual part of your AR experience, the view object includes an ARSession instance. If you build your own renderer for AR content, you'll need to instantiate and maintain an ARSession object yourself.

**ARWorldTrackingConfiguration**:
A configuration that uses the rear-facing camera, tracks a device's orientation and position, and detects real-world flat surfaces.
All AR configurations establish a correspondence between the real world the device inhabits and a virtual 3D coordinate space where you can model content. When your app displays that content together with a live camera image, the user experiences the illusion that your virtual content is part of the real world.
Creating and maintaining this correspondence between spaces requires tracking the device's motion. The ARWorldTrackingConfiguration class tracks the device's movement with six degrees of freedom (6DOF): specifically, the three rotation axes (roll, pitch, and yaw), and three translation axes (movement in x, y, and z).

## Initializing the Session

Inside the `viewWillAppear()` method, we'll initialize the `ARSession` instance:

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()

    // Run the view's session
    sceneView.session.run(configuration)
}
```

We'll load a predefined scene from our `art.scnassets` folder and add a cube to it. In the `viewDidLoad()` method:

```swift
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
        let boxNode = SCNNode(geometry: boxGeometry)
        
        // Position it as desired
        boxNode.position = SCNVector3Make(0, 1, -0.5)
        
        // Attach to scene's root node
        scene.rootNode.addChildNode(boxNode)
        
        // Adds default lighting to scene
        sceneView.autoenablesDefaultLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene
}
```

## Animation

![ARKit Coordinate System](img/coordinate-system.png)

Note that all units are in meters! We should now see a plane (as defined in our scene assets), and a cube above it. Let's try animating the cube by rotating it.

To do this, we need to subscribe to the `SCNSceneRendererDelegate` in the `ViewController` definition:

```swift
class ViewController: UIViewController, ARSCNViewDelegate, SCNSceneRendererDelegate { ...
```

And define the delegate method (the main render loop) inside our controller:

```swift
func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    let rotValue = Float(time).truncatingRemainder(dividingBy: Float.pi)
    boxNode.rotation = SCNVector4Make(rotValue, 1.0, 1.0, Float.pi)
}
```

## Plane Detection & Visualization

We will now extract 3D geometry from the real world and visualize it. The first step to getting a geometrical understanding of the world via the camera input is to detect horizontal planes. Once we detect it, we can visualize it to show the scale and orientation of the plane.