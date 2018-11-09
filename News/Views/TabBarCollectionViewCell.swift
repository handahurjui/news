//
//  TabBarCollectionViewCell.swift
//  News
//
//  Created by Andreea Hurjui on 09/11/2018.
//  Copyright © 2018 Andreea Hurjui. All rights reserved.
//

import UIKit

class TabBarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tabBarTitleLbl: UILabel!
    @IBOutlet weak var underscoreView: UIView!
    
    override var isSelected: Bool{
        didSet {
            tabBarTitleLbl.textColor = isSelected ? UIColor.blue : UIColor.black
            underscoreView.backgroundColor = isSelected ? UIColor.blue : UIColor.clear
        }
    }
    
}
