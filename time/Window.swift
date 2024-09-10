//
//  Winndow.swift
//  time
//
//  Created by chenbao on 9/10/24.
//

import Cocoa
import SwiftUI

/* --- WindowManager --- */

class WindowManager: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        // 在这里进行窗口加载后的初始化
    }

    // 可以添加其他自定义方法
}

/* --- fullScreenCoverWindow --- */

class fullScreenCoverWindow: NSWindow {
    init() {
        // 获取屏幕尺寸
        let screen = NSScreen.main ?? NSScreen.screens[0]

        let screenFrame = screen.frame  // 这里使用 frame 而不是 visibleFrame
        let fullFrame = NSRect(
            x: screenFrame.origin.x, y: screenFrame.origin.y, width: screenFrame.width,
            height: screenFrame.height)

        super.init(
            contentRect: fullFrame,
            styleMask: [
                .hudWindow

            ],
            backing: .buffered,
            defer: false
        )

        // 设置 contentView
        self.contentView = NSHostingView(rootView: RootView())

        // 设置窗口级别为最高
        self.level = .screenSaver  // .screenSaver 的级别太高了, 连 window switcher 都挡住了.

        // 防止窗口在应用程序失去焦点时隐藏
        self.hidesOnDeactivate = false
        self.backgroundColor = .clear
        // 隐藏菜单栏
        // NSMenu.setMenuBarVisible(false) // 当 fullScreenCoverWindow 全屏时隐藏菜单栏.

        // 可选：如果您希望窗口始终置顶，即使在切换应用程序时也是如此
        // 允许 这个 fullScreenCoverWindow 跑到其它已经 fullscreen 的 app 的桌面里面去把它给挡住 😁
        self.collectionBehavior = [
            .fullScreenPrimary,
            .canJoinAllSpaces,
            .canJoinAllApplications,
            .stationary,
            .ignoresCycle,
        ]

        // 注意：这将影响整个应用程序的菜单栏可见性
        // 如果只想在这个窗口中隐藏菜单栏，可以考虑使用全屏模式或自定义窗口样式
        // 当用户切换桌面时，将我的 app 移动到那个桌面
        self.moveToActiveSpace(allowOverFullscreen: true, completion: nil)
        //        只看时间, 还是不遮挡得好.
    }
}

//
//  NSWindow+MoveToActiveSpace.swift
//  Calculate
//
//  Created by David Brackeen on 4/5/20.
//  Copyright © 2020 David Brackeen. All rights reserved.
//
// https://github.com/brackeen/calculate-widget/blob/master/Calculate/NSWindow%2BMoveToActiveSpace.swift
extension NSWindow {
    /**
     Moves the window to the active space, allowing it to appear on top of full screen windows.
     Note: This window should not have the .moveToActiveSpace collection behavior at all times because
     this causes window ordering issues when switching spaces.

     Tested on macOS 11 (Big Sur).
     */
    func moveToActiveSpace(allowOverFullscreen: Bool = true, completion: (() -> Void)? = nil) {
        let willMoveToFullScreenSpace =
            allowOverFullscreen && NSWorkspace.shared.isActiveSpaceFullScreen()

        if NSApp.activationPolicy() != .regular || isOnActiveSpace
            || (!NSApp.isHidden && !isVisible && !willMoveToFullScreenSpace)
        {
            NSApp.activate(ignoringOtherApps: true)
            completion?()
        } else if !NSApp.isHidden && willMoveToFullScreenSpace {
            DispatchQueue.main.async {
                self.moveToActiveSpaceImpl(
                    willMoveToFullScreenSpace: willMoveToFullScreenSpace, completion: completion)
            }
        } else {
            orderFront(NSApp)
            self.moveToActiveSpaceImpl(
                willMoveToFullScreenSpace: willMoveToFullScreenSpace, completion: completion)
        }
    }

    //    private

    func moveToActiveSpaceImpl(
        willMoveToFullScreenSpace: Bool, completion: (() -> Void)? = nil
    ) {
        let originalWindowCollectionBehavior = collectionBehavior
        if willMoveToFullScreenSpace {
            NSApp.setActivationPolicy(.accessory)
            collectionBehavior = [.moveToActiveSpace]
            NSApp.unhideWithoutActivation()
            NSApp.hide(nil)
            NSApp.setActivationPolicy(.regular)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NSApp.activate(ignoringOtherApps: true)
                DispatchQueue.main.async {
                    self.collectionBehavior = originalWindowCollectionBehavior
                    completion?()
                }
            }
        } else {
            collectionBehavior = [.moveToActiveSpace]
            NSApp.activate(ignoringOtherApps: true)
            DispatchQueue.main.async {
                self.collectionBehavior = originalWindowCollectionBehavior
                completion?()
            }
        }
    }
}

extension NSWorkspace {
    func isActiveSpaceFullScreen() -> Bool {
        guard
            let winInfoArray = CGWindowListCopyWindowInfo(
                [.excludeDesktopElements, .optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]]
        else {
            return false
        }
        for winInfo in winInfoArray {
            guard let windowLayer = winInfo[kCGWindowLayer as String] as? NSNumber, windowLayer == 0
            else {
                continue
            }
            guard let boundsDict = winInfo[kCGWindowBounds as String] as? [String: Any],
                let bounds = CGRect(dictionaryRepresentation: boundsDict as CFDictionary)
            else {
                continue
            }
            if bounds.size == NSScreen.main?.frame.size {
                return true
            }
        }
        return false
    }
}

/* --- MainWindow --- */

class MainWindow: NSWindow {
    init() {
        // 获取屏幕尺寸
        let screen = NSScreen.main ?? NSScreen.screens[0]
        let screenSize = screen.visibleFrame.size

        // 计算窗口的合适尺寸
        let windowWidth = min(screenSize.width * 0.8, 970)
        let windowHeight = min(screenSize.height * 0.8, 640)

        super.init(
            contentRect: NSRect(x: 0, y: 0, width: windowWidth, height: windowHeight),
            styleMask: [
                .titled,  // 显示标题栏
                .closable,  // 允许关闭窗口
                .miniaturizable,  // 允许最小化窗口

                .fullSizeContentView,  // 允许内容视图占据整个窗口，包括标题栏,
                .resizable,  // 允许调整窗口大小     // frame(maxWidth: .infinity, maxHeight: .infinity)
                .borderless,  // 无边框

            ],
            backing: .buffered,
            defer: false
        )

        // 设置 titlebarAppearsTransparent 为 true，使标题栏透明
        self.titlebarAppearsTransparent = true
        // 让整个窗口都变透明
        self.isOpaque = false

        //        self.backgroundColor = .clear // 设置成透明的之后会有严重的卡断,

        self.titleVisibility = .hidden  // 设置 titleVisibility 为 .hidden，隐藏标题, 保留 close button

        // 设置最小尺寸
        self.minSize = NSSize(width: 400, height: 300)

        // 设置 contentView
        self.contentView = NSHostingView(rootView: RootView())

        // 隐藏左上角的三个 红绿灯 按钮.
        self.standardWindowButton(.closeButton)?.isHidden = true
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
    }
}
