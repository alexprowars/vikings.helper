import UIKit
import SQLite

class MonstersListController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
	struct Section {
		let name: String
		let items: [Monster]
	}
	
	struct Monster {
		let id: Int
		let name: String
		let image: Data
	}
	
	private var items: [Section] = []
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		do {
			let id = Expression<Int>("id")
			let name = Expression<String?>("name")
			let image = Expression<Data?>("image")
			
			let path = Bundle.main.path(forResource: "vikings.sqlite3", ofType: nil)!
			let db = try Connection(path, readonly: true)
			
			let monstersTable = Table("monsters")
			
			for sectionType in [0, 1, 2]
			{
				let sectionItems = try db.prepare(monstersTable.filter(Expression<Int>("type") == sectionType)).map { row in
					Monster(id: row[id], name: row[name]!, image: row[image]!)
				}

				var name = ""
				
				switch sectionType {
					case 0:
						name = "Захватчики"
						break
						
					case 1:
						name = "Убер захватчики"
						break
						
					case 2:
						name = "Духи"
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
			
			let userHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MonstersListHeader", for: indexPath) as! MonstersListHeader
			
			userHeader.name = items[indexPath.section].name
			
			return userHeader
			
		default:
			return UICollectionReusableView()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvadersListCell", for: indexPath as IndexPath) as! MonstersListCell

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
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
	{
		let yourWidth = (collectionView.bounds.width - 30) / 3.0
		let yourHeight = (155 / 115) * yourWidth
		
		return CGSize(width: yourWidth, height: yourHeight)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("You selected cell #\(indexPath.item)!")
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		guard let vc = segue.destination as? MonstersDetailController else { return }
		guard let cell = sender as? MonstersListCell else { return }

		vc.id = cell.id
	}
}
