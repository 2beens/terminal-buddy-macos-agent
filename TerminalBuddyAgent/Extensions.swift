//
//  Extensions.swift
//  TerminalBuddyAgent
//
//  Created by Srdjan Tubin on 19.04.20.
//  Copyright © 2020 Srdjan Tubin. All rights reserved.
//

import Foundation

extension Encodable {
    var convertToString: String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
