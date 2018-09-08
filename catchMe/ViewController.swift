//
//  ViewController.swift
//  catchMe
//
//  Created by Jakub Slawecki on 05/09/2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit
import ARKit
import Each

class ViewController: UIViewController {
    
    var timer = Each(1).seconds
    var countdown = 10
    @IBOutlet weak var policemanTimer: UILabel!
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
        self.setTimerCountdown()
        self.addNode()
        self.play.isEnabled = false
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        self.timer.stop()
        self.resetCountdown()
        self.play.isEnabled = true
    }
    
    func addNode() {
        let legoPrisonerScene = SCNScene(named: "art.scnassets/LEGO Minifigure_Export for COLLADA 1.4.1 (LOW POLY).scn")
        let legoPrisonerNode = legoPrisonerScene?.rootNode.childNode(withName: "LegoPrisoner", recursively: false)
        legoPrisonerNode?.position = SCNVector3(randomNumbers(firstNum: -1, secondNum: 1), randomNumbers(firstNum: -0.5, secondNum: 0.5), randomNumbers(firstNum: -1, secondNum: 1))
        self.sceneView.scene.rootNode.addChildNode(legoPrisonerNode!)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTapped = sender.view as! SCNView
        let touchedCoordinates = sender.location(in: sceneViewTapped)
        let hitTest = sceneViewTapped.hitTest(touchedCoordinates)
        if hitTest.isEmpty {
             print("sceneView tapped")
        } else {
            if countdown > 0 {
                let result = hitTest.first!
                let node = result.node
                if node.animationKeys.isEmpty {
                    SCNTransaction.begin()                  //that will make sure that animation will be completed before node ll be removed
                    self.animateNode(node: node)
                    SCNTransaction.completionBlock = {
                        node.removeFromParentNode()
                        self.addNode()
                        self.resetCountdown()
                    }
                    SCNTransaction.commit()
                }
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
    
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func setTimerCountdown() {
        self.timer.perform { () -> NextStep in
            self.countdown -= 1
            self.policemanTimer.text = String(self.countdown)
            if self.countdown == 0 {
                self.policemanTimer.text = "You lose"
                return .stop
            }
            return .continue
        }
    }
    
    func resetCountdown() {
        self.countdown = 10
        self.policemanTimer.text = String(self.countdown)
    }

}



























