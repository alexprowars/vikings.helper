import UIKit
import SQLite

class EquipmentsDetailController: UIViewController
{
	struct Equipment {
		let id: Int
		let name: String
		let image: Data
		let level: Int
		let slot: Int
		let silver: Int
		let gold: Int
		let time: Int
	}
	
	@IBOutlet weak var imageContainer: UIView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var levelLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var silverLabel: UILabel!
	@IBOutlet weak var goldLabel: UILabel!
	@IBOutlet weak var slotLabel: UILabel!
	
	@IBOutlet weak var materialsView: EquipmentsDetailMaterial!
	@IBOutlet weak var materialsViewHeight: NSLayoutConstraint!
	@IBOutlet weak var materialsTableView: EquipmentsDetailMaterialTable!
	@IBOutlet weak var materialsTableHeight: NSLayoutConstraint!
	@IBOutlet weak var equipmentsCollection: EquipmentsDetailEquipmentCollection!
	@IBOutlet weak var equipmentsCollectionHeight: NSLayoutConstraint!
	@IBOutlet weak var equipmentsParamsCollection: EquipmentsDetailParamsCollection!
	@IBOutlet weak var equipmentsParamsCollectionHeight: NSLayoutConstraint!
	
	let slot: [String] = ["", "Шлемы", "Броня", "Обувь", "Оружие", "Амулеты"]
	
	var id: Int?
	private var item: Equipment?
	
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
		
			let path = Bundle.main.path(forResource: "vikings", ofType: "sqlite3")!
			let db = try Connection(path, readonly: true)
			
			let equipmentsTable = Table("equipments")
			let equipment = try db.pluck(equipmentsTable.filter(iid == id!))
			
			if equipment != nil {
				item = Equipment(
					id: equipment![iid],
					name: equipment![name]!,
					image: equipment![image]!,
					
					level: equipment![Expression<Int>("level")],
					slot: equipment![Expression<Int>("slot")],
					silver: equipment![Expression<Int>("silver")],
					gold: equipment![Expression<Int>("gold")],
					time: equipment![Expression<Int>("time")]
				)
				
				imageView.image = UIImage(data: item!.image)
				self.navigationItem.title = item!.name
				
				levelLabel.text = String(item!.level)
				slotLabel.text = slot[item!.slot]
				
				let numberFormatter = NumberFormatter()
				numberFormatter.numberStyle = .decimal
				numberFormatter.groupingSeparator = " "
				
				silverLabel.text = numberFormatter.string(for: item!.silver)
				goldLabel.text = numberFormatter.string(for: item!.gold)
				
				let timeFormatter = DateComponentsFormatter()
				timeFormatter.allowedUnits = [.hour, .minute, .second]
				timeFormatter.unitsStyle = .abbreviated
				
				timeLabel.text = timeFormatter.string(from: TimeInterval(item!.time))
				
				var materials: [Material] = []
				
				let equipmentId = Expression<Int>("equipment_id")
				let materialId = Expression<Int>("material_id")
				let materialEquipmentId = Expression<Int>("material_equipment_id")
				let equipmentsMaterialsTable = Table("equipments_materials")
				
				let materialsTable = Table("materials")
				
				let query = equipmentsMaterialsTable
					.select(materialsTable[iid], materialsTable[name], materialsTable[image])
					.join(materialsTable, on: materialsTable[iid] == equipmentsMaterialsTable[materialId])
					.filter(equipmentsMaterialsTable[equipmentId] == item!.id)

				materials = try db.prepare(query).map { row in
					Material(id: row[iid], type: 0, name: row[name]!, image: row[image]!)
				}
				
				let query2 = equipmentsMaterialsTable
					.select(equipmentsTable[iid], equipmentsTable[name], equipmentsTable[image])
					.join(equipmentsTable, on: equipmentsTable[iid] == equipmentsMaterialsTable[materialEquipmentId])
					.filter(equipmentsMaterialsTable[equipmentId] == item!.id)
				
				for row in try db.prepare(query2){
					materials.append(Material(id: row[iid], type: 1, name: row[name]!, image: row[image]!))
				}
				
				materialsView.layoutIfNeeded()
				materialsView.items = materials
				materialsView.reloadData()
				
				materialsViewHeight.constant = materialsView.collectionViewLayout.collectionViewContentSize.height
				
				var equipmentIds: [Int] = []
				
				func findEquipments(eqId: Int) -> [Int]
				{
					let query = equipmentsMaterialsTable
						.select(equipmentsMaterialsTable[materialEquipmentId], equipmentsMaterialsTable[materialEquipmentId])
						.join(equipmentsTable, on: equipmentsTable[iid] == equipmentsMaterialsTable[materialEquipmentId])
						.filter(equipmentsMaterialsTable[equipmentId] == eqId)
					
					var ids: [Int] = []
					
					do {
						for row in try db.prepare(query)
						{
							if row[materialEquipmentId] > 0 {
								ids.append(row[materialEquipmentId])
								ids.append(contentsOf: findEquipments(eqId: row[materialEquipmentId]))
							}
						}
					} catch {
						print(error)
					}
					
					return ids
				}
				
				equipmentIds = findEquipments(eqId: item!.id)
				equipmentIds.append(item!.id)
				
				let countColumn = Expression<Int>(literal: "count(*) as count")
				
				let query3 = equipmentsMaterialsTable
					.select(materialsTable[iid], materialsTable[name], materialsTable[image], countColumn)
					.join(materialsTable, on: materialsTable[iid] == equipmentsMaterialsTable[materialId])
					.filter(equipmentIds.contains(equipmentsMaterialsTable[equipmentId]))
					.group(equipmentsMaterialsTable[materialId])
				
				let materials2 = try db.prepare(query3).map { row in
					MaterialWithCount(id: row[iid], type: 0, name: row[name]!, image: row[image]!, count: row[countColumn])
				}
				
				materialsTableView.items = materials2
				materialsTableView.reloadData()
				
				materialsTableHeight.constant = materialsTableView.contentSize.height
				
				let query4 = equipmentsMaterialsTable
					.select(equipmentsTable[iid], equipmentsTable[name], equipmentsTable[image])
					.join(equipmentsTable, on: equipmentsTable[iid] == equipmentsMaterialsTable[equipmentId])
					.filter(equipmentsMaterialsTable[materialEquipmentId] == item!.id)
				
				let materials3 = try db.prepare(query4).map { row in
					Material(id: row[iid], type: 0, name: row[name]!, image: row[image]!)
				}
				
				if materials3.count > 0
				{
					equipmentsCollection.layoutIfNeeded()
					equipmentsCollection.items = materials3
					equipmentsCollection.reloadData()
				
					equipmentsCollectionHeight.constant = equipmentsCollection.collectionViewLayout.collectionViewContentSize.height
				}
				else {
					equipmentsCollection.superview?.isHidden = true
				}
				
				let equipmentsBoostTable = Table("equipments_boosts")
				let boostTable = Table("boosts")
				let stage = Expression<Int>("stage")
				let valueI = Expression<Int?>("value")
				let valueD = Expression<Double?>("value")
				let boostId = Expression<Int>("boost_id")
				
				let query6 = equipmentsBoostTable
					.select(equipmentsBoostTable[iid], boostTable[name], equipmentsBoostTable[valueD], equipmentsBoostTable[stage])
					.join(boostTable, on: boostTable[iid] == equipmentsBoostTable[boostId])
					.filter(equipmentsBoostTable[equipmentId] == item!.id)
					.order([boostId.asc, stage.asc, valueD.asc])
				
				print(query6.asSQL())
				
				let boosts = try db.prepare(query6).map { row in
					Boost(id: row[iid], name: row[name]!, value: row[valueI] != nil ? row[valueI]! as Any : row[valueD]! as Any, stage: row[stage])
				}
				
				equipmentsParamsCollection.layoutIfNeeded()
				equipmentsParamsCollection.items = boosts
				equipmentsParamsCollection.reloadData()
				
				equipmentsParamsCollectionHeight.constant = equipmentsParamsCollection.collectionViewLayout.collectionViewContentSize.height
			}
		} catch {
			print(error)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if segue.identifier == "MaterialsDetailTableSegue"
		{
			guard let vc = segue.destination as? MaterialsDetailController else { return }
			guard let cell = sender as? EquipmentsDetailMaterialTableCell else { return }
			
			vc.id = cell.id
		}
	}
}
