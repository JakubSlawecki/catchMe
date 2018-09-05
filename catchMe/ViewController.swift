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
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }
    
    @IBAction func play(_ sender: Any) {
        
    }
    
    @IBAction func reset(_ sender: Any) {
        
    }
    

}



























