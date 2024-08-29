//
//  LifeInfoView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/11.
//

import SwiftUI

struct LifeInfoView: View {
    
    let LIFE_EXPECTANCY = 20000
    
    @State private var title = "Jensen Ackles"
    @State private var date = Date()
    
    @State private var edit = false
    @State private var showDatePicker = false
    
    // 计算剩余的天数
    var remainingDays: Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: date, to: now)
        let daysLived = components.day ?? 0
        return min(LIFE_EXPECTANCY - daysLived, LIFE_EXPECTANCY)
    }
    
    // 计算距离下一次生日的天数
    var daysUntilNextBirthday: Int {
        let calendar = Calendar.current
        let now = Date()
        
        // 获取当前日期的年份
        let currentYear = calendar.component(.year, from: now)
        
        // 构建当前年份的生日
        var birthdayComponents = calendar.dateComponents([.month, .day], from: date)
        birthdayComponents.year = currentYear
        
        // 获取当前年份的生日日期
        let birthdayThisYear = calendar.date(from: birthdayComponents)!
        
        // 计算与今年生日的差值
        if now <= birthdayThisYear {
            return calendar.dateComponents([.day], from: now, to: birthdayThisYear).day ?? 0
        } else {
            // 如果已经过了今年的生日，计算到明年生日的天数
            var nextBirthdayComponents = birthdayComponents
            nextBirthdayComponents.year = currentYear + 1
            let birthdayNextYear = calendar.date(from: nextBirthdayComponents)!
            return calendar.dateComponents([.day], from: now, to: birthdayNextYear).day ?? 0
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                HStack {
                    TextField("title", text: $title, prompt: Text("input title"))
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .truncationMode(.tail)
                        .padding()
                        .background(.gray.opacity(edit ? 0.1 : 0), in: RoundedRectangle(cornerRadius: 12))
                        .disabled(!edit)
                }
                
                
                HStack(alignment: .lastTextBaseline) {
                    Text(remainingDays, format: .number.decimalSeparator(strategy: .automatic)).font(.system(size: 40, weight: .bold, design: .rounded))
                    Image(systemName: "questionmark.circle.fill").foregroundStyle(.gray)
                }
                
                HStack {
                    if edit {
                        DatePicker(selection: $date, displayedComponents: [.date], label: {}).fixedSize()
                    } else {
                        Text("\(date.formatted(date: .numeric, time: .omitted))").font(.system(.title3, design: .rounded, weight: .bold))
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .lastTextBaseline) {
                        Text("\(daysUntilNextBirthday)").font(.system(.title, design: .rounded, weight: .bold))
                        Text("days").foregroundStyle(.gray)
                    }
                }
                Spacer()
            }
            .padding()
            .toolbar {
                if edit {
                    Button("Save", action: {
                        withAnimation(.spring(duration: 0.2)) { edit.toggle() }
                    })
                } else {
                    Button("Edit", action: {
                        withAnimation(.spring(duration: 0.2)) { edit.toggle() }
                    })
                }
            }
        }
    }
}

#Preview {
    LifeInfoView()
}
