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
    @Binding var testBool: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(self.isConnected ? Color.green : Color.red)
                .frame(width: 20, height: 20)
            Rectangle()
                .fill(self.testBool ? Color.green : Color.red)
                .frame(width: 20, height: 20, alignment: .center)
        }
    }
}

struct ServerStatusIndicator_Previews: PreviewProvider {
    private let isConnected = true
    static var previews: some View {
        Group {
            ServerStatusIndicator(isConnected: .constant(true), testBool: .constant(false))
            ServerStatusIndicator(isConnected: .constant(false), testBool: .constant(true))
        }
    }
}
