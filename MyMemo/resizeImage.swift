//
//  resizeImage.swift
//  MyMemo
//
//  Created by 박성영 on 21/02/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

// 가로 세로 비율을 맞춰서 이미지 사이즈 조절
   func resizeDetailImage(image: UIImage, width: CGFloat) -> UIImage {
      let scale = image.size.height / image.size.width
       let height = width * scale
       
       UIGraphicsBeginImageContext(CGSize(width: width, height: height))
       image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       return newImage!
   }

  func resizeAddImage(image: UIImage, height: CGFloat) -> UIImage {
      let scale = height / image.size.height
      let width = image.size.width * scale
      
      UIGraphicsBeginImageContext(CGSize(width: width, height: height))
      image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return newImage!
  }
