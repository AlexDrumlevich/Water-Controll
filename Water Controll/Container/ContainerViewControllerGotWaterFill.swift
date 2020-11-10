//
//  ContainerViewControllerGotWaterFill.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 11.10.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//


import Foundation

extension ContainerViewController {
    
    //  set empty bottles at the begining of the day
    
    func gotWaterFill() {
        
        // get current date
        let currentDate = Date()
        let calendar = Calendar.current
        let date2 = calendar.startOfDay(for: currentDate)
        
        for user in users {
            
            //get last date in data base
            guard let lastDate = (user.gotWaters?.lastObject as? GotWater)?.data else {
                return
            }
            
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: lastDate)
            
            //count of days between last and current dates
            let countMissDaysComponents = calendar.dateComponents([.day], from: date1, to: date2)
            guard let countMissDays = countMissDaysComponents.day else { return }
            
            //components of last date in data base
            let lastDayInDataBase = calendar.component(.day, from: lastDate)
            let lastMonthInDataBase = calendar.component(.month, from: lastDate)
            let lastYearInDataBase = calendar.component(.year, from: lastDate)
            
  
            if countMissDays > 0 {
                for index in 1 ... countMissDays {
                    let nextDay = DateComponents(year: lastYearInDataBase, month: lastMonthInDataBase, day: lastDayInDataBase + index)
                    //get next date
                    let nextDate = calendar.date(from: nextDay)
                    //add miss pour water dates
                    addPourWaterData(wasPoured: 0, date: nextDate, user: user)
                }
            }
        }
        
    }
}
