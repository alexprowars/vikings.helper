import UIKit

class EquipmentsMaterialViewCell: UICollectionViewCell
{
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameView: UILabel!
	
	var name: String = ""
	{
		didSet {
			nameView?.text = name
		}
	}
	
	var image: Data = Data.init()
	{
		didSet {
			imageView.image = UIImage(data: image)
		}
	}
}
