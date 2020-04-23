//
//  ContentView.swift
//  TerminalBuddyAgent
//
//  Created by Srdjan Tubin on 01.04.20.
//  Copyright © 2020 Srdjan Tubin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var serverStatus: ServerStatus
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Terminal Buddy Agent")
                .font(.headline)
                .foregroundColor(Color.blue)
            Text("Receive reminder notifications from server")
                .font(.subheadline)
            HStack {
                HStack {
                    Text(self.serverStatus.connected ? "Connected" : "Disconnected")
                    ServerStatusIndicator(isConnected: self.serverStatus.connected)
                }
                .padding()
            }
            Button(action: {
                exit(0)
            }) {
                Text("Exit")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(serverStatus: ServerStatus())
            ContentView(serverStatus: ServerStatus(connected: true))
        }
    }
}
