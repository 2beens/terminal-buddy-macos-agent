//
//  ServerStatus.swift
//  TerminalBuddyAgent
//
//  Created by Srdjan Tubin on 23.04.20.
//  Copyright © 2020 Srdjan Tubin. All rights reserved.
//

import Foundation

class ServerStatus: ObservableObject {
    @Published var connected: Bool
    
    init(connected: Bool = false) {
        self.connected = connected
    }
}
