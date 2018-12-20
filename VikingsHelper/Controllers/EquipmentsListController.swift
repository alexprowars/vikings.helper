import UIKit
import SQLite

class EquipmentsListController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout
{
	struct Section {
		let name: String
		let items: [Equipment]
	}
	
	struct Equipment {
		let id: Int
		let name: String
		let image: Data
	}
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var collectionView: UICollectionView!
	
	private var items: [Section] = []
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		(searchBar.value(forKey: "searchField") as? UITextField)?.textColor = UIColor.white
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
		
		loadItems()
	}
	
	func loadItems (search: String = "")
	{
		items = []
		
		do {
			let id = Expression<Int>("id")
			let name = Expression<String?>("name")
			let image = Expression<Data?>("image")
			
			let path = Bundle.main.path(forResource: "vikings.sqlite3", ofType: nil)!
			let db = try Connection(path, readonly: true)
			
			let equipmentsTable = Table("equipments")
			
			for sectionType in [0, 1, 2, 3]
			{
				var filter = equipmentsTable.filter(Expression<Int>("type") == sectionType)

				if search.count > 0 {
					filter = equipmentsTable.filter(Expression<Int>("type") == sectionType && Expression<String?>("name_lc").like("%"+search.lowercased()+"%"))
				}

				let sectionItems = try db.prepare(filter).map { row in
					Equipment(id: row[id], name: row[name]!, image: row[image]!)
				}
				
				var name = ""
				
				switch sectionType {
					case 0:
						name = "Стандартные вещи"
						break
						
					case 1:
						name = "Вещи Захватчиков"
						break
						
					case 2:
						name = "Специальные вещи"
						break
						
					case 3:
						name = "Вещи Шаманов"
						break
					default:
						name = ""
				}
				
				if sectionItems.count > 0 {
					items.append(Section(name: name, items: sectionItems))
				}
			}
		} catch {
			print(error)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.title = self.tabBarItem.title
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items[section].items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
			case UICollectionView.elementKindSectionHeader:

				let userHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EquipmentsListHeader", for: indexPath) as! EquipmentsListHeader
			
				userHeader.name = items[indexPath.section].name
			
			return userHeader
		
		default:
			return UICollectionReusableView()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EquipmentsListCell", for: indexPath as IndexPath) as! EquipmentsListCell
		
		cell.contentView.layer.cornerRadius = 3.0
		cell.contentView.layer.borderWidth = 1.0
		cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
		cell.contentView.layer.masksToBounds = true;
		
		let item = items[indexPath.section].items[indexPath.row]
		
		cell.id = item.id
		cell.name = item.name
		cell.image = item.image
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("You selected cell #\(indexPath.item)!")
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
	{
		let yourWidth = (collectionView.bounds.width - 30) / 4.0
		let yourHeight = (112 / 85) * yourWidth
		
		return CGSize(width: yourWidth, height: yourHeight)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		loadItems(search: searchText)
		collectionView.reloadData()
	}
	
	@objc func dismissKeyboard() {
		searchBar.endEditing(true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		guard let vc = segue.destination as? EquipmentsDetailController else { return }
		guard let cell = sender as? EquipmentsListCell else { return }
		
		vc.id = cell.id
	}
}
