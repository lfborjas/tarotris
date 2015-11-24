//
//  GameScene.swift
//  Tarotris
//
//  Created by Luis Borjas on 11/23/15.
//  Copyright (c) 2015 Luis Borjas. All rights reserved.
//

import SpriteKit


// slowest speed at which shapes will travel: every 600 ms
// the shape will descend one row
let TickLengthLevelOne = NSTimeInterval(600)

class GameScene: SKScene {
    
    //optional closure that takes no parameters and returns nothing
    var tick:(() -> ())?
    var tickLengthMillis = TickLengthLevelOne
    var lastTick:NSDate?
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0, y: 1.0)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x:0, y:0)
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        addChild(background)
    }
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here
        //FIXME: this was added by XCode when generating the game
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 45;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));

        self.addChild(myLabel)
        */
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins
        //FIXME: this was added by XCode when generating the game

        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)

        }*/
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        // if lastTick is nil, the game is paused and not
        // reporting ticks, so nothing to do
        guard let lastTick = lastTick else {
            return
        }
        
        // times -1000 to get a *positive* ms value
        let timePassed = lastTick.timeIntervalSinceNow * -1000.0
        if timePassed > tickLengthMillis {
            self.lastTick = NSDate()
            //shorthand for checking if tick is present and calling it if so
            tick?()
        }
    }
    
    // these functions allow other classes to manipulate tickint
    // that way we can pause it in key moments
    
    func startTicking(){
        lastTick = NSDate()
    }
    
    func stopTicking(){
        lastTick = nil
    }
}
