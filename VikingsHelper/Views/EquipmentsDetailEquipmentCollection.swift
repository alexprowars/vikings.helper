import UIKit

class EquipmentsDetailEquipmentCollection: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
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
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EquipmentsListCell", for: indexPath as IndexPath) as! EquipmentsListCell
		
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
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
	{
		let yourWidth = (collectionView.bounds.width - 30) / 3.0
		let yourHeight = (145 / 114) * yourWidth
		
		return CGSize(width: yourWidth, height: yourHeight)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		let storyboard = UIStoryboard(name: "Equipments", bundle: nil)
		let detailController = storyboard.instantiateViewController(withIdentifier: "EquipmentsDetail") as? EquipmentsDetailController
		
		guard let delegate = UIApplication.shared.delegate else {
			return
		}
		
		detailController?.id = items[indexPath.row].id
		
		(delegate.window!!.rootViewController! as! UINavigationController).pushViewController(detailController!, animated: true)
	}
}
