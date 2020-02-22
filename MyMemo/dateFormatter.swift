//
//  dateFormatter.swift
//  MyMemo
//
//  Created by 박성영 on 23/02/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation

let dateFormat : DateFormatter = {
    let form = DateFormatter()
    form.locale = Locale(identifier: "Ko_kr")
    form.timeStyle = .short
    form.dateStyle = .long
    return form
}()
