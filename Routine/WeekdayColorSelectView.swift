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
    func didTapOnBackView()
}

class WeekdayColorSelectView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var backView: UIView?
    var titleLabel: UILabel?
    var collectionView: UICollectionView?
    var colors: Array<UIColor>?
    
    var delegate: WeekdayColorProtocol?
    
    var collectionHeight: Double?
    
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
                  color(with: 217, green: 182, blue: 164),
                  color(with: 217, green: 212, blue: 164),
                  color(with: 196, green: 217, blue: 164),
                  color(with: 167, green: 217, blue: 164),
                  color(with: 164, green: 217, blue: 213),
                  color(with: 164, green: 189, blue: 217),
                  color(with: 189, green: 164, blue: 217),
                  color(with: 217, green: 164, blue: 203)]
        
        backView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        backView!.backgroundColor = UIColor(white: 0, alpha: 0.5)
        backView!.alpha = 0
        backView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self._tapOnBackView)))
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
        layout.scrollDirection = .vertical
        let lines = (colors!.count % 4 == 0 ? colors!.count / 4 : colors!.count / 4 + 1)
        collectionHeight = Double((lines - 1) * (50 + 30) + 50)
        collectionView = UICollectionView(frame: CGRect(x: (screenWidth - 260) / 2, y: 200, width: 260, height: CGFloat(collectionHeight!)), collectionViewLayout: layout)
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
    
    func _tapOnBackView() {
        _hide()
        delegate?.didTapOnBackView()
    }
    
    func _display() {
        
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.backView!.alpha = 1
            self.titleLabel!.alpha = 1
            self.collectionView!.frame = CGRect(x: (screenWidth - 260) / 2, y: 150, width: 260, height: CGFloat(self.collectionHeight!))
            self.collectionView!.alpha = 1
        }
    }
    
    func _hide() {
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.backView!.alpha = 0
            self.titleLabel!.alpha = 0
            self.collectionView!.frame = CGRect(x: (screenWidth - 260) / 2, y: 200, width: 260, height: CGFloat(self.collectionHeight!))
            self.collectionView!.alpha = 0
        }) { (finished: Bool) in
            self.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
