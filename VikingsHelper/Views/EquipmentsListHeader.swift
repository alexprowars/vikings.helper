import UIKit

class EquipmentsListHeader: UICollectionReusableView
{
	@IBOutlet weak var nameView: UILabel!
	
	var name: String = ""
	{
		didSet {
			nameView?.text = name
		}
	}
}
