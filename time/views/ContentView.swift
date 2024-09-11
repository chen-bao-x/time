//
//  ContentView.swift
//  time
//
//  Created by chenbao on 9/7/24.
//

import Combine
import SwiftUI
import WebKit

struct RootView: View {
    var body: some View {
        ContentView()

        //         WV()
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var date: Date = .init()

    var body: some View {
        VStack(spacing: 10) {
            Text(self.date, style: .time)
                .font(.custom("SF Compact Display", size: 200).weight(.black).width(.standard))

            HStack {
                Text(self.date, style: .date)
                Text(week(date: self.date))
                Text(lunarYearMonthDay(date: self.date))
            }
            .font(.system(size: 30, weight: .medium, design: .rounded))
            .foregroundColor(.gray)
            .environment(\.locale, .init(identifier: "zh_CN"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background {
            colorScheme == .dark ? Color.black : Color.white
            //            AsyncImage(url: .init(URL(fileURLWithPath: "/Users/chenbao/Downloads/林黛玉武侠图-2.jpeg"))) {
            //                img in
            //                img.resizable()
            //                    .scaledToFill()
            //
            //            } placeholder: {
            //                EmptyView()
            //            }
        }

        .ignoresSafeArea(.all)
        .task {
            self.startTimer()
        }
        .onReceive(AppDelegate.pub) { (out: AppDelegate.ShowOrHide) in
            switch out {
            case .show:
                self.startTimer()
            case .hide:
                self.stopTimer()
            }
        }
    }

    @State private var timer: Timer? = .none

    func startTimer() {
        self.timer = Timer.scheduledTimer(
            withTimeInterval: 1, repeats: true,
            block: { t in
                self.date = Date()
                print("timer runing...")

                if self.timer == .none {
                    t.invalidate()
                }
            })

        self.timer?.fire()
    }

    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

/// 获取农历, 节假日名
func lunarYearMonthDay(date: Date) -> String {
    // 初始化农历日历
    let lunarCalendar = Calendar(identifier: .chinese)

    // /// 活得农历年
    let lunarYear = DateFormatter()
    lunarYear.locale = Locale(identifier: "zh_CN")
    lunarYear.dateStyle = .long
    lunarYear.calendar = lunarCalendar
    // lunarYear.dateFormat = ""

    let year = lunarYear.string(from: date)

    // /// 获得农历月
    // let lunarMonth = DateFormatter()
    // lunarMonth.locale = Locale(identifier: "zh_CN")
    // lunarMonth.dateStyle = .medium
    // lunarMonth.calendar = lunarCalendar
    // lunarMonth.dateFormat = "MMM"

    // let month = lunarMonth.string(from: date)

    // // 获得农历日
    // let lunarDay = DateFormatter()
    // lunarDay.locale = Locale(identifier: "zh_CN")
    // lunarDay.dateStyle = .medium
    // lunarDay.calendar = lunarCalendar
    // lunarDay.dateFormat = "d"

    // let day = lunarDay.string(from: date)

    // 返回农历月
    // if day == "初一" {
    //     return month
    // }

    // 返回农历日期
    // return year + " " + month + " " + day
    let a = String(year.dropFirst(4))
    return a
}

func week(date: Date) -> String {
    // 活得阳历 星期
    let formater = DateFormatter()
    formater.locale = Locale(identifier: "zh_CN")
    formater.dateStyle = .long
    formater.calendar = Calendar(identifier: .gregorian)
    formater.dateFormat = "EEEE"

    let weekDay = formater.string(from: date)
    return weekDay
}

struct WV: View {
    var body: some View {
        WebView()
            .clipped()
            .edgesIgnoringSafeArea(.all)
    }

    struct WebView: NSViewRepresentable {
        typealias NSViewType = WKWebView

        let webView: WKWebView

        init() {
            let webConfiguration = WKWebViewConfiguration()
            self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
            self.webView.allowsMagnification = true // 允许双指啮合缩放手势.
        }

        func makeNSView(context: Context) -> WKWebView {
            return self.webView
        }

        func updateNSView(_ nsView: WKWebView, context: Context) {
            //  let htmlPath = "/Users/chenbao/Downloads/cml_nom/.test/out.html"

            //  let url = URL(fileURLWithPath: htmlPath)

            //  let request = URLRequest(url: url)
            //  self.webView.load(request)
            //            self.webView.loadFileURL(url, allowingReadAccessTo: url)

            // if let data = try? String.init(contentsOf: url) {

            //     self.webView.loadHTMLString(data, baseURL: url)
            // }···

            let myURL = URL(string: "https://www.apple.com")
            let myRequest = URLRequest(url: myURL!)
            self.webView.load(myRequest)
        }
    }
}
