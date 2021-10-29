//
//  DateConverter.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import Foundation

func dateToString(date: Date) -> String{
    let calendar = Calendar.current
    
    if calendar.isDateInToday(date){
        return "Today"
        
    }else if calendar.isDateInYesterday(date){
        return "Yesterday"
        
    }else{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}


func timestampToDate(timestamp: String) -> String{
    
    let dateStringFormatter = DateFormatter()
    dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let d = dateStringFormatter.date(from: timestamp)
    
    if let d = d {
        return dateToString(date: d)
    }
    
    return timestamp
}
