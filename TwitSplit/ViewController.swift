//
//  ViewController.swift
//  TwitSplit
//
//  Created by ThanhPhong-Tran on 6/24/18.
//  Copyright © 2018 ECDC. All rights reserved.
//

import UIKit

extension String {
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.width
    }
    
    func height(withConstraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: [String] = [
        "abababababbabababbababababbababababba",
        "abababababbabababbababababbababababba",
        "abababababbabababbababababbababababba",
        "a"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "MessageCVCell", bundle: nil), forCellWithReuseIdentifier: "MessageCVCell")
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        
    }
    
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCVCell", for: indexPath) as! MessageCVCell
        cell.lbMessage.text = dataSource[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = dataSource[indexPath.row].height(withConstraintedWidth: 250.0, font: UIFont.systemFont(ofSize: 17.0))
        return CGSize.init(width: width, height: height + 20)
    }
}
