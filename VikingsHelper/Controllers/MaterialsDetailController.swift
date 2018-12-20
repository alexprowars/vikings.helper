import UIKit
import SQLite

class MaterialsDetailController: UIViewController
{
	struct Material {
		let id: Int
		let name: String
		let description: String
		let image: Data
	}
	
	@IBOutlet weak var imageContainer: UIView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	var id: Int?
	private var item: Material!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		imageContainer.layer.cornerRadius = 3.0
		imageContainer.layer.borderWidth = 1.0
		imageContainer.layer.borderColor = UIColor.lightGray.cgColor
		imageContainer.layer.masksToBounds = true;
		
		do {
			let iid = Expression<Int>("id")
			let name = Expression<String?>("name")
			let image = Expression<Data?>("image")
			let description = Expression<String?>("description")
			
			let path = Bundle.main.path(forResource: "vikings", ofType: "sqlite3")!
			let db = try Connection(path, readonly: true)
			
			let materialsTable = Table("materials")
			let material = try db.pluck(materialsTable.filter(iid == id!))
			
			if material != nil {
				item = Material(id: material![iid], name: material![name]!, description: material![description]!, image: material![image]!)
				
				imageView.image = UIImage(data: item.image)
				self.navigationItem.title = item.name
				nameLabel.text = item.name
				descriptionLabel.text = item.description
			}
		} catch {
			print(error)
		}
	}
}
