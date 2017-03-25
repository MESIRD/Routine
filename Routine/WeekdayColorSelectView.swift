//
//  WeekdayColorSelectView.swift
//  Routine
//
//  Created by mesird on 25/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

protocol WeekdayColorProtocol {
    
    func didSelect(color: UIColor)
}

class WeekdayColorSelectView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var backView: UIView?
    var titleLabel: UILabel?
    var collectionView: UICollectionView?
    var colors: Array<UIColor>?
    
    var delegate: WeekdayColorProtocol?
    
    let kColorCellId = "ColorCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        colors = [color(with: 255, green: 225, blue: 210),
                  color(with: 255, green: 245, blue: 210),
                  color(with: 233, green: 255, blue: 210),
                  color(with: 210, green: 255, blue: 216),
                  color(with: 210, green: 255, blue: 248),
                  color(with: 210, green: 232, blue: 255),
                  color(with: 214, green: 210, blue: 255),
                  color(with: 249, green: 210, blue: 255),
                  color(with: 255, green: 178, blue: 139),
                  color(with: 255, green: 236, blue: 139),
                  color(with: 219, green: 255, blue: 139),
                  color(with: 139, green: 255, blue: 161),
                  color(with: 139, green: 255, blue: 243),
                  color(with: 139, green: 199, blue: 255),
                  color(with: 150, green: 139, blue: 255),
                  color(with: 244, green: 139, blue: 255)]
        
        backView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        backView!.backgroundColor = UIColor(white: 0, alpha: 0.5)
        backView!.alpha = 0
        self.addSubview(backView!)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 80, width: screenWidth, height: 30))
        titleLabel!.textColor = UIColor.white
        titleLabel!.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightLight)
        titleLabel!.text = "Colors"
        titleLabel!.alpha = 0
        titleLabel!.textAlignment = .center
        self.addSubview(titleLabel!)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: (screenWidth - 260) / 2, bottom: 0, right: (screenWidth - 260) / 2)
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 200, width: screenWidth, height: screenHeight - 200), collectionViewLayout: layout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.alpha = 0
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.register(WeekdayColorSelectCollectionViewCell.self, forCellWithReuseIdentifier: kColorCellId)
        self.addSubview(collectionView!)
        
        collectionView!.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kColorCellId, for: indexPath)
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.backgroundColor = colors![indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = colors![indexPath.item]
        if delegate != nil {
            delegate?.didSelect(color: color)
        }
        self._hide()
    }
    
    func _display() {
        
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.backView!.alpha = 1
            self.titleLabel!.alpha = 1
            self.collectionView!.frame = CGRect(x: 0, y: 150, width: screenWidth, height: screenHeight - 200)
            self.collectionView!.alpha = 1
        }
    }
    
    func _hide() {
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.backView!.alpha = 0
            self.titleLabel!.alpha = 0
            self.collectionView!.frame = CGRect(x: 0, y: 200, width: screenWidth, height: screenHeight - 200)
            self.collectionView!.alpha = 0
        }) { (finished: Bool) in
            self.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
