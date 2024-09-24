//
//  RoomCaptureScanView.swift
//  HomePlus
//
//  Created by Liam on 2024/9/24.
//

import SwiftUI

public struct RoomCaptureScanView: View {
    
    private let model = RoomCaptureModel()
    
    public var body: some View {
        RoomCaptureRepresentable(roomCaptureModel: model)
            .ignoresSafeArea(.all)
            .onAppear(perform: model.startCapture)
            .onDisappear(perform: model.stopCapture)
    }
}
