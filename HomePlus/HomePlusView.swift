//
//  HomePlusView.swift
//  HomePlus
//
//  Created by Liam on 2024/9/24.
//

import SwiftUI

struct HomePlusView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "house")
                    .imageScale(.large)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
                
                Text("RoomPlan 2D")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                Text("Scan your room and create a 2D floor plan.")
                
                Spacer()
                    .frame(height: 50)
                
                NavigationLink("Start Scanning") {
                    RoomCaptureScanView()
                }
                .padding()
                .background(.gray)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .fontWeight(.bold)
            }
        }
        .background(.white)
    }
}

#Preview {
    HomePlusView()
}
