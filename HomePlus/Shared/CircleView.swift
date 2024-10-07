//
//  CircleView.swift
//  HomePlus
//
//  Created by Liam on 2024/10/7.
//

import SwiftUI

struct CircleView<ContentView: View>: View {
    
    var contentView: () -> ContentView
    
    var body: some View {
        contentView()
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}
