//
//  AgentMessage.swift
//  TerminalBuddyAgent
//
//  Created by Srdjan Tubin on 25.04.20.
//  Copyright © 2020 Srdjan Tubin. All rights reserved.
//

import Foundation

struct AgentMessage: Codable {
    var userCredentials: UserCredentials
    var message: String
    var reminderId: Int64
}
