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
                .ignoresSafeArea(.all)
                .onAppear(perform: startCapture)
                .onDisappear(perform: stopCapture)
            
            VStack {
                Spacer()
                
                Button("Done", action: stopCapture)
                .padding()
                .background(Color("AccentColor"))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .fontWeight(.bold)
                .padding(.bottom)
            }
        }
    }
    
    private func startCapture() {
        isCapturing = true
        model.startCapture()
    }
    
    private func stopCapture() {
        if isCapturing {
            isCapturing = false
            model.stopCapture()
        }
    }
}
