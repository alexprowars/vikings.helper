import UIKit

class EquipmentsDetailMaterialTableCell: UITableViewCell
{
	@IBOutlet weak var imageView2: UIImageView!
	@IBOutlet weak var titleView: UILabel!
	@IBOutlet weak var countView: UILabel!
	
	var id: Int?
	
	var name: String = ""
	{
		didSet {
			titleView?.text = name
		}
	}
	
	var image2: Data = Data.init()
	{
		didSet {
			imageView2.image = UIImage(data: image2)
		}
	}
	
	var count: Int = 0
	{
		didSet {
			countView?.text = String(count)
		}
	}
}
