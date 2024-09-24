//
//  RoomCaptureModel.swift
//  HomePlus
//
//  Created by Liam on 2024/9/24.
//

import Foundation
import RoomPlan

public final class RoomCaptureModel: RoomCaptureSessionDelegate {
    
    private lazy var roomCaptureView: RoomCaptureView = {
        let view = RoomCaptureView(frame: .zero)
        view.captureSession.delegate = self
        return view
    }()
    
    private lazy var captureSessionConfiguration: RoomCaptureSession.Configuration = {
        RoomCaptureSession.Configuration()
    }()
    
    private lazy var roomBuilder: RoomBuilder = {
        RoomBuilder(options: [.beautifyObjects])
    }()
    
    public func startCapture() {
        roomCaptureView.captureSession.run(configuration: captureSessionConfiguration)
    }
    
    public func stopCapture() {
        roomCaptureView.captureSession.stop()
    }
    
    public func captureView() -> RoomCaptureView {
        roomCaptureView
    }
}
