//
//  MainWindow.swift
//  time
//
//  Created by chenbao on 9/7/24.
//

import AppKit
import SwiftUI

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
                .titled, // 显示标题栏
                .closable, // 允许关闭窗口
                .miniaturizable, // 允许最小化窗口

                .fullSizeContentView, // 允许内容视图占据整个窗口，包括标题栏,
                .resizable, // 允许调整窗口大小     // frame(maxWidth: .infinity, maxHeight: .infinity)
                .borderless, // 无边框

            ],
            backing: .buffered,
            defer: false
        )

        // 设置 titlebarAppearsTransparent 为 true，使标题栏透明
        self.titlebarAppearsTransparent = true
        // 让整个窗口都变透明
        self.isOpaque = false

        //        self.backgroundColor = .clear // 设置成透明的之后会有严重的卡断,

        self.titleVisibility = .hidden // 设置 titleVisibility 为 .hidden，隐藏标题, 保留 close button

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
