//
//  GameViewController.swift
//  Tarotris
//
//  Created by Luis Borjas on 11/23/15.
//  Copyright (c) 2015 Luis Borjas. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, TarotrisDelegate, UIGestureRecognizerDelegate {
    
    var scene: GameScene!
    var tarotris:Tarotris!
    
    var panPointReference:CGPoint?

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
        tarotris.delegate = self
        tarotris.beginGame()
        
        //present the scene
        skView.presentScene(scene)
        
        /*
        scene.addPreviewShapeToScene(tarotris.nextShape!) {
            self.tarotris.nextShape?.moveTo(StartingColumn, row: StartingRow)
            self.scene.movePreviewShape(self.tarotris.nextShape!) {
                let nextShapes = self.tarotris.newShape()
                self.scene.startTicking()
                self.scene.addPreviewShapeToScene(nextShapes.nextShape!){}
            }
        }
        */
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
        tarotris.letShapeFall()
    }
   
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        tarotris.rotateShape()
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        tarotris.dropShape()
    }
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        let currentPoint = sender.translationInView(self.view)
        if let originalPoint = panPointReference {
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                if sender.velocityInView(self.view).x > CGFloat(0) {
                    tarotris.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    tarotris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .Began {
            panPointReference = currentPoint
        }
    }
    
    /*
      GameViewController will implement an optional delegate method found in UIGestureRecognizerDelegate which will allow each gesture recognizer to work in tandem with the others. At times, a gesture recognizer may collide with another.
    */
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /*
     Sometimes when swiping down, a pan gesture may occur simultaneously with a swipe gesture. In order for these recognizers to relinquish priority, we will implement another optional delegate method. The code performs is conditionals. These conditionals check whether the generic UIGestureRecognizer parameters is of the specific types of recognizers we expect to see. If the check succeeds, we execute the code block.
    */
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        
        return false
    }
    
    func nextShape() {
        let newShapes = tarotris.newShape()
        guard let fallingShape = newShapes.fallingShape else {
            return
        }
        self.scene.addPreviewShapeToScene(newShapes.nextShape!){}
        self.scene.movePreviewShape(fallingShape){
            self.view.userInteractionEnabled = true
            self.scene.startTicking()
        }
    }
    
    func gameDidBegin(tarotris: Tarotris) {
        if tarotris.nextShape != nil && tarotris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(tarotris.nextShape!){
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(tarotris: Tarotris) {
        view.userInteractionEnabled = false
        scene.stopTicking()
    }
    
    func gameDidLevelUp(tarotris: Tarotris) {
        
    }
    
    func gameShapeDidDrop(tarotris: Tarotris) {
        scene.stopTicking()
        scene.redrawShape(tarotris.fallingShape!) {
            tarotris.letShapeFall()
        }
        
    }
    
    func gameShapeDidLand(tarotris: Tarotris) {
        scene.stopTicking()
        nextShape()
    }
    
    func gameShapeDidMove(tarotris: Tarotris) {
        scene.redrawShape(tarotris.fallingShape!){}
    }
}
