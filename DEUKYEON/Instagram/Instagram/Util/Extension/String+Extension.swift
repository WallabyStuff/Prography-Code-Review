//
//  String+Extension.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

import Foundation

extension String {
  
  /// 업로드 시간과 현재 시간 비교하여 String 만들어 주기
  /// Example `3 hours ago`
  func toDiff() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let updatedDate = dateFormatter.date(from: self)!
    let currentDate = Date()
    
    let calendar = Calendar.current
    let diff = calendar.dateComponents([.year , .month , .day , .hour, .minute], from: updatedDate , to: currentDate)
    
    if let year = diff.year, year > 0 {
      return "\(year) \(year == 1 ? "year" : "years") ago"
    }
    
    if let month = diff.month, month > 0 {
      return "\(month) \(month == 1 ? "month" : "months") ago"
    }
    
    if let day = diff.day, day > 0 {
      return "\(day) \(day == 1 ? "day" : "days") ago"
    }
    
    if let hour = diff.hour, hour > 0 {
      return "\(hour) \(hour == 1 ? "hour" : "hours") ago"
    }
    
    if let minute = diff.minute, minute > 0   {
      return "\(minute) \(minute == 1 ? "minute" : "minutes") ago"
    }
    return "1 minute ago"
  }
}


