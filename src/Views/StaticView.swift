//
//  StaticView.swift
//  finalApp
//
//  Created by musel on 2022/11/17.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

/*   VStack{

HStack{
    Button(
        action: {self.type="user"},
    label: {
    ZStack {
            Circle()
            .frame(width: 100, height: 100)
                .foregroundColor((self.type=="user") ? Color.blue : Color.gray.opacity(0.25))
        VStack{
        Image(systemName: "tray.and.arrow.up")
            .font(.system(size: 20))
            .foregroundColor(Color.white)
            //.padding(10)
        Text("我是商家")
            .foregroundColor(Color.white)
            .font(.system(size: 17))
    }
        }.frame(width: 40, height: 40)}).padding(80)
    
    Spacer()
    
    Button(
        action: {self.type="manager"},
    label: {
    ZStack {
        Circle()
        .frame(width: 100, height: 100)
        .foregroundColor((self.type=="manager") ? Color.blue : Color.gray.opacity(0.25))
        VStack{
        Image(systemName: "tray.and.arrow.up")
            .font(.system(size: 20))
            .foregroundColor(Color.white)
            //.padding(10)
        Text("我是用户")
            .foregroundColor(Color.white)
            .font(.system(size: 17))}
    }
    .frame(width: 40, height: 40)}).padding(80)
}

HStack{
    Text("请输入用户名：")
    TextField("用户名", text:self.$nameText)
}.alert(isPresented: self.$nameHasnotAlert) {
    Alert(
    title: Text("用户名不存在"),  dismissButton:
    .default(Text("确定"))
     
    )
}

HStack{
    Text("请输入密码：")
    TextField("密码", text:self.$keyword)
}.alert(isPresented: self.$keywordErrorAlert) {
    Alert(
    title: Text("密码不正确"),  dismissButton:
    .default(Text("确定"))
     
    )
}

HStack{
    Button(
        action: self.loginUser,
    label: {
    VStack {
        Image(systemName: "tray.and.arrow.up")
            .font(.system(size: 20))
            .foregroundColor(Color.orange.opacity(0.85))
            //.padding(10)
        Text("登录")
            .foregroundColor(Color.orange.opacity(0.85))
            .font(.system(size: 17))
    }
    .frame(width: 40, height: 40)})
    .alert(isPresented: self.$nameEmptyAlert) {
        Alert(
        title: Text("用户名不能为空"),  dismissButton:
        .default(Text("确定"))
         
        )
    }

    
    
    
    Button(
        action: self.registerUser,
    label: {
    VStack {
        Image(systemName: "tray.and.arrow.up")
            .font(.system(size: 20))
            .foregroundColor(Color.orange.opacity(0.85))
            //.padding(10)
        Text("注册")
            .foregroundColor(Color.orange.opacity(0.85))
            .font(.system(size: 17))
    }
    .frame(width: 40, height: 40)}).alert(isPresented: self.$nameHasAlert) {
        Alert(
        title: Text("用户名重复"),dismissButton:
        .default(Text("确定"))
         
        )
    }
}
        }*/

struct ActivityLog {
    var distance: Double // Miles
    var duration: Double // Seconds
    var elevation: Double // Feet
    var date: Date
}

class ActivityTestData {
    static let testData: [ActivityLog] = [
            ActivityLog(distance: 1.77, duration: 2100, elevation: 156, date: Date(timeIntervalSince1970: 1609282718)),
            ActivityLog(distance: 3.01, duration: 2800, elevation: 156, date: Date(timeIntervalSince1970: 1607813915)),
            ActivityLog(distance: 8.12, duration: 3400, elevation: 156, date: Date(timeIntervalSince1970: 1607381915)),
            ActivityLog(distance: 2.22, duration: 3400, elevation: 156, date: Date(timeIntervalSince1970: 1606604315)),
            ActivityLog(distance: 3.12, duration: 3400, elevation: 156, date: Date(timeIntervalSince1970: 1606604315)),
            ActivityLog(distance: 9.01, duration: 3200, elevation: 156, date: Date(timeIntervalSince1970: 1605653915)),
            ActivityLog(distance: 7.20, duration: 3400, elevation: 156, date: Date(timeIntervalSince1970: 1605653915)),
            ActivityLog(distance: 4.76, duration: 3200, elevation: 156, date: Date(timeIntervalSince1970: 1604876315)),
            ActivityLog(distance: 12.12, duration: 2100, elevation: 156, date: Date(timeIntervalSince1970: 1604876315)),
            ActivityLog(distance: 6.01, duration: 3400, elevation: 156, date: Date(timeIntervalSince1970: 1604185115)),
            ActivityLog(distance: 8.20, duration: 3400, elevation: 156, date: Date(timeIntervalSince1970: 1603234715)),
            ActivityLog(distance: 4.76, duration: 2100, elevation: 156, date: Date(timeIntervalSince1970: 1603234715))
    ]
}

struct ActivityGraph: View {
    
    var logs: [ActivityLog]
    @Binding var selectedIndex: Int
    
    /*init(logs: [ActivityLog], selectedIndex: Binding<Int>) {
        self._selectedIndex = selectedIndex
        self.logs = logs // 我们接下来将对日志进行分组
    }*/
    
    @State var lineOffset: CGFloat = 8 // 垂直线的偏移量
    @State var selectedXPos: CGFloat = 8 // 手势位置X点
    @State var selectedYPos: CGFloat = 0 // 手势位置Y点
    @State var isSelected: Bool = false // 用户是否触摸图形
    
    
    init(logs: [ActivityLog], selectedIndex: Binding<Int>) {
        self._selectedIndex = selectedIndex
        
        let curr = Date() // 今天的日期
        // 按时间顺序对日志进行排序
        let sortedLogs = logs.sorted { (log1, log2) -> Bool in
            log1.date > log2.date
        }
        
        var mergedLogs: [ActivityLog] = []
        
         // 回顾过去12周的情况
        for i in 0..<12 {

            var weekLog: ActivityLog = ActivityLog(distance: 0, duration: 0, elevation: 0, date: Date())

            for log in sortedLogs {
                // 如果日志在特定的星期内，那么添加到每周总数
                if log.date.distance(to: curr.addingTimeInterval(TimeInterval(-604800 * i))) < 604800 && log.date < curr.addingTimeInterval(TimeInterval(-604800 * i)) {
                    weekLog.distance += log.distance
                    weekLog.duration += log.duration
                    weekLog.elevation += log.elevation
                }
            }

            mergedLogs.insert(weekLog, at: 0)
        }

        self.logs = mergedLogs
    }
    
    var body: some View {
        drawGrid()
        .opacity(0.2)
        .overlay(drawActivityGradient(logs: logs))
        //.overlay(drawActivityLine(logs: logs))
        //.overlay(drawLogPoints(logs: logs))
        //.overlay(addUserInteraction(logs: logs))
    }
}
func drawGrid() -> some View {
    VStack(spacing: 0) {
        Color.black.frame(height: 1, alignment: .center)
        HStack(spacing: 0) {
            Color.clear
                .frame(width: 8, height: 100)
            ForEach(0..<11) { i in
                Color.black.frame(width: 1, height: 100, alignment: .center)
                Spacer()

            }
            Color.black.frame(width: 1, height: 100, alignment: .center)
            Color.clear
                .frame(width: 8, height: 100)
        }
        Color.black.frame(height: 1, alignment: .center)
    }
}

func drawActivityGradient(logs: [ActivityLog]) -> some View {
    LinearGradient(gradient: Gradient(colors: [Color(red: 251/255, green: 82/255, blue: 0), .black]), startPoint: .top, endPoint: .bottom)
        .padding(.horizontal, 8)
        .padding(.bottom, 1)
        .opacity(0.8)
        .mask(
            GeometryReader { geo in
                Path { p in
                    // 用于视图缩放的数据
                    let maxNum = logs.reduce(0) { (res, log) -> Double in
                        return max(res, log.distance)
                    }

                    let scale = geo.size.height / CGFloat(maxNum)

                    //每个周的绘制索引 (0-11)
                    var index: CGFloat = 0

                    // 添加绘制的起始的x,y点坐标
                    p.move(to: CGPoint(x: 8, y: geo.size.height - (CGFloat(logs[Int(index)].distance) * scale)))

                    // 绘制添加线
                    for _ in logs {
                        if index != 0 {
                            p.addLine(to: CGPoint(x: 8 + ((geo.size.width - 16) / 11) * index, y: geo.size.height - (CGFloat(logs[Int(index)].distance) * scale)))
                        }
                        index += 1
                    }

                    // 形成闭环路径
                    p.addLine(to: CGPoint(x: 8 + ((geo.size.width - 16) / 11) * (index - 1), y: geo.size.height))
                    p.addLine(to: CGPoint(x: 8, y: geo.size.height))
                    p.closeSubpath()
                }
            }
        )
}

func drawActivityLine(logs: [ActivityLog]) -> some View {
    GeometryReader { geo in
        Path { p in
            let maxNum = logs.reduce(0) { (res, log) -> Double in
                return max(res, log.distance)
            }

            let scale = geo.size.height / CGFloat(maxNum)
            var index: CGFloat = 0

            p.move(to: CGPoint(x: 8, y: geo.size.height - (CGFloat(logs[0].distance) * scale)))

            for _ in logs {
                if index != 0 {
                    p.addLine(to: CGPoint(x: 8 + ((geo.size.width - 16) / 11) * index, y: geo.size.height - (CGFloat(logs[Int(index)].distance) * scale)))
                }
                index += 1
            }
        }
        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0))
        .foregroundColor(Color(red: 251/255, green: 82/255, blue: 0))
    }
}
/*
func drawLogPoints(logs: [ActivityLog]) -> some View {
    GeometryReader { geo in

        let maxNum = logs.reduce(0) { (res, log) -> Double in
            return max(res, log.distance)
        }

        let scale = geo.size.height / CGFloat(maxNum)

        ForEach(logs.indices) { i in
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0))
                .frame(width: 10, height: 10, alignment: .center)
                .foregroundColor(Color(red: 251/255, green: 82/255, blue: 0))
                .background(Color.white)
                .cornerRadius(5)
                .offset(x: 8 + ((geo.size.width - 16) / 11) * CGFloat(i) - 5, y: (geo.size.height - (CGFloat(logs[i].distance) * scale)) - 5)
        }
    }
}

func addUserInteraction(logs: [ActivityLog]) -> some View {
    GeometryReader { geo in

        let maxNum = logs.reduce(0) { (res, log) -> Double in
            return max(res, log.distance)
        }

        
            let hcg = CGFloat(maxNum)
        let scale = geo.size.height / hcg

        ZStack(alignment: .leading) {
            // 线和点叠加
            Color(red: 251/255, green: 82/255, blue: 0)
                .frame(width: 2)
                .overlay(
                    Circle()
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(Color(red: 251/255, green: 82/255, blue: 0))
                        .opacity(0.2)
                        .overlay(
                            Circle()
                                .fill()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(Color(red: 251/255, green: 82/255, blue: 0))
                        )
                        .offset(x: 0, y: isSelected ? 12 - (selectedYPos * scale) : 12 - (CGFloat(logs[selectedIndex].distance) * scale))
                    , alignment: .bottom)

                .offset(x: isSelected ? lineOffset : 8 + ((geo.size.width - 16) / 11) * CGFloat(selectedIndex), y: 0)
                .animation(Animation.spring().speed(4))

            // 添加拖动手势代码
            Color.white.opacity(0.1)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { touch in
                                let xPos = touch.location.x
                                self.isSelected = true
                                let index = (xPos - 8) / (((geo.size.width - 16) / 11))

                                if index > 0 && index < 11 {
                                    let m = (logs[Int(index) + 1].distance - logs[Int(index)].distance)
                                    self.selectedYPos = CGFloat(m) * index.truncatingRemainder(dividingBy: 1) + CGFloat(logs[Int(index)].distance)
                                }


                                if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < 11 {
                                    self.selectedIndex = Int(index) + 1
                                } else {
                                    self.selectedIndex = Int(index)
                                }
                                self.selectedXPos = min(max(8, xPos), geo.size.width - 8)
                                self.lineOffset = min(max(8, xPos), geo.size.width - 8)
                            }
                            .onEnded { touch in
                                let xPos = touch.location.x
                                self.isSelected = false
                                let index = (xPos - 8) / (((geo.size.width - 16) / 11))

                                if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < 11 {
                                    self.selectedIndex = Int(index) + 1
                                } else {
                                    self.selectedIndex = Int(index)
                                }
                            }
                    )
            }
     }
    }
}
*/
struct ActivityHistoryText: View {

var logs: [ActivityLog]
var mileMax: Int

@Binding var selectedIndex: Int

var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd"
    return formatter
}

init(logs: [ActivityLog], selectedIndex: Binding<Int>) {
    self._selectedIndex = selectedIndex
    
    let curr = Date() // 当前日期
    let sortedLogs = logs.sorted { (log1, log2) -> Bool in
        log1.date > log2.date
    } // 按时间顺序对日志进行排序
    
    var mergedLogs: [ActivityLog] = []

    for i in 0..<12 {

        var weekLog: ActivityLog = ActivityLog(distance: 0, duration: 0, elevation: 0, date: Date())

        for log in sortedLogs {
            if log.date.distance(to: curr.addingTimeInterval(TimeInterval(-604800 * i))) < 604800 && log.date < curr.addingTimeInterval(TimeInterval(-604800 * i)) {
                weekLog.distance += log.distance
                weekLog.duration += log.duration
                weekLog.elevation += log.elevation
            }
        }

        mergedLogs.insert(weekLog, at: 0)
    }

    self.logs = mergedLogs
    self.mileMax = Int(mergedLogs.max(by: { $0.distance < $1.distance })?.distance ?? 0)
}

var body: some View {
    VStack(alignment: .leading, spacing: 16) {
        Text("\(dateFormatter.string(from: logs[selectedIndex].date.addingTimeInterval(-604800))) - \(dateFormatter.string(from: logs[selectedIndex].date))".uppercased())
            .font(Font.body.weight(.heavy))
        
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Distance")
                    .font(.caption)
                    .foregroundColor(Color.black.opacity(0.5))
                Text(String(format: "%.2f mi", logs[selectedIndex].distance))
                    .font(Font.system(size: 20, weight: .medium, design: .default))
            }
            
            Color.gray
                .opacity(0.5)
                .frame(width: 1, height: 30, alignment: .center)
                
            VStack(alignment: .leading, spacing: 4) {
                Text("Time")
                    .font(.caption)
                    .foregroundColor(Color.black.opacity(0.5))
                Text(String(format: "%.0fh", logs[selectedIndex].duration / 3600) + String(format: " %.0fm", logs[selectedIndex].duration.truncatingRemainder(dividingBy: 3600) / 60))
                    .font(Font.system(size: 20, weight: .medium, design: .default))
            }
            
            Color.gray
                .opacity(0.5)
                .frame(width: 1, height: 30, alignment: .center)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Elevation")
                    .font(.caption)
                    .foregroundColor(Color.black.opacity(0.5))
                Text(String(format: "%.0f ft", logs[selectedIndex].elevation))
                    .font(Font.system(size: 20, weight: .medium, design: .default))
            }
            
            Spacer()
        }
        
        VStack(alignment: .leading, spacing: 5) {
            Text("LAST 12 WEEKS")
                .font(Font.caption.weight(.heavy))
                .foregroundColor(Color.black.opacity(0.7))
            Text("\(mileMax) mi")
                .font(Font.caption)
                .foregroundColor(Color.black.opacity(0.5))
        }.padding(.top, 10)
        
        
    }
    }}
