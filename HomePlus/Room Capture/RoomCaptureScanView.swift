//
//  RoomCaptureScanView.swift
//  HomePlus
//
//  Created by Liam on 2024/9/24.
//

import SwiftUI

public struct RoomCaptureScanView: View {
    
    @ObservedObject private var model = RoomCaptureModel()
    
    public var body: some View {
        ZStack {
            RoomCaptureRepresentable(roomCaptureModel: model)
                .ignoresSafeArea()
                .onAppear(perform: model.startCapture)
                .onDisappear(perform: model.stopCapture)
            
            actionView()
        }
        .toolbar {
            Button("Done", action: model.stopCapture)
        }
    }
    
    @ViewBuilder
    private func actionView() -> some View {
        switch model.status {
        case .initial, .capturing:
            EmptyView()
            
        case .finished:
            VStack {
                Spacer()
                
                CapsuleView {
                    Button("Export", action: model.exportData)
                }
                .activitySheet($model.activityItem)
            }
        }
    }
}
