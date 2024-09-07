//
//  MainWindow.swift
//  time
//
//  Created by chenbao on 9/7/24.
//

// MainWindow.swift
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

        self.titlebarAppearsTransparent = true // 设置 titlebarAppearsTransparent 为 true，使标题栏透明
        self.isOpaque = false // 让整个窗口都变透明
        self.backgroundColor = .clear
        self.titleVisibility = .hidden // 设置 titleVisibility 为 .hidden，隐藏标题, 保留 close button

        // 设置最小尺寸
        self.minSize = NSSize(width: 400, height: 300)

        // 设置 contentView
        self.contentView = NSHostingView(rootView: ContentView())
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
            }, label: {
                Text("Button")
            })
            .border(Color.black, width: 2)

            Text("你好，世界！")
                .frame(maxHeight: .infinity)
        }

        .background {
            AsyncImage(url: .init(URL(fileURLWithPath: "/Users/chenbao/Downloads/林黛玉武侠图-2.jpeg"))) { img in
                img.resizable()
                    .scaledToFill()
                    .opacity(0.2)
            } placeholder: {
                EmptyView()
            }
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
