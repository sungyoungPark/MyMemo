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
    @IBOutlet var scrollView: UIScrollView!
    
    let picker = UIImagePickerController()
    var imageArr = [UIImage]() // 이미지 저장 하는 배열
    var fromDetailView : MyMemo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTextView.layer.borderWidth = 1.0
        mainTextView.layer.borderColor = UIColor.systemBlue.cgColor
        mainTextView.layer.cornerRadius = 10
        
        titleTextField.delegate = self
        mainTextView.delegate = self
        picker.delegate = self
        
        if fromDetailView == nil {
            title = "새 메모"
            imageStackView.isHidden = true
        }
        else if fromDetailView != nil {
            title = "편집"
            titleTextField.text = fromDetailView?.title
            mainTextView.text = fromDetailView?.mainText
            if fromDetailView?.myImage != nil {
                editLoadImage(fromDetailView!.myImage!)
            }
            if imageArr.count != 0  {
                imageStackView.isHidden = false
            }
            else if imageArr.count == 0  {
                imageStackView.isHidden = true
            }
        }
    }
    
    func editLoadImage(_ dataArr : [Data]){
        for data in dataArr{
            let image = UIImage(data: data)
            upLoadImage(image!)
        }
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
            
            if fromDetailView != nil {
                fromDetailView?.title = titleTextField.text
                fromDetailView?.mainText = mainTextView.text
                fromDetailView?.myImage = DataManager.shared.convertImageToData(imageArr)
                DataManager.shared.saveContext()
            }
            else {
                DataManager.shared.saveNewMemo(titleTextField.text, mainTextView.text, imageArr)
            }
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        var msg = ""
        if title == "새 메모" {
            msg = "작성"
        }
        else if title == "편집"{
            msg = "편집"
        }
        alertBackBtn(msg)
    }
    
    @IBAction func addImageBtn(_ sender: Any) { //alert쪽으로 이동 할것
        alertAddImage()
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
            alert(message: "카메라를 사용 할 수 없습니다")
        }
    }
    
    func loadURL(){
        let alert = UIAlertController(title: "URL 입력", message: "URL", preferredStyle: .alert)
        alert.addTextField{ (URLTextField) in
            //URLTextField.placeholder = "URL"
            URLTextField.text = "https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/3zNv/image/X0MipTW6Onu5KPyPRJyDxfFTqm4.jpg"  //test 용임 주석 처리 해줄것
        }
        
        let okAction = UIAlertAction(title: "확인", style: .default) { (ok) in
            if let url = URL(string: (alert.textFields?.first!.text)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                do{
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    self.upLoadImage(image!)
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
    
    @objc func tapImageForDelete(sender : UITapGestureRecognizer){  //이미지 탭하여 삭제
        var index = 0
        for imageView in imageUpdateView.subviews{
            let location = sender.location(in: imageView)
            if imageView.hitTest(location, with: nil) != nil {
                UIView.animate(withDuration: 0.25, animations: {
                    imageView.isHidden = true
                }, completion: { _ in
                    imageView.removeFromSuperview()
                    
                })
                break
            }
            index += 1
        }
        self.imageArr.remove(at: index)
        if imageArr.count == 0 {
            imageStackView.isHidden = true
        }
        
    }
    
    func upLoadImage( _ image : UIImage) {
        let updateImage = UIImageView()
        updateImage.contentMode = .scaleAspectFit
        
        let nextIndex = imageUpdateView.arrangedSubviews.count
        let scale = UIScreen.main.bounds.width / 2
        
        updateImage.isUserInteractionEnabled = true
        updateImage.image = resizeAddImage(image: image, height: scale )
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImageForDelete))
        updateImage.addGestureRecognizer(tapGesture)
       
        imageUpdateView.insertArrangedSubview(updateImage, at: nextIndex)
        imageArr.append(image)
        
        if imageArr.count != 0 {
            imageStackView.isHidden = false
        }
        
        let offset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + (updateImage.image?.size.height)! + imageUpdateView.spacing + view.bounds.size.height)
        UIView.animate(withDuration: 0.25) {
                   self.scrollView.contentOffset = offset
               }
        
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
    
}

extension AddNewMemoViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            upLoadImage(image)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}
