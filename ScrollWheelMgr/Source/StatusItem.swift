//
//  StatusItem.swift
//  ScrollWheelMgr
//
//  Created by Keziah on 26/10/2016.
//  Copyright © 2016 KizzyCode. All rights reserved.
//

import Cocoa


class StatusItem: NSObject, NSMenuDelegate {
    private var statusItem: NSStatusItem! = nil
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var tiltOnOffSwitch: NSSwitch!
    @IBOutlet weak var tiltAutomaticallySwitch: NSSwitch!
    @IBOutlet weak var mapClickToMissionControlSwitch: NSSwitch!
    @IBOutlet weak var autostartSwitch: NSSwitch!
    
    override init() {
        // Init superclass and set delegates
        super.init()
        self.menu.delegate = self
        
        // Create status item
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem.menu = menu
        self.statusItem.button!.title = "Test"
        self.statusItem.button!.action = #selector(self.showMenu(sender:))
        self.statusItem.button!.sendAction(on: [.leftMouseUp, .rightMouseUp])
	}
    
    /// A delegate method that is called when when an `NSMenu` has been closed
    func menuDidClose(_ menu: NSMenu) {
        // Process didClose events for `self.menu`
        if menu == self.menu {
            self.statusItem.menu = nil
        }
    }
    
    /// Shows the menu
    @objc func showMenu(sender: Any) {
        // Grab the event
        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.rightMouseUp {
            // Attach the menu to the status bar item and open it
            self.statusItem.menu = self.menu
            self.statusItem.button!.performClick(sender)
        } else {
            // Show either the settings window or type the text
            NSLog("<LEFT KLIGG>")
        }
    }
    
    @IBAction func tiltOnOff(_ sender: Any) {
        
    }
    
    @IBAction func tiltAutomatically(_ sender: Any) {
        
    }
    
    @IBAction func clickToMissionControl(_ sender: Any) {
        
    }
    
    @IBAction func autostartOnLogin(_ sender: Any) {
        
    }
    
    @IBAction func terminateApp(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
}












