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

func getStringNoDate(_ date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "hhmmss", options: 0, locale: Locale.current)
    let timeString = formatter.string(from: date)
    return timeString
}
