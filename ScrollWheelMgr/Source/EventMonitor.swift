import Foundation
import Carbon.HIToolbox


/// An event type
public enum Event {
    /// An event that gets fired if the scroll wheel is tilted to the left
    case scrollTiltLeft
    /// An event that gets fired if the scroll wheel is tilted to the right
    case scrollTiltRight
    /// An event that gets fired if the scroll wheel is clicked
    case scrollClick
    
    /// Checks whether `self` matches the given `event`
    func matches(event: CGEvent) -> Bool {
        switch self {
            case .scrollTiltLeft:
                return event.getIntegerValueField(.scrollWheelEventPointDeltaAxis2) > 0
            case .scrollTiltRight:
                return event.getIntegerValueField(.scrollWheelEventPointDeltaAxis2) < 0
            case .scrollClick:
                return event.getIntegerValueField(.mouseEventButtonNumber) == 2
        }
    }
}


/// An event monitor
public class EventMonitor {
    /// The event callback
    public var callback: ((CGEvent) -> CGEvent?)?
    /// The runloop source
    private var source: CFRunLoopSource? = nil
    
    /// Creates a new event monitor
    public init(callback: ((CGEvent) -> CGEvent?)? = nil) {
        // Set the event callback
        self.callback = callback
        
        // Create event tap
        let this = Unmanaged.passUnretained(self).toOpaque()
        let tap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(1 << NX_SCROLLWHEELMOVED | 1 << NX_OMOUSEDOWN),
            callback: onEvent_CBridge(_:type:event:monitor:),
            userInfo: this)
        
        // Add the tap to the runloop
        self.source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), self.source, .commonModes)
    }
    deinit {
        // Remove the run loop source
        if let source = self.source {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
            self.source = nil
        }
    }
}


/// The onEvent-C-callback
private func onEvent_CBridge(_: OpaquePointer, type: CGEventType, event: CGEvent, monitor: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    // Try to call the callback
    let monitor: EventMonitor = Unmanaged.fromOpaque(monitor!).takeUnretainedValue()
    if let callback = monitor.callback {
        // Call the callback and return the transformed event
        let event = callback(event)
        return event.map(Unmanaged.passUnretained)
    } else {
        // Return the event as-is
        return Unmanaged.passUnretained(event)
    }
}
