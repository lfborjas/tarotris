//
//  GameViewController.swift
//  Tarotris
//
//  Created by Luis Borjas on 11/23/15.
//  Copyright (c) 2015 Luis Borjas. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var scene: GameScene!
    var tarotris:Tarotris!

    override func viewDidLoad() {
        super.viewDidLoad()

        /* FIXME: added by XCode when creating from Game template
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }*/
        
        // configure the view
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        //create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        scene.tick = didTick
        tarotris = Tarotris()
        tarotris.beginGame()
        
        //present the scene
        skView.presentScene(scene)
        
        scene.addPreviewShapeToScene(tarotris.nextShape!) {
            self.tarotris.nextShape?.moveTo(StartingColumn, row: StartingRow)
            self.scene.movePreviewShape(self.tarotris.nextShape!) {
                let nextShapes = self.tarotris.newShape()
                self.scene.startTicking()
                self.scene.addPreviewShapeToScene(nextShapes.nextShape!){}
            }
        }
    }

    /* FIXME: added by XCode when creating from Game template
    override func shouldAutorotate() -> Bool {
        return true
    }
    */


    /* FIXME: added by XCode when creating from Game template
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }*/

    /* FIXME: added by XCode when creating from Game template
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    */

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func didTick() {
        tarotris.fallingShape?.lowerShapeByOneRow()
        scene.redrawShape(tarotris.fallingShape!, completion: {})
    }
}
