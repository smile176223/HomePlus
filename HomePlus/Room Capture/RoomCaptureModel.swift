//
//  RoomCaptureModel.swift
//  HomePlus
//
//  Created by Liam on 2024/9/24.
//

import Foundation
import RoomPlan

public final class RoomCaptureModel: RoomCaptureSessionDelegate, ObservableObject {
    
    private(set) lazy var roomCaptureView: RoomCaptureView = {
        let view = RoomCaptureView()
        view.captureSession.delegate = self
        return view
    }()
    
    private lazy var captureSessionConfiguration: RoomCaptureSession.Configuration = {
        RoomCaptureSession.Configuration()
    }()
    
    private lazy var roomBuilder: RoomBuilder = {
        RoomBuilder(options: [.beautifyObjects])
    }()
    
    @Published var captureData: CapturedRoomData? = nil

    public func startCapture() {
        roomCaptureView.captureSession.run(configuration: captureSessionConfiguration)
    }
    
    public func stopCapture() {
        roomCaptureView.captureSession.stop()
    }
    
    public func captureSession(_ session: RoomCaptureSession, didEndWith data: CapturedRoomData, error: (any Error)?) {
        captureData = data
    }
}
