//
//  GameScene.swift
//  marioCom
//
//  Created by Isain Rodriguez on 26/03/2019.
//  Copyright © 2019 Isain Rodriguez. All rights reserved.
// https://www.spriters-resource.com/nes/supermariobros/

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate{
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var background = SKSpriteNode()
    //var mario = SKSpriteNode()
    var camara = SKCameraNode()
    var left = SKSpriteNode()
    var right = SKSpriteNode()
    var jump = SKSpriteNode()
    var enemy = SKSpriteNode()
    var suelta = false
    var jumpi = false
    
    var bola = SKSpriteNode()
    
    var life = SKLabelNode()
    
    var countLife:Int = 3
    
    var gameOver = SKLabelNode()
    
    var lifeText = SKLabelNode()
    
    var score = SKLabelNode()
    var countCoins:Int = 0
    var coin = SKSpriteNode()
    var coinSound = SKAction.playSoundFileNamed("coinsound.mp3", waitForCompletion: false)
    var coinsInGame:Int = 30
    
    // Textura de moneda
    var texturaCoin1 = SKTexture(imageNamed: "coin1")
    var texturaCoin2 = SKTexture(imageNamed: "coin2")
    var texturaCoin3 = SKTexture(imageNamed: "coin3")
    
    
    
    // Textura de bola
    var texturaBola4 = SKTexture(imageNamed: "bola4")
    var texturaBola5 = SKTexture(imageNamed: "bola5")
    var texturaBola6 = SKTexture(imageNamed: "bola6")
    var texturaBola7 = SKTexture(imageNamed: "bola7")
    
   // Boton reinicio
    var reini = SKSpriteNode()
  
    
    
    enum tipoNodo: UInt32 {
        case suelo = 2
        case mario = 4
        case enemy = 6
        case coin = 8
        case bola = 10
    }
    
    override func didMove(to view: SKView) {
        
        initGame()
        backGroundImage()
        
    }
    
    
    
    func initGame() {
    
        self.physicsWorld.contactDelegate = self
        // start world setthings
        worldModel()
        // show information
        showInformation()
        //start bola
        bolaModel()
        // start player setthings
        //marioModel()
        // start buttons setthings
        mandoModel()
        // start enemy setthings
        enemyModel()
        // start wall in game
        wallModel()
        // start Coins
        coinModel()
        // show score
        showScore()
        // show life
        showLife()
        // create All Enemies
        createEnemies()
        // cretae all Coins
        createCoins()
        // show GameOver
        showGameOver()
        
        // reiniico Game
        reIniGame()
        //add childs To World
        addChildToWorld()
    }
    
    func worldModel() {
        camara = SKCameraNode()
        self.camera = camara
        createGround()
        //physicsWorld.gravity = CGVector(dx: 0, dy: 0.8)
    }
    
    func showInformation() {
        
    }
    
    
    func createCoins() {
        let xposition:Int = 200
        
        for n in 1...coinsInGame {
            print(n)
            let randomInt2 = Int.random(in: 50..<400)
            var anotherCoin = SKSpriteNode()

            anotherCoin = SKSpriteNode(texture: self.texturaCoin1)
            anotherCoin.size = CGSize(width: 50, height: 50)
            anotherCoin.position = CGPoint(x: xposition * n + 30, y: -randomInt2)
            anotherCoin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
            anotherCoin.physicsBody?.isDynamic = false
            anotherCoin.physicsBody?.mass = 1
            anotherCoin.zPosition = 1
            anotherCoin.physicsBody?.categoryBitMask = tipoNodo.coin.rawValue
            anotherCoin.physicsBody?.collisionBitMask = tipoNodo.suelo.rawValue | tipoNodo.mario.rawValue
            
            anotherCoin.physicsBody!.contactTestBitMask = tipoNodo.suelo.rawValue
            
            let animation = SKAction.animate(with: [self.texturaCoin1, self.texturaCoin2, self.texturaCoin3], timePerFrame: 0.1)
            
            let animacionInfinita = SKAction.repeatForever(animation)
            anotherCoin.run(animacionInfinita)
            
            self.addChild(anotherCoin)
        }
    }
    
    
    func createEnemies() {
        let xposition:Int = 500
        
        for n in 4 ... 15 {
            
            
            print("crea\(n)")
            var anotherEnemy = SKSpriteNode()
            let enemytexture = SKTexture(imageNamed: "hongo")
            anotherEnemy = SKSpriteNode(texture: enemytexture)
            anotherEnemy.size = CGSize(width: 50, height: 50)
            anotherEnemy.position = CGPoint(x: (xposition * n), y: 0)
            anotherEnemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
            anotherEnemy.physicsBody?.isDynamic = true
            anotherEnemy.physicsBody?.mass = 1
            anotherEnemy.zPosition = 1
            anotherEnemy.physicsBody?.categoryBitMask = tipoNodo.enemy.rawValue
            anotherEnemy.physicsBody?.collisionBitMask = tipoNodo.suelo.rawValue | tipoNodo.mario.rawValue
            
            anotherEnemy.physicsBody!.contactTestBitMask = tipoNodo.suelo.rawValue
            self.addChild(anotherEnemy)
        }
        
       
        
    }
    
    func showLife() {
        lifeText.fontName = "Arial"
        lifeText.fontSize = 30
        lifeText.text = String("Vidas : \(self.countLife)")
        lifeText.position = CGPoint(x: self.frame.midX - 270, y: self.frame.midY + 360)
        print(self.frame.midX)
        lifeText.zPosition = 1
        self.addChild(lifeText)
    }
    
    func showScore() {
        score.fontName = "Arial"
        score.fontSize = 30
        score.text = String("Monedas : \(self.countCoins)")
        score.position = CGPoint(x: self.frame.midX + 230, y: self.frame.midY + 300)
        score.zPosition = 1
        self.addChild(score)
    }
    
    func showGameOver() {
        gameOver.fontName = "Arial"
        gameOver.fontSize = 80
        gameOver.text = "GAME OVER"
        gameOver.position = CGPoint(x: 0, y: 0)
        gameOver.zPosition = 1
        gameOver.isHidden = true
        self.addChild(self.gameOver)
        
    }
    
    /*func marioModel() {
        var textura1 = SKTexture(imageNamed: "mario")
        mario = SKSpriteNode(texture: textura1)
        mario.size = CGSize(width: 50, height: 50)
        mario.position = CGPoint(x:-100, y: 0)
        //mario.physicsBody = SKPhysicsBody(circleOfRadius: (textura1.size().height / 2))
       // mario.physicsBody?.affectedByGravity = true
        mario.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        //mario.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(exactly: 50)!)
        mario.physicsBody?.isDynamic = true
        mario.physicsBody?.mass = 30
        mario.zPosition = 1
        mario.physicsBody?.categoryBitMask = tipoNodo.mario.rawValue
        mario.physicsBody?.collisionBitMask = tipoNodo.suelo.rawValue | tipoNodo.enemy.rawValue | tipoNodo.coin.rawValue
        // Hace contacto con (para que nos avise)
        mario.physicsBody!.contactTestBitMask = tipoNodo.suelo.rawValue | tipoNodo.coin.rawValue | tipoNodo.enemy.rawValue
    }*/
    
    func bolaModel() {
        /*var texturaBola4 = SKTexture(imageNamed: "bola4")
        var texturaBola5 = SKTexture(imageNamed: "bola5")
        var texturaBola6 = SKTexture(imageNamed: "bola6")
        var texturaBola7 = SKTexture(imageNamed: "bola7")
        
        let animation = SKAction.animate(with: [texturaBola4, texturaBola5, texturaBola6, texturaBola7], timePerFrame: 0.2)
        
        let animacionInfinita = SKAction.repeatForever(animation)*/
        
        bola = SKSpriteNode(texture: texturaBola4)
        bola.position = CGPoint(x: -200, y: 0)
        bola.physicsBody =  SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        bola.physicsBody?.isDynamic = true
        
        bola.physicsBody?.mass = 30
        bola.size = CGSize(width: 50, height: 50)
        bola.physicsBody!.categoryBitMask = tipoNodo.bola.rawValue
        bola.physicsBody!.collisionBitMask = tipoNodo.suelo.rawValue | tipoNodo.enemy.rawValue | tipoNodo.coin.rawValue
        bola.physicsBody!.contactTestBitMask = tipoNodo.suelo.rawValue | tipoNodo.enemy.rawValue
        
        //bola.run(animacionInfinita)
        bola.zPosition = 1
        self.addChild(bola)
    }
    

    func mandoModel() {
        var mandoTextura = SKTexture(imageNamed: "mando")
        left = SKSpriteNode(texture: mandoTextura)
        left.size = CGSize(width: 40, height: 320)
        left.position = CGPoint(x: self.frame.minX + 50, y: self.frame.minY + 400)
        left.name = "left"
        
        var rightTexture = SKTexture(imageNamed: "mando")
        right = SKSpriteNode(texture: rightTexture)
        right.size = CGSize(width: 40, height: 320)
        right.position = CGPoint(x: self.frame.minX + 100, y: self.frame.minY + 400)
        right.name = "right"
        
        var jumpTexture = SKTexture(imageNamed: "mando")
        jump = SKSpriteNode(texture: jumpTexture)
        jump.size = CGSize(width: 50, height: 200)
        jump.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.minY + 500)
        jump.name = "jump"
    }
    
    func reIniGame() {
        var iniTextura = SKTexture(imageNamed: "mando")
        reini = SKSpriteNode(texture: iniTextura)
        reini.size = CGSize(width: 40, height: 320)
        reini.position = CGPoint(x: 0, y: 20)
        reini.name = "reini"
        reini.isHidden = true
        
        self.addChild(reini)
    }
    
    func backGroundImage() {
        let backGroundImage = SKTexture.init()
        
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
        print("tocado")
        let animation = SKAction.animate(with: [self.texturaBola4, self.texturaBola5, self.texturaBola6, self.texturaBola7], timePerFrame: 0.1)
        
        let animacionInfinita = SKAction.repeatForever(animation)
        bola.run(animacionInfinita)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        move(touches)
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("suelta")
        bola.removeAllActions()
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
                    //reini.isHidden = false
                    bola.position.x = bola.position.x + 5
                    if (bola.position.x > 0) {
                        jump.position.x = jump.position.x + 5
                        left.position.x = left.position.x + 5
                        right.position.x = right.position.x + 5
                        camara.position.x = camara.position.x + 5
                        lifeText.position.x = lifeText.position.x + 5
                        score.position.x = score.position.x + 5
                        gameOver.position.x = gameOver.position.x + 5
                        //bola.position.x = bola.position.x + 5

                    }
                } else if(nodoActual.name == "left"){
                    bola.position.x = bola.position.x - 5
                    if (bola.position.x > 0) {
                        jump.position.x = jump.position.x - 5
                        right.position.x = right.position.x - 5
                        left.position.x = left.position.x - 5
                        camara.position.x = camara.position.x - 5
                        lifeText.position.x = lifeText.position.x - 5
                        score.position.x = score.position.x - 5
                        gameOver.position.x = gameOver.position.x - 5
                        //bola.position.x = bola.position.x - 5
                        
                    }
                } else if(nodoActual.name == "jump") {
                    //mario.physicsBody?.affectedByGravity = true
                    //mario.physicsBody?.velocity = CGVector(dx: 0, dy: 0.9)
                    //mario.position.y = mario.position.y + 20
                    print(bola.position.x)
                    print("mando derecho \(right.position.x)")
                    print("mando izquierdo \(left.position.x)")
                    if self.jumpi == true {
                        print("esta saltando")
                        print(self.jumpi)
                        /*mario.physicsBody?.isDynamic = true
                        mario.physicsBody?.velocity = CGVector(dx: 0, dy: 10)
                        mario.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 29000))*/
                        
                        bola.physicsBody?.velocity = CGVector(dx: 0, dy: 10)
                        bola.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 29000))
                        self.jumpi = false
                    }
 

                    print("i")
                } else if (nodoActual.name == "reini") {
                    let pauseAction = SKAction.run {
                        self.view?.isPaused = false
                    }
                    self.run(pauseAction)
                    self.countLife = 3
                }
                
            }
        }
    }
    
    func addChildToWorld() {
        //self.addChild(mario)
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
        
        let suelo = SKSpriteNode(color:.red, size: CGSize(width: 15000, height: 20))
        suelo.position = CGPoint(x: -200, y: -550)
        suelo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 15000, height: 20))
        suelo.physicsBody?.isDynamic = true
        suelo.physicsBody?.mass = 1000000
        suelo.physicsBody?.categoryBitMask = tipoNodo.suelo.rawValue
        suelo.physicsBody?.collisionBitMask = tipoNodo.mario.rawValue
        suelo.physicsBody?.collisionBitMask = tipoNodo.enemy.rawValue
        suelo.physicsBody?.affectedByGravity = false
        suelo.zPosition = 1
        
        self.addChild(suelo)
        /*
        let ground = SKNode()
        ground.position = CGPoint(x: -self.frame.midX, y: self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody!.isDynamic = false
        self.addChild(ground)*/
    }
    
    func wallModel() {
        
        for n in 5...40 {
            let randomInt = Int.random(in: 100..<10000)
            let randomInt2 = Int.random(in: 50..<350)
            
            let suelo2 = SKSpriteNode(color:.blue, size: CGSize(width: 100, height: 20))
            
            if (randomInt2 < 100) {
                suelo2.position = CGPoint(x: randomInt, y: randomInt2)
            } else {
                suelo2.position = CGPoint(x: randomInt, y: -randomInt2)
            }
            
            suelo2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 20))
            suelo2.physicsBody?.isDynamic = false
            suelo2.physicsBody?.mass = 1000000
            suelo2.physicsBody?.categoryBitMask = tipoNodo.suelo.rawValue
            suelo2.physicsBody?.collisionBitMask = tipoNodo.mario.rawValue
            suelo2.physicsBody?.affectedByGravity = false
            
            self.addChild(suelo2)
        }
        
        
    }
    
    func enemyModel() {
        // hacer el remove from parent
        print("entra aqui ")
        let enemytexture = SKTexture(imageNamed: "hongo")
         enemy = SKSpriteNode(texture: enemytexture)
         enemy.size = CGSize(width: 50, height: 50)
         enemy.position = CGPoint(x: 0, y: 0)
         enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
         enemy.physicsBody?.isDynamic = true
         enemy.physicsBody?.mass = 1
         enemy.zPosition = 1
         enemy.physicsBody?.categoryBitMask = tipoNodo.enemy.rawValue
         enemy.physicsBody?.collisionBitMask = tipoNodo.suelo.rawValue | tipoNodo.mario.rawValue
        
         enemy.physicsBody!.contactTestBitMask = tipoNodo.suelo.rawValue
    }
    
    func coinModel() {
        print("entra en coin")
        let coinTesture = SKTexture(imageNamed: "coin")
        
        coin = SKSpriteNode(texture: coinTesture)
        coin.size = CGSize(width: 50, height: 50)
        coin.position = CGPoint(x: 80, y: -70)
        coin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.mass = 1
        coin.zPosition = 1
        coin.physicsBody?.categoryBitMask = tipoNodo.coin.rawValue
        coin.physicsBody?.collisionBitMask = tipoNodo.suelo.rawValue | tipoNodo.mario.rawValue
        
        coin.physicsBody!.contactTestBitMask = tipoNodo.suelo.rawValue
        
        self.addChild(coin)
        
    }
    
    func playSound(sound : SKAction)
    {
        run(sound)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        // en contact tenemos bodyA y bodyB que son los cuerpos que hicieron contacto
        let cuerpoA = contact.bodyA
        let cuerpoB = contact.bodyB
        
        // Miramos si la mosca ha pasado por el hueco
        if (cuerpoA.categoryBitMask == tipoNodo.bola.rawValue && cuerpoB.categoryBitMask == tipoNodo.suelo.rawValue) || (cuerpoA.categoryBitMask == tipoNodo.suelo.rawValue && cuerpoB.categoryBitMask == tipoNodo.bola.rawValue) {
            self.jumpi = true
            print("hace contacto con suelo")
            print(bola.frame.minX)
            print(left.frame.minX)
            if bola.frame.minX < left.frame.minX  || bola.frame.maxX > jump.frame.maxX{
                print("salio de pantalla")
                if cuerpoB.categoryBitMask == tipoNodo.bola.rawValue{
                    //contact.bodyB.node?.removeFromParent()
                    bola.position.x = left.frame.minX + 100
                    //bolaModel()
                } else if cuerpoA.categoryBitMask == tipoNodo.bola.rawValue {
                    //contact.bodyA.node?.removeFromParent()
                    //bolaModel()
                    bola.position.x = left.frame.minX + 100
                }
                
                
            }

//            puntuacion += 1
//            labelPuntuacion.text = String(puntuacion)
        } else {
            
            // si no pasa por el hueco es porque ha tocado el suelo o una tubería
            // deberemos acabar el juego
//            gameOver = true
//            // Frenamos todo
//            self.speed = 0
//            // Paramos el timer
//            timer.invalidate()
//            labelPuntuacion.text = "Game Over"
        }
        
        if (cuerpoA.categoryBitMask == tipoNodo.bola.rawValue && cuerpoB.categoryBitMask == tipoNodo.enemy.rawValue) || (cuerpoA.categoryBitMask == tipoNodo.enemy.rawValue && cuerpoB.categoryBitMask == tipoNodo.bola.rawValue) {
            print("hace contacto con enemy")
            
            if(cuerpoB.categoryBitMask == tipoNodo.enemy.rawValue) {
                contact.bodyB.node?.removeFromParent()
                
            } else if (cuerpoA.categoryBitMask == tipoNodo.enemy.rawValue){
                contact.bodyA.node?.removeFromParent()
                
            }
            
            
            if self.countLife > 0 {
                self.countLife = self.countLife - 1
                lifeText.text = String("Vidas : \(self.countLife)")
                if self.countLife == 0{
                    print("game over ------------------------------")
                    // por preguntar !!!!!
                    self.reini.isHidden = false
                    self.gameOver.isHidden = false
                    
                    
                    let pauseAction = SKAction.run {
                        self.view?.isPaused = true
                    }
                    self.run(pauseAction)
                    
                   
                }
            }
            
        }
        
        if (cuerpoA.categoryBitMask == tipoNodo.bola.rawValue && cuerpoB.categoryBitMask == tipoNodo.coin.rawValue) || (cuerpoA.categoryBitMask == tipoNodo.coin.rawValue && cuerpoB.categoryBitMask == tipoNodo.bola.rawValue) {
            print("contacto con una moneda")
            self.countCoins = countCoins + 1
            self.score.text = String("Monedas : \( self.countCoins)")
            playSound(sound: coinSound)
            
            if self.countCoins >= coinsInGame / 2 {
                gameOver.text = "CONGRATULATIONS"
                gameOver.fontSize = 40
                gameOver.isHidden = false
            }
            
            if cuerpoB.categoryBitMask == tipoNodo.coin.rawValue {
                contact.bodyB.node?.removeFromParent()
            } else if cuerpoA.categoryBitMask == tipoNodo.coin.rawValue {
                contact.bodyA.node?.removeFromParent()
            }
        }
        
    }

    
    
    
    
}
