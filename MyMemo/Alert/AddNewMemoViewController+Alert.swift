//
//  AddNewMemoViewController+Alert.swift
//  MyMemo
//
//  Created by 박성영 on 21/02/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

extension AddNewMemoViewController{
    func alertAddImage() {
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        
        let URL = UIAlertAction(title: "URL", style: .default) { (action) in
            self.loadURL()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(URL)
        alert.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let pc = alert.popoverPresentationController{
                pc.sourceView = self.view
                pc.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                pc.permittedArrowDirections = []
                present(alert, animated: true, completion: nil)
            }
        }
        else{
            present(alert, animated: true, completion: nil)
        }
    }
    
    func alertBackBtn( _ msg : String){
        let alert = UIAlertController(title: "알림", message: msg + "을 취소하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default ){
            (action) in self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func alertEditCheck(){
        let alert = UIAlertController(title: nil, message: "편집한 내용을 저장할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default ){
            (action) in
            self.fromDetailView?.title = self.titleTextField.text
            self.fromDetailView?.mainText = self.mainTextView.text
            self.fromDetailView?.createDate = Date()
            self.fromDetailView?.myImage = DataManager.shared.convertImageToData(self.imageArr)
            DataManager.shared.saveContext()
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}
