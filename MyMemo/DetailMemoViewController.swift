//
//  DetailMemoViewController.swift
//  MyMemo
//
//  Created by 박성영 on 16/02/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class DetailMemoViewController: UIViewController {
    
    let dateFormat : DateFormatter = {
        let form = DateFormatter()
        form.locale = Locale(identifier: "Ko_kr")
        form.timeStyle = .short
        form.dateStyle = .long
        return form
    }()
    
    
    
    var memo : MyMemo?
    @IBOutlet var tv: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.allowsSelection = false
        //tv.rowHeight = UITableView.automaticDimension
        //tv.estimatedRowHeight = UITableView.automaticDimension
    }
    
    @IBAction func delMeMo(_ sender: Any) {
        DataManager.shared.removeMemo(memo)
        navigationController?.popViewController(animated: true)
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

extension DetailMemoViewController : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath )
            cell.textLabel?.text = memo?.title
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath )
            cell.textLabel?.text = dateFormat.string(for: memo?.createDate)
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainTextCell", for: indexPath )
            cell.textLabel?.text = memo?.mainText
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath ) as! ImageTableViewCell
  
            if memo?.myImage != nil && cell.sv.arrangedSubviews.count <= (memo?.myImage!.count)! {
                for image in memo!.myImage! {
                    let index = cell.sv.arrangedSubviews.count
                    let thumbnailView = UIImageView()
                    thumbnailView.image = UIImage(data: image)
                    thumbnailView.contentMode = .scaleAspectFit
                    
                    thumbnailView.image = resizeImage(image: thumbnailView.image!, width: view.frame.size.width)
                        
                    cell.sv.insertArrangedSubview(thumbnailView, at: index)
                    
                }
            }
            
            return cell
            
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // 가로 세로 비율을 맞춰서 이미지 사이즈 조절
    func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
       let scale = image.size.height / image.size.width
        let height = width * scale
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
