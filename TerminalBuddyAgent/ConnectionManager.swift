//
//  ConnectionManager.swift
//  TerminalBuddyAgent
//
//  Created by Srdjan Tubin on 22.04.20.
//  Copyright © 2020 Srdjan Tubin. All rights reserved.
//

import Foundation
import Starscream
import SwiftUI

class ConnectionManager: WebSocketDelegate {
    @ObservedObject var serverStatus: ServerStatus
    
    let serverPort = "8080"
    let serverHost = "localhost"
    var initData: InitData?
    
    private var socket: WebSocket!
    private let server = WebSocketServer()
    
    init() {
        self.serverStatus = ServerStatus()
    }
    
    func initialize() {
        if !getInitData() {
            let alert = NSAlert()
            alert.messageText = "User data empty / corrupted"
            alert.informativeText = """
                User data folder/file is empty or messed up.
                Use Terminal Buddy Commander to register/login,
                    and come back.
            """
            alert.runModal()
        }
    }
    
    func getInitData() -> Bool {
        do {
            let userDataStr = try String(contentsOfFile: "/Users/serj/Library/Preferences/terminal-buddy/term-buddy-settings")
            let userData = userDataStr.components(separatedBy: "::")
            if userData.count == 2 {
                initData = InitData(username: userData[0], password: userData[1])
                return true
            }
        }
        catch {
            print("Error reading user data: \(error).")
        }
        return false
    }

    func connect() {
        let serverAddress = "ws://\(serverHost):\(serverPort)/connect"
        print("connecting to " + serverAddress)
        var request = URLRequest(url: URL(string: serverAddress)!)
        request.timeoutInterval = 4
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        print("connect initiated ...")
    }

    // MARK: - WebSocketDelegate
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            self.serverStatus.connected = true
            print("websocket is connected: \(headers)")

            let initDataJson = initData.convertToString!
            print("sending init data: " + initDataJson)
            socket.write(string: initDataJson) {
                print("sent an init message to server")
            }
        case .disconnected(let reason, let code):
            self.serverStatus.connected = false
            showNotification(title: "Terminal Buddy", subtitle: "Disconnected from server")
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            showNotification(title: "term buddy test", subtitle: string)
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            print("received ping")
            break
        case .pong(_):
            print("received pong")
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            print("received cancelled")
            self.serverStatus.connected = false
        case .error(let error):
            print("received error event")
            self.serverStatus.connected = false
            handleError(error)
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
  
//    // MARK: Disconnect Action
//    @IBAction func disconnect(_ sender: UIBarButtonItem) {
//        if isConnected {
//            sender.title = "Connect"
//            socket.disconnect()
//        } else {
//            sender.title = "Disconnect"
//            socket.connect()
//        }
//    }
    
    func showNotification(title: String, subtitle: String) -> Void {
        let notification = NSUserNotification()
        notification.deliveryDate = Date(timeIntervalSinceNow: 3)
        notification.title = title
        notification.subtitle = subtitle
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.scheduleNotification(notification)
    }
}
