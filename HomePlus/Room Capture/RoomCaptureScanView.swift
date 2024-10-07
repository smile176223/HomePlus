//
//  RoomCaptureScanView.swift
//  HomePlus
//
//  Created by Liam on 2024/9/24.
//

import SwiftUI

public struct RoomCaptureScanView: View {
    
    @ObservedObject private var model = RoomCaptureModel()
    
    @State private var isCapturing: Bool = false
    
    public var body: some View {
        ZStack {
            RoomCaptureRepresentable(roomCaptureModel: model)
                .ignoresSafeArea()
                .onAppear(perform: model.startCapture)
                .onDisappear(perform: model.stopCapture)
            
            actionView()
        }
    }
    
    @ViewBuilder
    private func actionView() -> some View {
        VStack {
            Spacer()
            
            switch model.status {
            case .initial:
                EmptyView()
                
            case .capturing:
                CapsuleView {
                    Button("Done", action: model.stopCapture)
                }
                
            case .finished:
                CapsuleView {
                    Button("Export", action: model.exportData)
                }
            }
        }
    }
}
