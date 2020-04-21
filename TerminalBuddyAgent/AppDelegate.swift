//
//  AppDelegate.swift
//  TerminalBuddyAgent
//
//  Created by Srdjan Tubin on 01.04.20.
//  Copyright © 2020 Srdjan Tubin. All rights reserved.
//

import Cocoa
import SwiftUI
import Starscream

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, WebSocketDelegate {
    let serverPort = "8080"
    let serverHost = "localhost"
    
    @State private var isConnected: Bool = false
    private var socket: WebSocket!
    private let server = WebSocketServer()

    var initData: InitData?

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    // TODO: should be in some other place (i guess)
    struct InitData: Codable {
        var username: String
        var password: String
    }
    
    // TODO: add button to quit

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(isConnected: $isConnected)

        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "Icon")
            button.action = #selector(togglePopover(_:))
        }
        
        if getInitData() {
            connect()
        } else {
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
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    // MARK: - WebSocketDelegate
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            self.isConnected = true

            print("websocket is connected: \(headers)")
            // showNotification(title: "Terminal Buddy", subtitle: "Connected to server")

            // TODO: read password from app data
            let initData = InitData(username: "serj", password: "d21992b8787fdbb8032eddbb2d81bccc")
            let initDataJson = initData.convertToString!

            print("sending init data: " + initDataJson)

            socket.write(string: initDataJson) {
                print("sent an init message to server")
            }
        case .disconnected(let reason, let code):
            self.isConnected = false 
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
            isConnected = false
        case .error(let error):
            print("received error event")
            isConnected = false
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
    
//    // MARK: Write Text Action
//    @IBAction func writeText(_ sender: UIBarButtonItem) {
//        socket.write(string: "hello there!")
//    }
//
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

