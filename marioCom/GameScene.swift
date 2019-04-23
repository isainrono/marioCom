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
    var mario = SKSpriteNode()
    var camara = SKCameraNode()
    var left = SKSpriteNode()
    var right = SKSpriteNode()
    var jump = SKSpriteNode()
    var enemy = SKSpriteNode()
    var suelta = false
    
    override func didMove(to view: SKView) {
        
        initGame()
        backGroundImage()
        
    }
    
    func initGame() {
        // start world setthings
        worldModel()
        
        // start player setthings
        marioModel()
        
        // start buttons setthings
        mandoModel()
        
        
        // start enemy setthings
        enemyModel()
        
        
        //add childs To World
        addChildToWorld()
    }
    
    func worldModel() {
        camara = SKCameraNode()
        self.camera = camara
        createGround()
      //  physicsWorld.gravity = CGVector(dx: 0, dy: 0.8)
    }
    
    func marioModel() {
        var textura1 = SKTexture(imageNamed: "mario")
        mario = SKSpriteNode(texture: textura1)
        mario.size = CGSize(width: 25, height: 100)
       // mario.position = CGPoint(x: self.frame.minX + 50, y: self.frame.minY + 160) 
        mario.physicsBody = SKPhysicsBody(circleOfRadius: (textura1.size().height / 2))
       // mario.physicsBody?.affectedByGravity = true
        mario.physicsBody?.isDynamic = true
    }
    
    func mandoModel() {
        var mandoTextura = SKTexture(imageNamed: "mando")
        left = SKSpriteNode(texture: mandoTextura)
        left.size = CGSize(width: 100, height: 400)
        left.position = CGPoint(x: self.frame.minX + 50, y: self.frame.minY + 800)
        left.name = "left"
        
        var rightTexture = SKTexture(imageNamed: "mando")
        right = SKSpriteNode(texture: rightTexture)
        right.size = CGSize(width: 100, height: 400)
        right.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.minY + 800)
        right.name = "right"
        
        var jumpTexture = SKTexture(imageNamed: "mando")
        jump = SKSpriteNode(texture: jumpTexture)
        jump.size = CGSize(width: 50, height: 200)
        jump.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.minY + 500)
        jump.name = "jump"
    }
    
    func enemyModel() {
        var enemytexture = SKTexture(imageNamed: "hongo")
        enemy = SKSpriteNode(texture: enemytexture)
        enemy.size = CGSize(width: 30, height: 80)
        enemy.position = CGPoint(x:self.frame.minX + 400, y: self.frame.minY + 130)
    }
    
    func backGroundImage() {
        let backGroundImage = SKTexture(imageNamed: "fondob")
        
        let movimientoFondo = SKAction.move(by: CGVector(dx: -backGroundImage.size().width, dy: 0), duration: 25)
        
        let movimientoFondoOrigen = SKAction.move(by: CGVector(dx: backGroundImage.size().width, dy: 0), duration: 0)
        
        // repetimos hasta el infinito
        let movimientoInfinitoFondo = SKAction.repeatForever(SKAction.sequence([movimientoFondo, movimientoFondoOrigen]))
        
        
        var i: CGFloat = 0
        print(self.frame.height)
       
       
        while i < 1 {
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
            //background.run(movimientoInfinitoFondo)
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
        move(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        move(touches)
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("suelta")
     
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    
    // actions functions
    func move (_ touches: Set<UITouch>) {
  
        for t in touches {
            let toque = t.location(in: self)
            let nodosDondeTocas = self.nodes(at: toque)
            if(nodosDondeTocas.count > 0) {
                let nodoActual = nodosDondeTocas[0]
                if(nodoActual.name == "right") {
                    mario.position.x = mario.position.x + 20
                    if (mario.position.x > 0) {
                        jump.position.x = jump.position.x + 20
                        left.position.x = left.position.x + 20
                        right.position.x = right.position.x + 20
                        camara.position.x = camara.position.x + 20
                    }
                } else if(nodoActual.name == "left"){
                    mario.position.x = mario.position.x - 20
                    if (mario.position.x > 0) {
                        jump.position.x = jump.position.x - 20
                        right.position.x = right.position.x - 20
                        left.position.x = left.position.x - 20
                        camara.position.x = camara.position.x - 20
                    }
                } else if(nodoActual.name == "jump") {
                    //mario.physicsBody?.affectedByGravity = true
                    //mario.physicsBody?.velocity = CGVector(dx: 0, dy: 0.9)
                    //mario.position.y = mario.position.y + 20
                    mario.physicsBody?.isDynamic = true
                    //mario.physicsBody?.velocity = CGVector(dx: 0, dy: 500)
                    mario.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 5000))
                    print("i")
                }
                
            }
        }
    }
    
    func addChildToWorld() {
        self.addChild(mario)
        self.addChild(enemy)
        self.addChild(left)
        self.addChild(right)
        self.addChild(jump)
    }
    
    func createGround(){
        /*let suelo = SKNode()
        suelo.position = CGPoint(x: -self.frame.midX, y: -self.frame.height / 2)
        suelo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        // el suelo se tiene que estar quieto
        suelo.physicsBody!.isDynamic = false
        
        // Categoría para collision
        suelo.physicsBody!.categoryBitMask = tipoNodo.tuboSuelo.rawValue
        // Colisiona con la mosquita
        suelo.physicsBody!.collisionBitMask = tipoNodo.mosquita.rawValue
        // contacto con el suelo
        suelo.physicsBody!.contactTestBitMask = tipoNodo.mosquita.rawValue
        
        self.addChild(suelo)*/
        
        
        let ground = SKNode()
        ground.position = CGPoint(x: -self.frame.midX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody!.isDynamic = false
        self.addChild(ground)
    }

    
    
    
    
}
