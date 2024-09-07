//
//  ContentView.swift
//  time
//
//  Created by chenbao on 9/7/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(spacing: 0) {
            Group {
                Text(week(date: Date()))
                    .foregroundColor(.gray)

                Text(Date(), style: .time)
                    .font(.custom("SF Compact Display", size: 240).weight(.black).width(.standard))

                //                    .font(.system(size: 240, weight: .black, design: .default))

                Text(lunarYearMonthDay(date: Date()))
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)

                Text(Date(), style: .date)
                    .foregroundColor(.gray)
            }
            .font(.system(size: 60, weight: .bold, design: .rounded))
            .environment(\.locale, .init(identifier: "zh_CN"))
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

        .background {
            colorScheme == .dark ? Color.black : Color.white
            // AsyncImage(url: .init(URL(fileURLWithPath: "/Users/chenbao/Downloads/林黛玉武侠图-2.jpeg"))) {
            //     img in
            //     img.resizable()
            //         .scaledToFill()

            // } placeholder: {
            
            //     EmptyView()
            // }
        }
        .ignoresSafeArea(.all)
        //        .overlay(alignment: .topLeading) {
        //            CloseButtons()
        //        }
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
