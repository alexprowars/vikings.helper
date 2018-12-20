import UIKit
import SQLite

class MonstersDetailController: UIViewController
{
	struct Monster {
		let id: Int
		let name: String
		let description: String
		let image: Data
	}
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var materialsView: MonstersDetailMaterial!
	@IBOutlet weak var nameView: UILabel!
	@IBOutlet weak var materialsHeight: NSLayoutConstraint!
	@IBOutlet weak var descriptionView: UILabel!
	@IBOutlet weak var superMonsterIcon: UIImageView!
	
	var id: Int?
	private var item: Monster!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		do {
			let iid = Expression<Int>("id")
			let name = Expression<String?>("name")
			let image = Expression<Data?>("image")
			let description = Expression<String?>("description")
			
			let path = Bundle.main.path(forResource: "vikings", ofType: "sqlite3")!
			let db = try Connection(path, readonly: true)
			
			let monstersTable = Table("monsters")
			let monster = try db.pluck(monstersTable.filter(iid == id!))
			
			if monster != nil {
				item = Monster(id: monster![iid], name: monster![name]!, description: monster![description]!, image: monster![image]!)
			}
			
			imageView.image = UIImage(data: item.image)
			self.navigationItem.title = item.name
			nameView.text = item.name
			descriptionView.text = item.description
			
			var materials: [Material] = []
			var ids: [Int] = []
			
			let invaderId = Expression<Int>("monster_id")
			let monstersMaterialsTable = Table("monsters_materials")
			
			ids = try db.prepare(monstersMaterialsTable.filter(invaderId == item.id)).map { row in
				try row.get(Expression<Int>("material_id"))
			}
			
			let materialsTable = Table("materials")
			
			materials = try db.prepare(materialsTable.filter(ids.contains(iid))).map { row in
				Material(id: row[iid], type: 0, name: row[name]!, image: row[image]!)
			}
			
			materialsView.items = materials
			materialsView.reloadData()
			
			materialsHeight.constant = materialsView.collectionViewLayout.collectionViewContentSize.height
			
		} catch {
			print(error)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if segue.identifier == "MaterialsDetailSegue"
		{
			guard let vc = segue.destination as? MaterialsDetailController else { return }
			guard let cell = sender as? MonstersMaterialViewCell else { return }

			vc.id = cell.id
		}
	}
}
