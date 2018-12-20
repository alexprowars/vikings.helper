//
//  EquipmentsDetailParamsCollection.swift
//  VikingsHelper
//
//  Created by Алексей on 19/12/2018.
//  Copyright © 2018 Олёшенька. All rights reserved.
//

import UIKit
import SQLite

class EquipmentsDetailParamsCollection: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
	public var items: [Boost] = []
	
	public override func awakeFromNib() {
		dataSource = self
		delegate = self
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1 + (items.count / 6)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 7
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		guard let cell = self.dequeueReusableCell(withReuseIdentifier: "EquipmentsDetailParamsCollectionCell", for: indexPath as IndexPath) as? EquipmentsDetailParamsCollectionCell else {
			return EquipmentsDetailParamsCollectionCell()
		}
		
		cell.initBorder(indexPath: indexPath)
		cell.textView.textAlignment = .center
		
		if indexPath.section == 0 {
			cell.textView.isHidden = true
			
			if indexPath.item == 0 {
				cell.backgroundColor = .clear
			} else if indexPath.item == 1 {
				cell.backgroundColor = UIColor(rgb: 0x868376)
			} else if indexPath.item == 2 {
				cell.backgroundColor = UIColor(rgb: 0xe5e1d7)
			} else if indexPath.item == 3 {
				cell.backgroundColor = UIColor(rgb: 0x3c8023)
			} else if indexPath.item == 4 {
				cell.backgroundColor = UIColor(rgb: 0x2e65c1)
			} else if indexPath.item == 5 {
				cell.backgroundColor = UIColor(rgb: 0x792bdd)
			} else if indexPath.item == 6 {
				cell.backgroundColor = UIColor(rgb: 0xf6ce40)
			}
		} else {
			if indexPath.item == 0 {
				cell.text = String(describing: items[((indexPath.section - 1) * 6) + indexPath.item].name)
				cell.textView.textAlignment = .left
			} else {
				cell.text = String(describing: items[((indexPath.section - 1) * 6) + (indexPath.item - 1)].value)+"%"
			}
		}
		
		cell.contentView.layer.masksToBounds = true
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
	{
		var yourWidth: CGFloat = 0.0
		let yourHeight: CGFloat = 40.0
		
		if indexPath.item == 0 {
			yourWidth = 120
		} else {
			yourWidth = (collectionView.bounds.width - 120) / 6
		}
		
		return CGSize(width: yourWidth, height: yourHeight)
	}
}
