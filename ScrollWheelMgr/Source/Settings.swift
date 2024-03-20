import Foundation
import ServiceManagement


/// The persistant settings
public struct Settings {
    /// Whether a scroll wheel tilt should be mapped to F5/F6
    public static var tiltOnOff: Bool {
        get { UserDefaults.standard.bool(forKey: "TiltOnOff") }
        set { UserDefaults.standard.set(newValue, forKey: "TiltOnOff") }
    }
    /// Whether the `mapTilt`-feature should be enabled or disabled automatically
    public static var tiltOnOffAutomatically: Bool {
        get { UserDefaults.standard.bool(forKey: "TiltOnOffAutomatically") }
        set { UserDefaults.standard.set(newValue, forKey: "TiltOnOffAutomatically") }
    }
    /// Whether a scroll wheel click should be mapped to Mission Control
    public static var mapClickToMissionControl: Bool {
        get { UserDefaults.standard.bool(forKey: "MapClickToMissionControl") }
        set { UserDefaults.standard.set(newValue, forKey: "MapClickToMissionControl") }
    }
    /// Whether ScrollWheelMgr should start automatically during login
    public static var autostart: Bool {
        get {
            // Fetch the autostart status
            SMAppService.mainApp.status == .enabled
        }
        set {
            do {
                // Try to register
                newValue
                    ? try SMAppService.mainApp.register()
                    : try SMAppService.mainApp.unregister()
            } catch let e {
                // Log error
                NSLog("Failed to change autostart setting to \(newValue): \(e)")
            }
        }
    }
}
