//
//  FloorPlanScene.swift
//  HomePlus
//
//  Created by Liam on 2024/10/7.
//

import RoomPlan
import SpriteKit

class FloorPlanScene: SKScene {
    
    // Surfaces and objects from our scan result
    private let surfaces: [CapturedRoom.Surface]
    private let objects: [CapturedRoom.Object]
    
    private var previousCameraRotation = CGFloat()
    private let floorPlanBackgroundColor = UIColor.white
    
    // MARK: - Init
    
    init(capturedRoom: CapturedRoom) {
        self.surfaces = capturedRoom.doors + capturedRoom.openings + capturedRoom.walls + capturedRoom.windows
        self.objects = capturedRoom.objects
        
        super.init(size: CGSize(width: 1500, height: 1500))
        
        self.scaleMode = .aspectFill
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = floorPlanBackgroundColor
        
        addCamera()
        
        drawSurfaces()
//        drawObjects()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer()
        pinchGestureRecognizer.addTarget(self, action: #selector(pinchGestureAction(_:)))
        view.addGestureRecognizer(pinchGestureRecognizer)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotationGestureAction(_:)))
        view.addGestureRecognizer(rotationGestureRecognizer)
    }
    
    public func captureScene() {
        if let skView = self.view {
            let snapshot = skView.texture(from: self)?.cgImage()
            if let snapshot = snapshot {
                let image = UIImage(cgImage: snapshot)
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
    }
    
    private func drawSurfaces() {
        for surface in surfaces {
            let surfaceNode = FloorPlanSurface(capturedSurface: surface)
            addChild(surfaceNode)
        }
    }
    
    private func drawObjects() {
        for object in objects {
            let objectNode = FloorPlanObject(capturedObject: object)
            addChild(objectNode)
        }
    }
    
    private func addCamera() {
        let cameraNode = SKCameraNode()
        addChild(cameraNode)
        
        self.camera = cameraNode
    }
    
    // Variables that store camera scale and position at the start of a gesture
    private var previousCameraScale = CGFloat()
    private var previousCameraPosition = CGPoint()
    
    // Pan gestures only handle camera movement in this scene
    @objc private func panGestureAction(_ sender: UIPanGestureRecognizer) {
        guard let camera = self.camera else { return }
        
        if sender.state == .began {
            previousCameraPosition = camera.position
        }
        
        let translationScale = camera.xScale
        let panTranslation = sender.translation(in: self.view)
        let newCameraPosition = CGPoint(
            x: previousCameraPosition.x + panTranslation.x * -translationScale,
            y: previousCameraPosition.y + panTranslation.y * translationScale
        )
        
        camera.position = newCameraPosition
    }
    
    // Pinch gestures only handle camera movement in this scene
    @objc private func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else { return }
        
        if sender.state == .began {
            previousCameraScale = camera.xScale
        }
        
        camera.setScale(previousCameraScale * 1 / sender.scale)
    }
    
    @objc private func rotationGestureAction(_ sender: UIRotationGestureRecognizer) {
        guard let camera = self.camera else { return }
        
        if sender.state == .began {
            previousCameraRotation = camera.zRotation
        }
        
        camera.zRotation = previousCameraRotation + sender.rotation
    }
}

extension SKScene {
    func sceneToImage() -> UIImage? {
        guard let view = self.view else { return nil }
        
        let texture = view.texture(from: self)
        let image = texture?.toImage()
        
        return image
    }
}

extension SKTexture {
    func toImage() -> UIImage? {
        let size = CGSize(width: self.size().width, height: self.size().height)
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            let cgImage = self.cgImage()
            context.draw(cgImage, in: rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
}

