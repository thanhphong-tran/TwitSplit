//
//  ViewController.swift
//  TwitSplit
//
//  Created by ThanhPhong-Tran on 6/24/18.
//  Copyright © 2018 ECDC. All rights reserved.
//

import UIKit

extension String {
    func height(withConstraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bottomInputViewConstraint: NSLayoutConstraint!
    
    var dataSource: [String] = []
    let twitSplitter = TwitSplitter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "MessageCVCell", bundle: nil), forCellWithReuseIdentifier: "MessageCVCell")
        
        self.tfMessage.text = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillAppear(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillDisappear(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillAppear(notification: Notification){
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.bottomInputViewConstraint.constant = -keyboardFrame.height
    }
    
    @objc func keyboardWillDisappear(notification: Notification){
        self.bottomInputViewConstraint.constant = 0
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        guard let text = tfMessage.text, text.count > 0 else { return }
        
        do {
            let texts = try twitSplitter.splitMessage(text)
            
            self.collectionView.performBatchUpdates({
                let indexPaths = Array(self.dataSource.count..<self.dataSource.count+texts.count).map { IndexPath.init(row: $0, section: 0) }
                self.dataSource.append(contentsOf: texts)
                self.collectionView.insertItems(at: indexPaths)
            }, completion: nil)
            
            // Reset text field
            self.tfMessage.text = ""
        } catch {
            if let err = error as? TwitSplittingError {
                let alert = UIAlertController.init(title: "Splitting Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
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
