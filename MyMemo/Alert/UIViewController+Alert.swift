//
//  Alert.swift
//  MyMemo
//
//  Created by 박성영 on 17/02/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String = "알림", message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}



