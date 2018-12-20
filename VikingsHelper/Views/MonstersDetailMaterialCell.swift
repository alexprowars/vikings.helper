import UIKit

class MonstersMaterialViewCell: UICollectionViewCell
{
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameView: UILabel!
	
	var id: Int?
	
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
