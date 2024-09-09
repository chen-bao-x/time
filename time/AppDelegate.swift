//
//  AppDelegate.swift
//  time
//
//  Created by chenbao on 9/7/24.
//
//
import Cocoa
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    //    let mainWindow: MainWindow!
    var mainWindow: NSWindow // MainWindow | fullScreenCoverWindow

    override init() {
        self.mainWindow = fullScreenCoverWindow()
        super.init()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.show()

        self.setupGlobalShortcut()
    }

    // 当应用程序终止之前调用.
    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    // 当最后一个窗口关闭时, 应用程序应该终止.
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    // app active 之后调用.
    func applicationDidBecomeActive(_ notification: Notification) {
    }

    // app deactive 之前调用.
    func applicationWillResignActive(_ notification: Notification) {
        //  如果是 fullScreenCoverWindow 的话,
        if self.mainWindow is fullScreenCoverWindow {
            //  就始终保持 active.
            app.activate(ignoringOtherApps: true)
        }
    }

    func show() {
        self.mainWindow.center() // 将窗口置于屏幕正中间

        // 该应用程序不会出现在 Dock 中，也没有菜单栏，但可以通过编程方式或单击其某个窗口来激活它。
        app.setActivationPolicy(.accessory)

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

            // 如果是全屏的话, 按任意键
            if let self = self, self.mainWindow is fullScreenCoverWindow {
                self.mainWindow.close()

                return nil
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

            func l(x: Double, y: Double) -> Bool {
                let windowHeight = self?.mainWindow.frame.height ?? 0

                let a = (x < 80) && (x > 0)

                let b = (y > windowHeight - 40) && (y < windowHeight)

                return (a && b)
            }

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
