import SpriteKit

enum StarType: Int {
    case Normal = 0
    case Special
}

enum PlatformType: Int {
    case Normal = 0
    case Break
}

class GameObjectNode: SKNode {
    
    func collisionWithPlayer(player: SKNode) -> Bool {
        return false
    }
    
    func checkNodeRemoval(playerY: CGFloat) {
        if playerY > self.position.y + 300.0 {
            self.removeFromParent()
        }
    }
}

class StarNode: GameObjectNode {
    let starSound = SKAction.playSoundFileNamed("StarPing.mp3", waitForCompletion: false)
    let winSound = SKAction.playSoundFileNamed("StarPing.mp3", waitForCompletion: false)
    var starType: StarType!
    override func collisionWithPlayer(player thisPlayer: SKNode) -> Bool {
        thisPlayer.physicsBody?.applyImpulse(CGVector(dx: thisPlayer.physicsBody!.velocity.dx, dy: modCoinBoost))
        if starType == .Normal {
            run(starSound, completion: {
                self.removeFromParent()
            })
            return true
        } else {
            run(winSound, completion: {
                self.removeFromParent()
            })
            return true
        }
    }
}
class PlatformNode: GameObjectNode {
    var platformType: PlatformType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        
        // Only bounce the player if he's falling
        if let velocityDeltaY = player.physicsBody?.velocity.dy, velocityDeltaY <= 0.0 {
            
            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: modCloudBoost)
            // Remove if it is a Break type platform
            if platformType == .Break {
                self.removeFromParent()
            }
        }
        if player2 != nil, let secondPlayersDeltaY = player2.physicsBody?.velocity.dy {
            if secondPlayersDeltaY < 0 {
                print("Player2 falling Platform COLLISION")
                player2.physicsBody?.velocity = CGVector(dx: player2.physicsBody!.velocity.dx, dy: modCloudBoost)
                // Remove if it is a Break type platform
                if platformType == .Break {
                    self.removeFromParent()
                }
            }
        }
        return false
    }
    
    
}
