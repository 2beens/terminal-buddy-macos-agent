//
//  ServerStatusIndicator.swift
//  TerminalBuddyAgent
//
//  Created by Srdjan Tubin on 21.04.20.
//  Copyright © 2020 Srdjan Tubin. All rights reserved.
//

import SwiftUI

struct ServerStatusIndicator: View {
    @Binding var isConnected: Bool
    
    var body: some View {
        Circle()
            .fill(self.isConnected ? Color.green : Color.red)
            .frame(width: 20, height: 20)
    }
}

struct ServerStatusIndicator_Previews: PreviewProvider {
    private let isConnected = true
    static var previews: some View {
        Group {
            ServerStatusIndicator(isConnected: .constant(true))
            ServerStatusIndicator(isConnected: .constant(false))
        }
    }
}
