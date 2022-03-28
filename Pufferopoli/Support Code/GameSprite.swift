//
//  GameSprite.swift
//  Learn2SpriteKit
//
//  Created by Luigi Minniti on 08/02/22.
//

import SpriteKit

protocol GameSprite {
    var textureAtlas: SKTextureAtlas {get set}
    var initialSize: CGSize {get set}
}
