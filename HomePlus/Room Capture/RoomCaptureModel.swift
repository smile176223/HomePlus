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
//        view.delegate = self
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
    @Published var activityItem: ActivityItem?
    var finalResults: CapturedRoom?
    
//    public init() {}
//    
//    public required init?(coder: NSCoder) {
//        fatalError("Error when initializing RoomCaptureModel")
//    }

    public func startCapture() {
        roomCaptureView.captureSession.run(configuration: captureSessionConfiguration)
        status = .capturing
    }
    
    public func stopCapture() {
        roomCaptureView.captureSession.stop()
        status = .finished
    }
    
    public func exportData() throws {
        let destinationFolderURL = FileManager.default.temporaryDirectory.appending(path: "Export")
        let destinationURL = destinationFolderURL.appending(path: "Room.usdz")
        let capturedRoomURL = destinationFolderURL.appending(path: "Room.json")

        do {
            try FileManager.default.createDirectory(at: destinationFolderURL, withIntermediateDirectories: true)
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(finalResults)
            try jsonData.write(to: capturedRoomURL)
            try finalResults?.export(to: destinationURL, exportOptions: .parametric)
            
            activityItem = ActivityItem(itemsArray: [destinationFolderURL])
            
        } catch {
            throw error
        }
    }
    
    public func captureSession(_ session: RoomCaptureSession, didEndWith data: CapturedRoomData, error: (any Error)?) {
        Task {
            finalResults = try? await roomBuilder.capturedRoom(from: data)
        }
    }
}

//extension RoomCaptureModel: RoomCaptureViewDelegate {
//    public func encode(with coder: NSCoder) {}
//    
//    public func captureView(didPresent processedResult: CapturedRoom, error: (any Error)?) {
//        finalResults = processedResult
//    }
//}
