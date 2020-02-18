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

extension AddNewMemoViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    func loadURL(){
        let alert = UIAlertController(title: "URL 입력", message: "URL", preferredStyle: .alert)
        alert.addTextField{ (URLTextField) in
            //URLTextField.placeholder = "URL"
            URLTextField.text = "https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/3zNv/image/X0MipTW6Onu5KPyPRJyDxfFTqm4.jpg"  //test 용임 주석 처리 해줄것
        }
        
        let okAction = UIAlertAction(title: "확인", style: .default) { (ok) in
            if let url = URL(string: (alert.textFields?.first!.text)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                do{
                    let newStackView = UIStackView()
                    newStackView.axis = .horizontal
                    
                    let delBtn = UIButton(type: .roundedRect)
                    delBtn.setTitle("삭제", for: .normal)
                    delBtn.addTarget(self, action: #selector(self.deleteImage(sender:)), for: .touchUpInside)
                    
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    let updateImage = UIImageView()
                    let nextIndex = self.imageUpdateView.arrangedSubviews.count
                    let scale = UIScreen.main.bounds.width / 2
                    
                    updateImage.image = self.resizeImage(image: image!, height: scale )
                    updateImage.contentMode = .scaleAspectFit
                    
                    newStackView.addArrangedSubview(updateImage)
                    newStackView.addArrangedSubview(delBtn)
                    
                    self.imageUpdateView.insertArrangedSubview(newStackView, at: nextIndex)
                    self.imageArr.append(image!)
                } catch let err { //오류 처리 할것...
                    print("Error : \(err.localizedDescription)")
                    self.alert(message: "잘 못된 URL 입니다.")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            let newStackView = UIStackView()
            newStackView.axis = .horizontal
            
            let delBtn = UIButton(type: .roundedRect)
            delBtn.setTitle("삭제", for: .normal)
            delBtn.addTarget(self, action: #selector(deleteImage(sender:)), for: .touchUpInside)
            
            let updateImage = UIImageView()
            let nextIndex = imageUpdateView.arrangedSubviews.count
            let scale = UIScreen.main.bounds.width / 2
            
            updateImage.image = resizeImage(image: image, height: scale )
            updateImage.contentMode = .scaleAspectFit
            newStackView.addArrangedSubview(updateImage)
            newStackView.addArrangedSubview(delBtn)
            
            
            imageUpdateView.insertArrangedSubview(newStackView, at: nextIndex)
            imageArr.append(image)
            // print(info)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    // 가로 세로 비율을 맞춰서 이미지 사이즈 조절
    func resizeImage(image: UIImage, height: CGFloat) -> UIImage {
        let scale = height / image.size.height
        let width = image.size.width * scale
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    
}
