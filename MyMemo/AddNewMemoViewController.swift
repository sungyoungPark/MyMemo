//
//  AddNewMemoViewController.swift
//  MyMemo
//
//  Created by 박성영 on 12/02/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class AddNewMemoViewController: UIViewController ,UITextFieldDelegate , UITextViewDelegate{
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var mainTextView: UITextView!
    @IBOutlet var imageStackView: UIStackView!
    @IBOutlet var rightBarBtn: UIBarButtonItem!
    @IBOutlet var imageUpdateView: UIStackView!
    
    let picker = UIImagePickerController()
    var imageArr = [UIImage]() // 이미지 저장 하는 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTextView.layer.borderWidth = 1.0
        mainTextView.layer.borderColor = UIColor.systemBlue.cgColor
        mainTextView.layer.cornerRadius = 10
        
        titleTextField.delegate = self
        mainTextView.delegate = self
        picker.delegate = self
        
        //imageStackView.isHidden = true
        //imageStack.isHidden = true
    }
    
    
    @IBAction func saveMemo(_ sender: Any) {
         
        if rightBarBtn.title == "완료"{
            view.endEditing(true)
            rightBarBtn.title = "저장"
        }
        else if rightBarBtn.title == "저장"{
            
            guard let memoTitle = titleTextField.text,
                memoTitle.count > 0 else{
                alert(message: "제목을 입력하세요")
                return
            }
            
            guard let memoMainText = mainTextView.text,
                memoMainText.count > 0 else {
                alert(message: "본문을 입력하세요")
                return
            }
            
            DataManager.shared.saveNewMemo(titleTextField.text, mainTextView.text, imageArr)
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func addImageBtn(_ sender: Any) { //alert쪽으로 이동 할것
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
        present(alert, animated: true, completion: nil)
        
    }
    
    func openLibrary()
    {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }
        else{
            print("Camera not available")
        }
    }
    
   
    @objc func deleteImage(sender: UIButton ) {
       // 클릭 했을 때 버튼의 슈퍼뷰, 즉 버튼이 속해있는 stack view를 가지고 온다
       
       guard let entryView = sender.superview else { return }
         let index = imageUpdateView.arrangedSubviews.firstIndex(of: entryView)
        //print("주소 확인 =" ,index)
       // 0.25동안 그 스택뷰를 안 보이게 하고
       // 완료하면 view 계층구조에서 제거한다
       // view 계층구조에서 제거하면 stackviewe에 arragedSubview에서도 자동적으로 제거됨
       UIView.animate(withDuration: 0.25, animations: {
           entryView.isHidden = true
        
       }, completion: { _ in
           entryView.removeFromSuperview()
        self.imageArr.remove(at: index!)
       })
   }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        rightBarBtn.title = "완료"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        rightBarBtn.title = "완료"
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

