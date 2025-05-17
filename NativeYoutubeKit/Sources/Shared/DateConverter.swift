import Foundation

public struct DateConverter {
    public static func dateToString(date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
    }
    
    public static func timestampToDate(timestamp: String) -> String {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateStringFormatter.date(from: timestamp)
        
        if let date = date {
            return dateToString(date: date)
        }
        
        return timestamp
    }
}