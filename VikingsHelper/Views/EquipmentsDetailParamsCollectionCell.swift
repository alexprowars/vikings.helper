//
//  EquipmentsDetailParamsCollectionCell.swift
//  VikingsHelper
//
//  Created by Алексей on 19/12/2018.
//  Copyright © 2018 Олёшенька. All rights reserved.
//

import UIKit

class EquipmentsDetailParamsCollectionCell: UICollectionViewCell
{
	@IBOutlet weak var textView: UILabel!
	
	func initBorder (indexPath: IndexPath)
	{
		contentView.layer.sublayers?.forEach { (layer) in
			if type(of: layer) == CALayer.self {
				layer.removeFromSuperlayer()
			}
		}
		
		if indexPath.section == 0
		{
			let topLine = CALayer()
			topLine.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: 1.0)
			topLine.backgroundColor = UIColor.lightGray.cgColor
			contentView.layer.addSublayer(topLine)
		}
		
		let bottomLine = CALayer()
		bottomLine.frame = CGRect(x: 0.0, y: frame.height - 1, width: frame.width, height: 1.0)
		bottomLine.backgroundColor = UIColor.lightGray.cgColor
		contentView.layer.addSublayer(bottomLine)
		
		if indexPath.item == 0
		{
			let leftLine = CALayer()
			leftLine.frame = CGRect(x: 0.0, y: 0.0, width: 1.0, height: frame.height)
			leftLine.backgroundColor = UIColor.lightGray.cgColor
			contentView.layer.addSublayer(leftLine)
		}
		
		let rightLine = CALayer()
		rightLine.frame = CGRect(x: frame.width - 1, y: 0.0, width: 1.0, height: frame.height)
		rightLine.backgroundColor = UIColor.lightGray.cgColor
		contentView.layer.addSublayer(rightLine)
	}
	
	var text: String = ""
	{
		didSet {
			textView?.text = text
		}
	}
}
