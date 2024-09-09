//
//  fullScreenCoverWindow.swift
//  time
//
//  Created by chenbao on 9/8/24.
//

import AppKit
import Cocoa
import SwiftUI

class fullScreenCoverWindow: NSWindow {
    init() {
        // 获取屏幕尺寸
        let screen = NSScreen.main ?? NSScreen.screens[0]

        let screenFrame = screen.frame // 这里使用 frame 而不是 visibleFrame
        let fullFrame = NSRect(
            x: screenFrame.origin.x, y: screenFrame.origin.y, width: screenFrame.width,
            height: screenFrame.height)

        super.init(
            contentRect: fullFrame,
            styleMask: [
                .hudWindow,
            ],
            backing: .buffered,
            defer: false
        )

        // 设置 contentView
        self.contentView = NSHostingView(rootView: RootView())

        // 设置窗口级别为最高
        self.level = .screenSaver // .screenSaver 的级别太高了, 连 window switcher 都挡住了.

        // 防止窗口在应用程序失去焦点时隐藏
        self.hidesOnDeactivate = false

        // 隐藏菜单栏
        NSMenu.setMenuBarVisible(false) // 当 fullScreenCoverWindow 全屏时隐藏菜单栏.

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
            || (!NSApp.isHidden && !isVisible && !willMoveToFullScreenSpace) {
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
