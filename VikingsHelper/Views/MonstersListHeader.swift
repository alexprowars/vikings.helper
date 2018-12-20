import UIKit

class MonstersListHeader: UICollectionReusableView
{
	@IBOutlet weak var nameView: UILabel!
	
	var name: String = ""
	{
		didSet {
			nameView?.text = name
		}
	}
}
