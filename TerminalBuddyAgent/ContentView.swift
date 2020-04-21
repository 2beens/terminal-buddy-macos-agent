//
//  ContentView.swift
//  TerminalBuddyAgent
//
//  Created by Srdjan Tubin on 01.04.20.
//  Copyright © 2020 Srdjan Tubin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Binding var isConnected: Bool
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Terminal Buddy Agent")
                .font(.headline)
                .foregroundColor(Color.blue)
            Text("Receive reminder notifications from server")
                .font(.subheadline)
            HStack {
                HStack {
                    Text(isConnected ? "Connected" : "Disconnected")
                    ServerStatusIndicator(isConnected: $isConnected)
                }
                .padding()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(isConnected: .constant(true))
            ContentView(isConnected: .constant(false))
        }
    }
}
