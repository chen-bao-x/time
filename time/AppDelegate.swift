//
//  AppDelegate.swift
//  time
//
//  Created by chenbao on 9/7/24.
//
//
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    let mainWindow: MainWindow!

    override init() {
        // 获取屏幕尺寸
        let screen = NSScreen.main ?? NSScreen.screens[0]
        let screenSize = screen.visibleFrame.size

        // 计算窗口的合适尺寸
        let windowWidth = min(screenSize.width * 0.8, 970)
        let windowHeight = min(screenSize.height * 0.8, 640)

        // 创建 MainWindow 实例并设置合适的尺寸
        self.mainWindow = MainWindow()
        self.mainWindow.setContentSize(NSSize(width: windowWidth, height: windowHeight))

        super.init()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.mainWindow.center() // 将窗口置于屏幕正中间

        self.mainWindow.makeKeyAndOrderFront(nil)
        self.mainWindow.orderFrontRegardless()

        self.setupGlobalShortcut()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func show() {
        self.mainWindow.center() // 将窗口置于屏幕正中间

        // Moves the window to the front of the screen list, within its level, and makes it the key window; that is, it shows the window.
        self.mainWindow.makeKeyAndOrderFront(nil)

        self.mainWindow.orderFrontRegardless()
    }
}

extension AppDelegate {
    private func setupGlobalShortcut() {
        // 全局快捷键  addGlobalMonitorForEvents

        _ = NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            [weak self] event in

            if event.modifierFlags.contains(.command) && event.keyCode == 0 { // Command + Space
                self?.show()
                return nil // 就是我们需要的快捷键, 截断事件.
            }

            if event.modifierFlags.contains(.command) && event.keyCode == keycode.w.rawValue { // Command + Space
                self?.mainWindow.close()
                return nil // 就是我们需要的快捷键, 截断事件.
            }

            if event.modifierFlags.contains([.command, .control])
                && event.keyCode == keycode.f.rawValue {
                self?.mainWindow.toggleFullScreen(nil)
                return nil // 就是我们需要的快捷键, 截断事件.
            }

            if event.modifierFlags.contains([.command]) && event.keyCode == keycode.m.rawValue {
                self?.mainWindow.miniaturize(nil)
                return nil // 就是我们需要的快捷键, 截断事件.
            }

            return event // 不是我们需要的快捷键, 交友其他后续的 monitor 们来处理
        }

        // 鼠标移动到左上角时显示 贯标按钮
        _ = NSEvent.addLocalMonitorForEvents(matching: .mouseMoved) {
            [weak self] event in

            if l(x: event.locationInWindow.x, y: event.locationInWindow.y) {
                self?.mainWindow.standardWindowButton(.closeButton)?.isHidden = false
                self?.mainWindow.standardWindowButton(.miniaturizeButton)?.isHidden = false
                self?.mainWindow.standardWindowButton(.zoomButton)?.isHidden = false
            } else {
                self?.mainWindow.standardWindowButton(.closeButton)?.isHidden = true
                self?.mainWindow.standardWindowButton(.miniaturizeButton)?.isHidden = true
                self?.mainWindow.standardWindowButton(.zoomButton)?.isHidden = true
            }

            print(
                """
                x: \(event.locationInWindow.x)
                y: \(event.locationInWindow.y)
                """
            )

            func l(x: Double, y: Double) -> Bool {
                let windowHeight = self?.mainWindow.frame.height ?? 0

                let a = (x < 80) && (x > 0)

                let b = (y > windowHeight - 40) && (y < windowHeight)

                return (a && b)
            }

            print(event.locationInWindow)
            return event
        }
    }
}

enum keycode: UInt16 {
    case a = 0
    case b = 11
    case c = 8
    case d = 2
    case e = 14
    case f = 3
    case g = 5
    case h = 4
    case i = 34
    case j = 38
    case k = 40
    case l = 37
    case m = 46
    case n = 45
    case o = 31
    case p = 35
    case q = 12
    case r = 15
    case s = 1
    case t = 17
    case u = 32
    case v = 9
    case w = 13
    case x = 7
    case y = 16
    case z = 6
    case left = 123
    case right = 124
    case down = 125
    case up = 126
    case delete = 51
    case `return` = 36
    case tab = 48
    case space = 49
    case escape = 53
    case command = 55
    case shift = 56
    case capsLock = 57
    case option = 58
    case control = 59
    case rightShift = 60
    case rightOption = 61
    case rightControl = 62
    case function = 63
    case f1 = 122
    case f2 = 120
    case f3 = 99
    case f4 = 118
    case f5 = 96
    case f6 = 97
    case f7 = 98
    case f8 = 100
    case f9 = 101
    case f10 = 109
    case f11 = 103
    case f12 = 111
}
