import UIKit

class MonstersDetailMaterial: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate
{	
	public var items: [Material] = []
	
	public override func awakeFromNib() {
		dataSource = self
		delegate = self
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvaderMaterialViewCell", for: indexPath as IndexPath) as! MonstersMaterialViewCell

		cell.contentView.layer.cornerRadius = 3.0
		cell.contentView.layer.borderWidth = 1.0
		cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
		cell.contentView.layer.masksToBounds = true;
		
		let item = items[indexPath.row]
		
		cell.id = item.id
		cell.name = item.name
		cell.image = item.image
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("You selected cell #\(indexPath.item)!")
	}
}
