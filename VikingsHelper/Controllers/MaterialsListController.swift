import UIKit
import SQLite

class MaterialsListController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
	private var items: [Material] = []
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		do {
			let id = Expression<Int>("id")
			let name = Expression<String?>("name")
			let image = Expression<Data?>("image")
			
			let path = Bundle.main.path(forResource: "vikings.sqlite3", ofType: nil)!
			let db = try Connection(path, readonly: true)
			
			let materialsTable = Table("materials")
			
			items = try db.prepare(materialsTable).map { row in
				Material(id: row[id], type: 0, name: row[name]!, image: row[image]!)
			}
		} catch {
			print(error)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.title = self.tabBarItem.title
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaterialsListCell", for: indexPath as IndexPath) as! MaterialsListCell
		
		cell.contentView.layer.cornerRadius = 3.0
		cell.contentView.layer.borderWidth = 1.0
		cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
		cell.contentView.layer.masksToBounds = true;
		
		let item = items[indexPath.row];
		
		cell.id = item.id
		cell.name = item.name
		cell.image = item.image
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
	{
		let yourWidth = (collectionView.bounds.width - 30) / 3.0
		let yourHeight = (145 / 115) * yourWidth
		
		return CGSize(width: yourWidth, height: yourHeight)
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("You selected cell #\(indexPath.item)!")
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		guard let vc = segue.destination as? MaterialsDetailController else { return }
		guard let cell = sender as? MaterialsListCell else { return }
		
		vc.id = cell.id
	}
}
