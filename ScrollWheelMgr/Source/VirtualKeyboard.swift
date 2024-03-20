import Foundation
import Carbon.HIToolbox


/// A key stroke
public struct KeyStroke {
    /// The key code
    public let keyCode: UInt16
    /// The modifier keys
    public let modifiers: [UInt16]
    
    /// Creates a new key stroke
    public init(keyCode: UInt16, modifiers: UInt16...) {
        self.keyCode = keyCode
        self.modifiers = modifiers
    }
    
    /// Sends the key stroke
    public func send(delay: Double = 0.03) {
        // Press modifiers
        for modifier in self.modifiers {
            self.postKeyEvent(keyCode: modifier, keyDown: true)
            Thread.sleep(forTimeInterval: delay)
        }
        
        // Press key
        self.postKeyEvent(keyCode: self.keyCode, keyDown: true)
        Thread.sleep(forTimeInterval: delay)
        
        // Release key
        self.postKeyEvent(keyCode: self.keyCode, keyDown: false)
        Thread.sleep(forTimeInterval: delay)
        
        // Release modifiers
        for modifier in self.modifiers.reversed() {
            self.postKeyEvent(keyCode: modifier, keyDown: false)
            Thread.sleep(forTimeInterval: delay)
        }
    }
    
    /// Posts a key event
    private func postKeyEvent(keyCode: UInt16, keyDown: Bool) {
        let keyCode = CGKeyCode(keyCode)
        let eventSource = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let event = CGEvent(keyboardEventSource: eventSource, virtualKey: keyCode, keyDown: keyDown)!
        event.post(tap: CGEventTapLocation.cghidEventTap)
    }
}


/// A char stroke
///
/// Useful reference: https://eastmanreference.com/complete-list-of-applescript-key-codes
public enum CharStroke: CaseIterable {
    case esc, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12,
         fnDisplayDarker, fnDisplayBrighter, fnMissionControl, fnLaunchpad
    case backtick, num1, num2, num3, num4, num5, num6, num7, num8, num9, num0, hyphen, equal, delete,
        tilde, exclamationMark, at, hash, dollar, percent, caret, ampersand, asterisk, parenthesisOpen, parenthesisClose, underscore, plus
    case tab, q, w, e, r, t, y, u, i, o, p, bracketOpen, bracketClose, backslash,
        qUp, wUp, eUp, rUp, tUp, yUp, uUp, iUp, oUp, pUp, braceOpen, braceClose, verticalBar
    case capsLock, a, s, d, f, g, h, j, k, l, semicolon, singleQuotationMark, `return`,
        aUp, sUp, dUp, fUp, gUp, hUp, jUp, kUp, lUp, colon, doubleQuotationMark, enter
    case shiftLeft, z, x, c, v, b, n, m, comma, period, slash, shiftRight,
        zUp, xUp, cUp, vUp, bUp, nUp, mUp, lessThan, greaterThan, questionMark
    case fn, control, optionLeft, command, space, optionRight, left, down, up, right
    
    /// Gets the char stroke for a given character
    public init?(char: Character) {
        switch char {
            // Second row lowercase
            case "`": self = Self.backtick
            case "1": self = Self.num1
            case "2": self = Self.num2
            case "3": self = Self.num3
            case "4": self = Self.num4
            case "5": self = Self.num5
            case "6": self = Self.num6
            case "7": self = Self.num7
            case "8": self = Self.num8
            case "9": self = Self.num9
            case "0": self = Self.num0
            case "-": self = Self.hyphen
            case "=": self = Self.equal
            // Second row uppercase
            case "~": self = Self.tilde
            case "!": self = Self.exclamationMark
            case "@": self = Self.at
            case "#": self = Self.hash
            case "$": self = Self.dollar
            case "%": self = Self.percent
            case "^": self = Self.caret
            case "&": self = Self.ampersand
            case "*": self = Self.asterisk
            case "(": self = Self.parenthesisOpen
            case ")": self = Self.parenthesisClose
            case "_": self = Self.underscore
            case "+": self = Self.plus
            
            // Third row lowercase
            case "q": self = Self.q
            case "w": self = Self.w
            case "e": self = Self.e
            case "r": self = Self.r
            case "t": self = Self.t
            case "y": self = Self.y
            case "u": self = Self.u
            case "i": self = Self.i
            case "o": self = Self.o
            case "p": self = Self.p
            case "[": self = Self.bracketOpen
            case "]": self = Self.bracketClose
            case "\\": self = Self.backslash
            // Third row uppercase
            case "Q": self = Self.qUp
            case "W": self = Self.wUp
            case "E": self = Self.eUp
            case "R": self = Self.rUp
            case "T": self = Self.tUp
            case "Y": self = Self.yUp
            case "U": self = Self.uUp
            case "I": self = Self.iUp
            case "O": self = Self.oUp
            case "P": self = Self.pUp
            case "{": self = Self.braceOpen
            case "}": self = Self.braceClose
            case "|": self = Self.verticalBar
            
            // Fourth row lowercase
            case "a": self = Self.a
            case "s": self = Self.s
            case "d": self = Self.d
            case "f": self = Self.f
            case "g": self = Self.g
            case "h": self = Self.h
            case "j": self = Self.j
            case "k": self = Self.k
            case "l": self = Self.l
            case ";": self = Self.semicolon
            case "'": self = Self.singleQuotationMark
            // Fourth row uppercase
            case "A": self = Self.aUp
            case "S": self = Self.sUp
            case "D": self = Self.dUp
            case "F": self = Self.fUp
            case "G": self = Self.gUp
            case "H": self = Self.hUp
            case "J": self = Self.jUp
            case "K": self = Self.kUp
            case "L": self = Self.lUp
            case ":": self = Self.colon
            case "\"": self = Self.doubleQuotationMark
            
            // Fifth row lowercase
            case "z": self = Self.z
            case "x": self = Self.x
            case "c": self = Self.c
            case "v": self = Self.v
            case "b": self = Self.b
            case "n": self = Self.n
            case "m": self = Self.m
            case ",": self = Self.comma
            case ".": self = Self.period
            case "/": self = Self.slash
            // Fifth row uppercase
            case "Z": self = Self.zUp
            case "X": self = Self.xUp
            case "C": self = Self.cUp
            case "V": self = Self.vUp
            case "B": self = Self.bUp
            case "N": self = Self.nUp
            case "M": self = Self.mUp
            case "<": self = Self.lessThan
            case ">": self = Self.greaterThan
            case "?": self = Self.questionMark
            
            // Sixth row
            case " ": self = Self.space
            
            // Unsupported
            default: return nil
        }
    }
    
    /// Creates a matching key stroke
    func toKeyStroke() -> KeyStroke {
        switch self {
            // First row
            case Self.esc: return KeyStroke(keyCode: 53)
            case Self.f1: return KeyStroke(keyCode: 122)
            case Self.f2: return KeyStroke(keyCode: 120)
            case Self.f3: return KeyStroke(keyCode: 99)
            case Self.f4: return KeyStroke(keyCode: 118)
            case Self.f5: return KeyStroke(keyCode: 96)
            case Self.f6: return KeyStroke(keyCode: 97)
            case Self.f7: return KeyStroke(keyCode: 98)
            case Self.f8: return KeyStroke(keyCode: 100)
            case Self.f9: return KeyStroke(keyCode: 101)
            case Self.f10: return KeyStroke(keyCode: 109)
            case Self.f11: return KeyStroke(keyCode: 103)
            case Self.f12: return KeyStroke(keyCode: 111)
            case Self.fnDisplayDarker: return KeyStroke(keyCode: 107)
            case Self.fnDisplayBrighter: return KeyStroke(keyCode: 113)
            case Self.fnMissionControl: return KeyStroke(keyCode: 160)
            case Self.fnLaunchpad: return KeyStroke(keyCode: 131)
            
            // Second row lowercase
            case Self.backtick: return KeyStroke(keyCode: 50)
            case Self.num1: return KeyStroke(keyCode: 18)
            case Self.num2: return KeyStroke(keyCode: 19)
            case Self.num3: return KeyStroke(keyCode: 20)
            case Self.num4: return KeyStroke(keyCode: 21)
            case Self.num5: return KeyStroke(keyCode: 23)
            case Self.num6: return KeyStroke(keyCode: 22)
            case Self.num7: return KeyStroke(keyCode: 26)
            case Self.num8: return KeyStroke(keyCode: 28)
            case Self.num9: return KeyStroke(keyCode: 25)
            case Self.num0: return KeyStroke(keyCode: 29)
            case Self.hyphen: return KeyStroke(keyCode: 27)
            case Self.equal: return KeyStroke(keyCode: 24)
            case Self.delete: return KeyStroke(keyCode: 51)
            // Second row uppercase
            case Self.tilde: return KeyStroke(keyCode: 50, modifiers: 57)
            case Self.exclamationMark: return KeyStroke(keyCode: 18, modifiers: 57)
            case Self.at: return KeyStroke(keyCode: 19, modifiers: 57)
            case Self.hash: return KeyStroke(keyCode: 20, modifiers: 57)
            case Self.dollar: return KeyStroke(keyCode: 21, modifiers: 57)
            case Self.percent: return KeyStroke(keyCode: 23, modifiers: 57)
            case Self.caret: return KeyStroke(keyCode: 22, modifiers: 57)
            case Self.ampersand: return KeyStroke(keyCode: 26, modifiers: 57)
            case Self.asterisk: return KeyStroke(keyCode: 28, modifiers: 57)
            case Self.parenthesisOpen: return KeyStroke(keyCode: 25, modifiers: 57)
            case Self.parenthesisClose: return KeyStroke(keyCode: 29, modifiers: 57)
            case Self.underscore: return KeyStroke(keyCode: 27, modifiers: 57)
            case Self.plus: return KeyStroke(keyCode: 24, modifiers: 57)
            
            // Third row lowercase
            case Self.tab: return KeyStroke(keyCode: 48)
            case Self.q: return KeyStroke(keyCode: 12)
            case Self.w: return KeyStroke(keyCode: 13)
            case Self.e: return KeyStroke(keyCode: 14)
            case Self.r: return KeyStroke(keyCode: 15)
            case Self.t: return KeyStroke(keyCode: 17)
            case Self.y: return KeyStroke(keyCode: 16)
            case Self.u: return KeyStroke(keyCode: 32)
            case Self.i: return KeyStroke(keyCode: 34)
            case Self.o: return KeyStroke(keyCode: 31)
            case Self.p: return KeyStroke(keyCode: 35)
            case Self.bracketOpen: return KeyStroke(keyCode: 33)
            case Self.bracketClose: return KeyStroke(keyCode: 30)
            case Self.backslash: return KeyStroke(keyCode: 42)
            // Third row uppercase
            case Self.qUp: return KeyStroke(keyCode: 12, modifiers: 57)
            case Self.wUp: return KeyStroke(keyCode: 13, modifiers: 57)
            case Self.eUp: return KeyStroke(keyCode: 14, modifiers: 57)
            case Self.rUp: return KeyStroke(keyCode: 15, modifiers: 57)
            case Self.tUp: return KeyStroke(keyCode: 17, modifiers: 57)
            case Self.yUp: return KeyStroke(keyCode: 16, modifiers: 57)
            case Self.uUp: return KeyStroke(keyCode: 32, modifiers: 57)
            case Self.iUp: return KeyStroke(keyCode: 34, modifiers: 57)
            case Self.oUp: return KeyStroke(keyCode: 31, modifiers: 57)
            case Self.pUp: return KeyStroke(keyCode: 35, modifiers: 57)
            case Self.braceOpen: return KeyStroke(keyCode: 33, modifiers: 57)
            case Self.braceClose: return KeyStroke(keyCode: 30, modifiers: 57)
            case Self.verticalBar: return KeyStroke(keyCode: 42, modifiers: 57)
            
            // Forth row lowercase
            case Self.capsLock: return KeyStroke(keyCode: 57)
            case Self.a: return KeyStroke(keyCode: 0)
            case Self.s: return KeyStroke(keyCode: 1)
            case Self.d: return KeyStroke(keyCode: 2)
            case Self.f: return KeyStroke(keyCode: 3)
            case Self.g: return KeyStroke(keyCode: 5)
            case Self.h: return KeyStroke(keyCode: 4)
            case Self.j: return KeyStroke(keyCode: 38)
            case Self.k: return KeyStroke(keyCode: 40)
            case Self.l: return KeyStroke(keyCode: 37)
            case Self.semicolon: return KeyStroke(keyCode: 41)
            case Self.singleQuotationMark: return KeyStroke(keyCode: 39)
            case Self.return: return KeyStroke(keyCode: 36)
            // Forth row uppercase
            case Self.aUp: return KeyStroke(keyCode: 0, modifiers: 57)
            case Self.sUp: return KeyStroke(keyCode: 1, modifiers: 57)
            case Self.dUp: return KeyStroke(keyCode: 2, modifiers: 57)
            case Self.fUp: return KeyStroke(keyCode: 3, modifiers: 57)
            case Self.gUp: return KeyStroke(keyCode: 5, modifiers: 57)
            case Self.hUp: return KeyStroke(keyCode: 4, modifiers: 57)
            case Self.jUp: return KeyStroke(keyCode: 38, modifiers: 57)
            case Self.kUp: return KeyStroke(keyCode: 40, modifiers: 57)
            case Self.lUp: return KeyStroke(keyCode: 37, modifiers: 57)
            case Self.colon: return KeyStroke(keyCode: 41, modifiers: 57)
            case Self.doubleQuotationMark: return KeyStroke(keyCode: 39, modifiers: 57)
            case Self.enter: return KeyStroke(keyCode: 76)
            
            // Fifth row lowercase
            case Self.shiftLeft: return KeyStroke(keyCode: 57)
            case Self.z: return KeyStroke(keyCode: 6)
            case Self.x: return KeyStroke(keyCode: 7)
            case Self.c: return KeyStroke(keyCode: 8)
            case Self.v: return KeyStroke(keyCode: 9)
            case Self.b: return KeyStroke(keyCode: 11)
            case Self.n: return KeyStroke(keyCode: 45)
            case Self.m: return KeyStroke(keyCode: 46)
            case Self.comma: return KeyStroke(keyCode: 43)
            case Self.period: return KeyStroke(keyCode: 47)
            case Self.slash: return KeyStroke(keyCode: 44)
            case Self.shiftRight: return KeyStroke(keyCode: 60)
            // Fifth row uppercase
            case Self.zUp: return KeyStroke(keyCode: 6, modifiers: 57)
            case Self.xUp: return KeyStroke(keyCode: 7, modifiers: 57)
            case Self.cUp: return KeyStroke(keyCode: 8, modifiers: 57)
            case Self.vUp: return KeyStroke(keyCode: 9, modifiers: 57)
            case Self.bUp: return KeyStroke(keyCode: 11, modifiers: 57)
            case Self.nUp: return KeyStroke(keyCode: 45, modifiers: 57)
            case Self.mUp: return KeyStroke(keyCode: 46, modifiers: 57)
            case Self.lessThan: return KeyStroke(keyCode: 43, modifiers: 57)
            case Self.greaterThan: return KeyStroke(keyCode: 47, modifiers: 57)
            case Self.questionMark: return KeyStroke(keyCode: 44, modifiers: 57)
            
            // Sixth row
            case Self.fn: return KeyStroke(keyCode: 63)
            case Self.control: return KeyStroke(keyCode: 59)
            case Self.optionLeft: return KeyStroke(keyCode: 58)
            case Self.command: return KeyStroke(keyCode: 55)
            case Self.space: return KeyStroke(keyCode: 49)
            case Self.optionRight: return KeyStroke(keyCode: 61)
            case Self.left: return KeyStroke(keyCode: 123)
            case Self.down: return KeyStroke(keyCode: 125)
            case Self.up: return KeyStroke(keyCode: 126)
            case Self.right: return KeyStroke(keyCode: 124)
        }
    }
}
