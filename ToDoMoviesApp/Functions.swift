

import Foundation

var dateFormatterFromString: DateFormatter = {
   let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd"
    //formatter.dateStyle = .medium
    return formatter
}()

var dateFormatterToString: DateFormatter = {
   let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

