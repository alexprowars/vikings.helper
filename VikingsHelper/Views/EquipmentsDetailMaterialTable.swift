import UIKit

class EquipmentsDetailMaterialTable: UITableView, UITableViewDataSource, UITableViewDelegate
{
	public var items: [MaterialWithCount] = []
	
	public override func awakeFromNib() {
		dataSource = self
		delegate = self
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		guard let cell = self.dequeueReusableCell(withIdentifier: "EquipmentsDetailMaterialTableCell") as? EquipmentsDetailMaterialTableCell else {
			return EquipmentsDetailMaterialTableCell()
		}
		
		cell.selectionStyle = .none
		
		let item = items[indexPath.row]
		
		cell.id = item.id
		cell.name = item.name
		cell.image2 = item.image
		cell.count = item.count
		
		return cell
	}
}
