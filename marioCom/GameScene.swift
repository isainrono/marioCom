//
//  GameScene.swift
//  marioCom
//
//  Created by Isain Rodriguez on 26/03/2019.
//  Copyright © 2019 Isain Rodriguez. All rights reserved.
// https://www.spriters-resource.com/nes/supermariobros/

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var background = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        backGroundImage()
        
        // Get label node from scene and store it for use later
        /*self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }*/
        
        
    }
    
    func backGroundImage() {
        let backGroundImage = SKTexture(imageNamed: "fondob")
        
        let movimientoFondo = SKAction.move(by: CGVector(dx: -backGroundImage.size().width, dy: 0), duration: 25)
        
        let movimientoFondoOrigen = SKAction.move(by: CGVector(dx: backGroundImage.size().width, dy: 0), duration: 0)
        
        // repetimos hasta el infinito
        let movimientoInfinitoFondo = SKAction.repeatForever(SKAction.sequence([movimientoFondo, movimientoFondoOrigen]))
        
        
        var i: CGFloat = 0
        print(self.frame.height)
       
       
        while i < 2 {
            // Le ponemos la textura al fondo
            background = SKSpriteNode(texture: backGroundImage)
             print(background.size.height)
            // Indicamos la posición inicial del fondo
            background.position = CGPoint(x: backGroundImage.size().width * i, y: self.frame.midY)
            
            // Estiramos la altura de la imagen para que se adapte al alto de la pantalla
            background.size.height = self.frame.height
             print(background.size.height)
            // Indicamos zPosition para que quede detrás de todo
            background.zPosition = -1
            
            // Aplicamos la acción
            background.run(movimientoInfinitoFondo)
            // Ponemos el fondo en la escena
            self.addChild(background)
            
            // Incrementamos contador
            i += 1
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
