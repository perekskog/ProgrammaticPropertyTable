//
//  Utilities.swift
//  ProgrammaticPropertyTable
//
//  Created by Per Ekskog on 2015-07-27.
//  Copyright (c) 2015 Per Ekskog. All rights reserved.
//

/*
Todo:

*/

import Foundation

func getStringNoDate(date: NSDate) -> String {
    let formatter = NSDateFormatter();
    formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("hhmmss", options: 0, locale: NSLocale.currentLocale())
    let timeString = formatter.stringFromDate(date)
    return timeString
}
