//
//  AppDelegate.swift
//  time
//
//  Created by chenbao on 9/7/24.
//
//

import AppKit
import Carbon
import Cocoa
import Combine
import HotKey

class AppDelegate: NSObject, NSApplicationDelegate {
    var windowManager: WindowManager

    var mainWindow: NSWindow! = fullScreenCoverWindow()  // MainWindow | fullScreenCoverWindow

    var statusBarItem: NSStatusItem!  // 要把添加的到 `NSStatusBar.system` 的 statusBarItem store 起来, 才能在 菜单栏图标区 显示此 app 的 `菜单栏图标`.

    // 系统级全局快捷键
    private var hotKey: HotKey?

    static let pub = PassthroughSubject<ShowOrHide, Never>()

    enum ShowOrHide {
        case show
        case hide
    }

    // 窗口组
    var haha: [WindowManager] = []

    override init() {
        self.windowManager = .init(window: self.mainWindow)
        super.init()

        // 注册系统全局快捷键.
        let h = HotKey(keyCombo: KeyCombo(key: .s, modifiers: [.control]))
        h.keyDownHandler = { [weak self] in self?.show() }
        self.hotKey = h
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.show()
        self.setupLocalShortcut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.addMennubarIter()
        }
        app.activate(ignoringOtherApps: true)
    }

    // 当应用程序终止之前调用.
    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    // 当最后一个窗口关闭时, 应用程序应该终止.
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    // app active 之后调用.
    func applicationDidBecomeActive(_ notification: Notification) {
    }

    // app deactive 之前调用.
    func applicationWillResignActive(_ notification: Notification) {
        //  如果是 fullScreenCoverWindow 的话,
        // if self.mainWindow is fullScreenCoverWindow {
        //     //  就始终保持 active. 直到窗口被隐藏.
        //     app.activate(ignoringOtherApps: true)
        // }
    }

    func show() {
        // 隐藏菜单栏
        NSMenu.setMenuBarVisible(false)  // 当 fullScreenCoverWindow 全屏时隐藏菜单栏.

        self.windowManager.window?.center()  // 将窗口置于屏幕正中间

        // 该应用程序不会出现在 Dock 中，也没有菜单栏，但可以通过编程方式或单击其某个窗口来激活它。
        // app.setActivationPolicy(.accessory)

        app.activate(ignoringOtherApps: true)
        self.windowManager.showWindow(self)

        AppDelegate.pub.send(.show)
    }

    func hide() {
        self.windowManager.close()

        // 激活其他应用程序
        app.hide(nil)

        // 显示菜单栏
        NSMenu.setMenuBarVisible(true)  // 当 fullScreenCoverWindow 全屏时隐藏菜单栏.
        AppDelegate.pub.send(.hide)
    }

    @objc func option1Action() {
        // 处理选项1的逻辑
        self.show()
    }

    @objc func option2Action() {
        // 处理选项2的逻辑
        self.hide()
    }
}

extension AppDelegate {
    func addMennubarIter() {
        let systemStatusBar = NSStatusBar.system

        self.statusBarItem = systemStatusBar.statusItem(withLength: NSStatusItem.squareLength)
        if let button = self.statusBarItem.button {
            // button.image = NSImage(
            //     systemSymbolName: "command.square.fill", accessibilityDescription: nil)
            //                       button.image = NSImage(
            //                           contentsOf: URL(fileURLWithPath: "/Users/chenbao/Downloads/林黛玉武侠图-2.jpeg"))
            button.title = "time"
        }

        let menu = NSMenu(title: "菜单")
        menu.addItem(
            NSMenuItem(title: "show", action: #selector(self.option1Action), keyEquivalent: ""))
        menu.addItem(
            NSMenuItem(title: "hide", action: #selector(self.option2Action), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(
            NSMenuItem(
                title: "退出", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        self.statusBarItem.menu = menu
    }
}

extension AppDelegate {
    private func setupLocalShortcut() {
        _ = NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            [weak self] event in

            // 按下 command + H 隐藏窗口
            if event.modifierFlags.contains(.command) && event.keyCode == keycode.h.rawValue {
                self?.hide()
                return nil  // 就是我们需要的快捷键, 截断事件.
            }

            if event.modifierFlags.contains(.command) && event.keyCode == keycode.t.rawValue {  // Option + T
                self?.show()
                return nil  // 就是我们需要的快捷键, 截断事件.
            }

            if event.modifierFlags.contains(.command) && event.keyCode == keycode.w.rawValue {  // Command + Space
                //                self?.mainWindow.close()
                self?.hide()
                return nil  // 就是我们需要的快捷键, 截断事件.
            }

            if event.modifierFlags.contains([.command, .control])
                && event.keyCode == keycode.f.rawValue
            {
                self?.mainWindow.toggleFullScreen(nil)
                return nil  // 就是我们需要的快捷键, 截断事件.
            }

            if event.modifierFlags.contains([.command]) && event.keyCode == keycode.m.rawValue {
                self?.mainWindow.miniaturize(nil)
                return nil  // 就是我们需要的快捷键, 截断事件.
            }

            // 如果是全屏的话, 按任意键
            if let self = self, self.mainWindow is fullScreenCoverWindow {
                // self.mainWindow.close()

                if app.isHidden {
                    self.show()
                } else {
                    self.hide()
                }

                return nil
            }

            return event  // 不是我们需要的快捷键, 交友其他后续的 monitor 们来处理
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
