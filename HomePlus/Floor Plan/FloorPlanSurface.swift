//
//  FloorPlanSurface.swift
//  HomePlus
//
//  Created by Liam on 2024/10/7.
//

import SpriteKit
import RoomPlan

class FloorPlanSurface: SKNode {
    
    private let capturedSurface: CapturedRoom.Surface
    private let scalingFactor: CGFloat = 200
    private let floorPlanBackgroundColor = UIColor.white
    private let floorPlanSurfaceColor = UIColor.orange
    private let doorZPosition: CGFloat = 20
    private let doorArcZPosition: CGFloat = 21
    private let surfaceWith: CGFloat = 22.0
    private let hideSurfaceWith: CGFloat = 24.0
    private let hideSurfaceZPosition: CGFloat = 1
    private let windowZPosition: CGFloat = 10
    private let windowWidth: CGFloat = 8.0
    private let doorArcWidth: CGFloat = 8.0

    
    private var halfLength: CGFloat {
        CGFloat(capturedSurface.dimensions.x) * scalingFactor / 2
    }
    
    private var pointA: CGPoint {
        return CGPoint(x: -halfLength, y: 0)
    }
    
    private var pointB: CGPoint {
        return CGPoint(x: halfLength, y: 0)
    }
    
    private var pointC: CGPoint {
        return pointB.rotateAround(point: pointA, by: 0.25 * .pi)
    }
    
    init(capturedSurface: CapturedRoom.Surface) {
        self.capturedSurface = capturedSurface
        super.init()
        
        // Set the surface's position using the transform matrix
        let surfacePositionX = -CGFloat(capturedSurface.transform.position.x) * scalingFactor
        let surfacePositionY = CGFloat(capturedSurface.transform.position.z) * scalingFactor
        self.position = CGPoint(x: surfacePositionX, y: surfacePositionY)
        
        // Set the surface's zRotation using the transform matrix
        self.zRotation = -CGFloat(capturedSurface.transform.eulerAngles.z - capturedSurface.transform.eulerAngles.y)
        
        // Draw the right surface
        switch capturedSurface.category {
        case .door:
            drawDoor()
        case .opening:
            drawOpening()
        case .wall:
            drawWall()
        case .window:
            drawWindow()
        case .floor:
            drawWall()
        @unknown default:
            drawWall()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawDoor() {
        let hideWallPath = createPath(from: pointA, to: pointB)
        let doorPath = createPath(from: pointA, to: pointC)

        // Hide the wall underneath the door
        let hideWallShape = createShapeNode(from: hideWallPath)
        hideWallShape.strokeColor = floorPlanBackgroundColor
        hideWallShape.lineWidth = hideSurfaceWith
        hideWallShape.zPosition = hideSurfaceZPosition
        
        // The door itself
        let doorShape = createShapeNode(from: doorPath)
        doorShape.lineCap = .square
        doorShape.zPosition = doorZPosition
        
        // The door's arc
        let doorArcPath = CGMutablePath()
        doorArcPath.addArc(
            center: pointA,
            radius: halfLength * 2,
            startAngle: 0.25 * .pi,
            endAngle: 0,
            clockwise: true
        )
        
        // Create a dashed path
        let dashPattern: [CGFloat] = [24.0, 8.0]
        let dashedArcPath = doorArcPath.copy(dashingWithPhase: 1, lengths: dashPattern)

        let doorArcShape = createShapeNode(from: dashedArcPath)
        doorArcShape.lineWidth = doorArcWidth
        doorArcShape.zPosition = doorArcZPosition
        
        addChild(hideWallShape)
        addChild(doorShape)
        addChild(doorArcShape)
    }
    
    private func drawOpening() {
        let openingPath = createPath(from: pointA, to: pointB)
        
        // Hide the wall underneath the opening
        let hideWallShape = createShapeNode(from: openingPath)
        hideWallShape.strokeColor = floorPlanBackgroundColor
        hideWallShape.lineWidth = hideSurfaceWith
        hideWallShape.zPosition = hideSurfaceZPosition
        
        addChild(hideWallShape)
    }
    
    private func drawWall() {
        let wallPath = createPath(from: pointA, to: pointB)
        let wallShape = createShapeNode(from: wallPath)
        wallShape.lineCap = .square

        addChild(wallShape)
        
        let length = String(format: "%.2f", capturedSurface.dimensions.x)
        addLengthLabel(text: "\(length) m", at: CGPoint(x: 0, y: 16))
    }
    
    private func drawWindow() {
        let windowPath = createPath(from: pointA, to: pointB)
        
        // Hide the wall underneath the window
        let hideWallShape = createShapeNode(from: windowPath)
        hideWallShape.strokeColor = floorPlanBackgroundColor
        hideWallShape.lineWidth = hideSurfaceWith
        hideWallShape.zPosition = hideSurfaceZPosition
        
        // The window itself
        let windowShape = createShapeNode(from: windowPath)
        windowShape.lineWidth = windowWidth
        windowShape.zPosition = windowZPosition
        
        addChild(hideWallShape)
        addChild(windowShape)
    }
    
    // MARK: - Helper functions
    
    private func createPath(from pointA: CGPoint, to pointB: CGPoint) -> CGMutablePath {
        let path = CGMutablePath()
        path.move(to: pointA)
        path.addLine(to: pointB)
        
        return path
    }
    
    private func createShapeNode(from path: CGPath) -> SKShapeNode {
        let shapeNode = SKShapeNode(path: path)
        shapeNode.strokeColor = floorPlanSurfaceColor
        shapeNode.lineWidth = surfaceWith
        
        return shapeNode
    }
    
    private func addLengthLabel(text: String, at position: CGPoint) {
        let label = SKLabelNode(text: text)
        label.fontSize = 32
        label.fontColor = .black
        label.fontName = "Helvetica-Bold"
        label.position = position
        label.zPosition = 10
        
        addChild(label)
    }
}
