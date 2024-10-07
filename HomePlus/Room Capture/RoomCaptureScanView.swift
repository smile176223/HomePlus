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
                
                HStack {
                    CircleView {
                        Button {
                            try? model.exportData()
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .activitySheet($model.activityItem)
                    
                    Spacer()
                    
                    CircleView {
                        Button {
                            
                        } label: {
                            Image(systemName: "book")
                                .foregroundStyle(Color.white)
                        }
                    }
                }
                .padding([.leading, .trailing, .bottom], 24)
            }
        }
    }
}
