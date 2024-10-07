//
//  RoomCaptureRepresentable.swift
//  HomePlus
//
//  Created by Liam on 2024/9/24.
//

import SwiftUI

public struct RoomCaptureRepresentable: UIViewRepresentable {
    
    public let roomCaptureModel: RoomCaptureModel
    
    public init(roomCaptureModel: RoomCaptureModel) {
        self.roomCaptureModel = roomCaptureModel
    }
    
    public func makeUIView(context: Context) -> some UIView {
        roomCaptureModel.roomCaptureView
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {}
}
