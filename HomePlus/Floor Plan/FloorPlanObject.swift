//
//  FloorPlanObject.swift
//  HomePlus
//
//  Created by Liam on 2024/10/8.
//

import SpriteKit
import RoomPlan

class FloorPlanObject: SKNode {
    
    private let capturedObject: CapturedRoom.Object
    private let objectZPosition: CGFloat = 30
    private let objectOutlineZPosition: CGFloat = 31
    private let objectOutlineWidth: CGFloat = 8.0
    
    init(capturedObject: CapturedRoom.Object) {
        self.capturedObject = capturedObject
        
        super.init()
        
        // Set the object's position using the transform matrix
        let objectPositionX = -CGFloat(capturedObject.transform.position.x) * Utilities.scalingFactor
        let objectPositionY = CGFloat(capturedObject.transform.position.z) * Utilities.scalingFactor
        self.position = CGPoint(x: objectPositionX, y: objectPositionY)
        
        // Set the object's zRotation using the transform matrix
        self.zRotation = -CGFloat(capturedObject.transform.eulerAngles.z - capturedObject.transform.eulerAngles.y)
        
        drawObject()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawObject() {
        // Calculate the object's dimensions
        let objectWidth = CGFloat(capturedObject.dimensions.x) * Utilities.scalingFactor
        let objectHeight = CGFloat(capturedObject.dimensions.z) * Utilities.scalingFactor
        
        // Create the object's rectangle
        let objectRect = CGRect(
            x: -objectWidth / 2,
            y: -objectHeight / 2,
            width: objectWidth,
            height: objectHeight
        )
        
        // A shape to fill the object
        let objectShape = SKShapeNode(rect: objectRect)
        objectShape.strokeColor = .clear
        objectShape.fillColor = Utilities.floorPlanSurfaceColor
        objectShape.alpha = 0.3
        objectShape.zPosition = objectZPosition
        
        // And another shape for the outline
        let objectOutlineShape = SKShapeNode(rect: objectRect)
        objectOutlineShape.strokeColor = Utilities.floorPlanSurfaceColor
        objectOutlineShape.lineWidth = objectOutlineWidth
        objectOutlineShape.lineJoin = .miter
        objectOutlineShape.zPosition = objectOutlineZPosition
                
        // Add both shapes to the node
        addChild(objectShape)
        addChild(objectOutlineShape)
    }
    
}
