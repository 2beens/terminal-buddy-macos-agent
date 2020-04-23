//
//  AppDelegate.swift
//  TerminalBuddyAgent
//
//  Created by Srdjan Tubin on 01.04.20.
//  Copyright © 2020 Srdjan Tubin. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    var connManager: ConnectionManager = ConnectionManager()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.connManager.initialize()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(serverStatus: self.connManager.serverStatus)

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
        
        self.connManager.connect()
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
    
}

