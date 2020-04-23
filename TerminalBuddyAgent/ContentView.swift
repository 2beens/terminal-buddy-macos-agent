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
    var connectWsFunc: () -> Void
    var disconnectWsFunc: () -> Void
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Terminal Buddy Agent")
                .font(.headline)
                .foregroundColor(Color.blue)
            Text("Receive reminder notifications from server")
                .font(.subheadline)
            HStack {
                HStack {
                    Text("Status")
                    ServerStatusIndicator(isConnected: self.serverStatus.connected)
                    Button(action: {
                        if self.serverStatus.connected  {
                            self.disconnectWsFunc()
                        } else {
                            self.connectWsFunc()
                        }
                    }) {
                        Text(self.serverStatus.connected ? "Disconnect" : "Connect")
                    }
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
            ContentView(serverStatus: ServerStatus(), connectWsFunc: {}, disconnectWsFunc:{})
            ContentView(serverStatus: ServerStatus(connected: true), connectWsFunc: {}, disconnectWsFunc:{})
        }
    }
}
