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
    
    
    
    @IBOutlet var detailTableView: UITableView!
    var memo : MyMemo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tv.rowHeight = UITableView.automaticDimension
        //tv.estimatedRowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("다시 나타남")
        DataManager.shared.fetchMemo()
        detailTableView.reloadData()
      }
    
    
    @IBAction func delMeMo(_ sender: Any) {
        DataManager.shared.removeMemo(memo)
        navigationController?.popViewController(animated: true)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddNewMemoViewController{
            vc.fromDetailView = memo
        }
        
        
     }
     
    
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
            if cell.sv.arrangedSubviews.count != 0 {
                for i in cell.sv.arrangedSubviews{
                    i.removeFromSuperview()
                }
            }
            var index = 0
            if memo?.myImage != nil{
                //&& cell.sv.arrangedSubviews.count != (memo?.myImage!.count)! {
                for image in memo!.myImage! {
                    let thumbnailView = UIImageView()
                    thumbnailView.image = UIImage(data: image)
                    thumbnailView.contentMode = .scaleAspectFit
                    
                    thumbnailView.image = resizeDetailImage(image: thumbnailView.image!, width: view.frame.size.width)
                        
                    cell.sv.insertArrangedSubview(thumbnailView, at: index)
                    index += 1
                }
            }
            print(cell.sv.arrangedSubviews.count)
            return cell
            
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
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
}
