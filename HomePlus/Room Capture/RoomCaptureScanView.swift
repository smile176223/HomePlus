//
//  RoomCaptureScanView.swift
//  HomePlus
//
//  Created by Liam on 2024/9/24.
//

import SwiftUI
import SpriteKit

public struct RoomCaptureScanView: View {
    
    @ObservedObject private var model = RoomCaptureModel()
    @State private var isShowingFloorPlan = false
    
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
        .fullScreenCover(isPresented: $isShowingFloorPlan) {
            let floorPlanScene = FloorPlanScene(capturedRoom: model.finalResults!)
            
            ZStack {
                SpriteView(scene: floorPlanScene)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button("Back") {
                            isShowingFloorPlan = false
                        }
                        Spacer()
                        Button("Save") {
                            floorPlanScene.captureScene()
                        }
                    }
                    Spacer()
                }
            }
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
                            isShowingFloorPlan = true
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
