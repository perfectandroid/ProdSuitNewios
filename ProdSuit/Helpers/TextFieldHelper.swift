//
//  TextFieldHelper.swift
//  ProdSuit
//
//  Created by MacBook on 22/02/23.
//

import Foundation
import Combine
import UIKit

var textFieldPublisher:AnyPublisher<String,Never>{
    NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification
        )
        .compactMap { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
}

var textViewPublisher:AnyPublisher<String,Never>{
    NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification)
        .compactMap{( $0.object as? UITextView)?.text }
        .eraseToAnyPublisher()
}

var backGroundPublisher:AnyPublisher<String,Never>{
    NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
        .compactMap{ ($0.object as? String ?? "inactive") }
        .eraseToAnyPublisher()
}

var foreGroundPublisher:AnyPublisher<String,Never>{
    NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
        .compactMap{ ($0.object as? String ?? "active") }
        .eraseToAnyPublisher()
}

struct DateTimeModel{
    
    static let shared = DateTimeModel()
    
    func stringTimeFromDate(_ time:Date)->String{
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = DateFormatter.Style.none

        dateFormatter.timeStyle = DateFormatter.Style.short

        return dateFormatter.string(from: time)
    }
    
    func stringDateFromDate(_ date:Date)->String{
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = DateFormatter.Style.short
        

        dateFormatter.timeStyle = DateFormatter.Style.none
        
        let showDate = dateFormatter.string(from: date)
        
        
        let resultDate = dateFormatter.date(from: showDate)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: resultDate!)
        
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String="yyyy-MM-dd") -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"

        if let date = inputFormatter.date(from: dateString) {

            let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = format
            
            
            return outputFormatter.string(from: date)
        }

        return nil
    }
    
    func changeDateFormate(dateString: String, withFormat format: String="yyyy-MM-dd") -> String{
        let inputFormatter = DateFormatter()
        let outputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"

        var outputDateString = ""
        if let date = inputFormatter.date(from: dateString){

            
        outputFormatter.dateFormat = format
            
            
        outputDateString = outputFormatter.string(from: date)
        }
        
        return outputDateString
    }
    
    func combineDateAndTime(date:String,time:String) -> Date {
        
        let dateString = "\(date) \(time)"
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        print(dateString)
        return dateFormatter.date(from: dateString)!
        
        
    }
    
    func string_Date_From_DateFormate(_ date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        return dateFormatter.string(from: date)
    }
    
    func timeFromString(_ timeString:String)->String?{
        let dateFormatter = DateFormatter()
        if let getdate = dateFormatter.date(from: timeString){
        dateFormatter.dateFormat = "h:mm:ss a"
        return dateFormatter.string(from: getdate)
        }
        return nil
    }
    
    func fetchTime(timeFormate:String="h:mm:ss")->String{
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = timeFormate
        let dateString = df.string(from: date)
        return dateString
    }
    
    func fetchCurrentDateAndTime(dateFormate:String="dd-MM-yyyy",timeFormate:String="h:mm:ss")->(date:String,time:String){
        let date = Date()
        let dateDF = DateFormatter()
        dateDF.dateFormat = dateFormate
        let timeDF = DateFormatter()
        timeDF.dateFormat = timeFormate
        let dateString = dateDF.string(from: date)
        let timeString = timeDF.string(from: date)
        return(date:dateString,time:timeString)
    }
    
}








