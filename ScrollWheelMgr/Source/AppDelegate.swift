import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    /// The status bar item
    var statusItem: NSStatusItem! = nil
    /// The menu for the status bar item
    @IBOutlet weak var menu: NSMenu!
    /// The "Map Tilt to F5/F6" switch
    @IBOutlet weak var tiltOnOffSwitch: NSSwitch!
    /// The "Manage "Map Tilt" Automatically" switch
    @IBOutlet weak var tiltOnOffAutomaticallySwitch: NSSwitch!
    /// The "Map Click to Mission Control" switch
    @IBOutlet weak var mapClickToMissionControlSwitch: NSSwitch!
    /// The "Autostart on Login" switch
    @IBOutlet weak var autostartSwitch: NSSwitch!
    
    /// An event monitor for scroll wheel tilts
    var scrollTiltEventMonitor: EventMonitor! = nil
    /// An event monitor for scroll wheel clicks
    var scrollClickEventMonitor: EventMonitor! = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Set delegates
        self.menu.delegate = self
        
        // Ensure accessibility permissions
        self.ensureAccessibilityPermissions()
        self.scrollTiltEventMonitor = EventMonitor()
        self.scrollClickEventMonitor = EventMonitor()
        
        // Create status item and set a dummy image to fix rendering issues
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem.button!.title = "🍀"
        self.statusItem.button!.image = NSImage()
        self.statusItem.button!.action = #selector(self.showMenu(sender:))
        self.statusItem.button!.sendAction(on: [.leftMouseUp, .rightMouseUp])
        self.toggleIcon(enabled: false)
        
        // Load tilt settings
        if Settings.tiltOnOff {
            // The button is disabled on launch, so we can simply simulate a click to enable it
            self.tiltOnOffSwitch.state = .on
            self.tiltOnOff(self.tiltOnOffSwitch!)
        }
        
        // Load autotilt settings
        if Settings.tiltOnOffAutomatically {
            // The button is disabled on launch, so we can simply simulate a click to enable it
            self.tiltOnOffAutomaticallySwitch.state = .on
            self.tiltOnOffAutomatically(self.tiltOnOffAutomaticallySwitch!)
        }
        
        // Load click settings
        if Settings.mapClickToMissionControl {
            // The button is disabled on launch, so we can simply simulate a click to enable it
            self.mapClickToMissionControlSwitch.state = .on
            self.mapClickToMissionControl(self.mapClickToMissionControlSwitch!)
        }
        
        // Load autostart settings
        if Settings.autostart {
            // We just set the button state here to avoid re-registering
            self.autostartSwitch.state = .on
        }
    }
    
    /// Ensures that the app has accessibility permissions
    func ensureAccessibilityPermissions() {
        // Check if the process is a trusted accessibility client
        while !AXIsProcessTrusted() {
            // Open preferences at the given location
            let prefPane = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
            let prefPaneUrl = URL(string: prefPane)!
            NSWorkspace.shared.open(prefPaneUrl)
            
            // Pop-up a modal alert informing the user about the requirements
            let alert = NSAlert()
            alert.messageText = "Enable Accessibility Permissions"
            alert.informativeText = "For ScrollWheelMgr to work you need to allow accessibility permissions it in \"System Preferences -> Security & Privacy -> Accessibility\"."
            alert.addButton(withTitle: "Enabled")
            alert.addButton(withTitle: "Cancel")
            
            // Await response; terminate if we didn't get access
            if alert.runModal() == NSApplication.ModalResponse.alertSecondButtonReturn {
                NSLog("Accessibility permissions have been denied; exiting...")
                NSApplication.shared.terminate(self)
            }
        }
    }
    
    /// Toggles the icon between enabled or disabled
    func toggleIcon(enabled: Bool) {
        if enabled {
            // Remove all content filters
            self.statusItem.button!.contentFilters.removeAll(where: { $0.name == "CIPhotoEffectTonal" })
        } else {
            // Apply filters
            let tonal = CIFilter(name: "CIPhotoEffectTonal")!
            self.statusItem.button!.contentFilters.append(tonal)
        }
    }
    
    /// Maps a scroll-wheel tilt to either F5 or F6
    func mapScrollTilt(event: CGEvent) -> CGEvent? {
        // Check for scroll wheel events
        if Event.scrollTiltLeft.matches(event: event) {
            // Translate tilt left into F5
            CharStroke.f5.toKeyStroke().send(delay: 0)
            return nil
        } else if Event.scrollTiltRight.matches(event: event) {
            // Translate tilt right into F6
            CharStroke.f6.toKeyStroke().send(delay: 0)
            return nil
        } else {
            // Return the event as-is
            return event
        }
    }
    
    /// Maps an `event` to open Mission Control if it matches the `filter`
    func mapScrollClick(event: CGEvent) -> CGEvent? {
        // Check for scroll wheel events
        if Event.scrollClick.matches(event: event) {
            // Start mission control
            NSWorkspace.shared.openApplication(
                at: URL(filePath: "/System/Applications/Mission Control.app"),
                configuration: NSWorkspace.OpenConfiguration())
            return nil
        } else {
            // Return the event as-is
            return event
        }
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
            // Toggle tilt on-off
            self.tiltOnOffSwitch.performClick(sender)
        }
    }
    
    @IBAction func tiltOnOff(_ sender: Any) {
        // Update the event monitor callbacks
        switch self.tiltOnOffSwitch.state {
            case .on:
                self.scrollTiltEventMonitor.callback = mapScrollTilt(event:)
            default:
                self.scrollTiltEventMonitor.callback = nil
        }
        
        // Toggle icon and update settings
        self.toggleIcon(enabled: self.tiltOnOffSwitch.state == .on)
        Settings.tiltOnOff = self.tiltOnOffSwitch.state == .on
    }
    
    @IBAction func tiltOnOffAutomatically(_ sender: Any) {
        // FIXME: Do some action here
        Settings.tiltOnOffAutomatically = self.tiltOnOffAutomaticallySwitch.state == .on
    }
    
    @IBAction func mapClickToMissionControl(_ sender: Any) {
        // Update the event monitor callbacks
        switch self.mapClickToMissionControlSwitch.state {
            case .on:
                self.scrollClickEventMonitor.callback = mapScrollClick(event:)
            default:
                self.scrollClickEventMonitor.callback = nil
        }
        
        // Update settings
        Settings.mapClickToMissionControl = self.mapClickToMissionControlSwitch.state == .on
    }
    
    @IBAction func autostart(_ sender: Any) {
        // Do a store-load here since autostart settings might break at some point
        Settings.autostart = self.autostartSwitch.state == .on
        self.autostartSwitch.state = Settings.autostart ? .on : .off
    }
    
    @IBAction func terminateApp(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
}
