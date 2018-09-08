//
//  ViewController.swift
//  catchMe
//
//  Created by Jakub Slawecki on 05/09/2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func play(_ sender: Any) {
        self.addNode()
        self.play.isEnabled = false
    }
    
    @IBAction func reset(_ sender: Any) {
        
    }
    
    func addNode() {
        let legoPrisonerScene = SCNScene(named: "art.scnassets/LEGO Minifigure_Export for COLLADA 1.4.1 (LOW POLY).scn")
        let legoPrisonerNode = legoPrisonerScene?.rootNode.childNode(withName: "LegoPrisoner", recursively: false)
        legoPrisonerNode?.position = SCNVector3(0, 0, -0.5)
        self.sceneView.scene.rootNode.addChildNode(legoPrisonerNode!)

    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTapped = sender.view as! SCNView
        let touchedCoordinates = sender.location(in: sceneViewTapped)
        let hitTest = sceneViewTapped.hitTest(touchedCoordinates)
        if hitTest.isEmpty {
             print("sceneView tapped")
        } else {
            let result = hitTest.first!
            let node = result.node
            if node.animationKeys.isEmpty {
                self.animateNode(node: node)
            }
        }
       
        
    }
    
    func animateNode(node: SCNNode) {
        let vibrateNode = CABasicAnimation(keyPath: "position")
        vibrateNode.fromValue = node.presentation.position
        vibrateNode.toValue = SCNVector3(node.presentation.position.x - 0.015, node.presentation.position.y - 0.015, node.presentation.position.z + 0.015)
        vibrateNode.duration = 0.02
        vibrateNode.autoreverses = true
        vibrateNode.repeatCount = 6
        node.addAnimation(vibrateNode, forKey: "position")
    }

}



























