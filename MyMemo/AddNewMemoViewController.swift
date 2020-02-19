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
        }
        else if fromDetailView != nil {
            title = "편집"
            titleTextField.text = fromDetailView?.title
            mainTextView.text = fromDetailView?.mainText
            editLoadImage(fromDetailView!.myImage!)
        }
        
        //imageStackView.isHidden = true
        //imageStack.isHidden = true
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
        print("touch")
        var index = 0
        for imageView in imageUpdateView.subviews{
                let location = sender.location(in: imageView)
                if imageView.hitTest(location, with: nil) != nil {
                    print(index)
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
        }
    
    func upLoadImage( _ image : UIImage) {
        let updateImage = UIImageView()
        updateImage.contentMode = .scaleAspectFit
        
        let nextIndex = imageUpdateView.arrangedSubviews.count
        let scale = UIScreen.main.bounds.width / 2
        
        updateImage.isUserInteractionEnabled = true
        updateImage.image = resizeImage(image: image, height: scale )
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImageForDelete))
        updateImage.addGestureRecognizer(tapGesture)
        
        imageUpdateView.insertArrangedSubview(updateImage, at: nextIndex)
        imageArr.append(image)
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

extension AddNewMemoViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            upLoadImage(image)
            // print(info)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
}
