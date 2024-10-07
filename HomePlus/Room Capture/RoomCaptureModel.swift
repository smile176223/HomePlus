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
    
    public enum Status {
        case initial
        case capturing
        case finished
    }
    
    @Published var status: Status = .initial
    @Published var captureData: CapturedRoomData? = nil

    public func startCapture() {
        roomCaptureView.captureSession.run(configuration: captureSessionConfiguration)
        status = .capturing
    }
    
    public func stopCapture() {
        roomCaptureView.captureSession.stop()
        status = .finished
    }
    
    public func exportData() {
        
    }
    
    public func captureSession(_ session: RoomCaptureSession, didEndWith data: CapturedRoomData, error: (any Error)?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.captureData = data
        }
    }
}
