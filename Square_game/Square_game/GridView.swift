//
//  ContentView.swift
//  Square_game
//
//  Created by Udana 004 on 2024-12-15.
//

import SwiftUI

struct GridView: View {
    
    private var row:[GridItem]=[GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    var body: some View {
        LazyVGrid(columns:row, spacing:10){
            ForEach((0...8), id: \.self){
                grid in
                
                Rectangle().fill(.blue).frame(width: 100, height: 100, alignment: .center).cornerRadius(15).padding()
            }
        }
    }
    
}

#Preview {
    GridView()
}
