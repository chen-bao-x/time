//
//  AppDelegate.swift
//  time
//
//  Created by chenbao on 9/7/24.
//
//
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    let mainWindow: MainWindow

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
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
