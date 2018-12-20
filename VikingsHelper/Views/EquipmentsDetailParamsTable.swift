import UIKit

class EquipmentsDetailParamsTable: UITableView, UITableViewDataSource, UITableViewDelegate
{
	var firstTime = true
	var width = CGFloat(0.0)
	var height = CGFloat(0.0)
	var cellRect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
	
	public override func awakeFromNib() {
		dataSource = self
		delegate = self
	}
	
	let colors:[UIColor] = [
		UIColor.green,
		UIColor.yellow,
		UIColor.lightGray,
		UIColor.blue,
		UIColor.cyan
	]
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	var cellWidth = CGFloat(0.0)
	var cellHeight = CGFloat(0.0)
	let widths = [0.2,0.3,0.3,0.2]
	let labels = ["0","1","2","3"]
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
		let v = cell.contentView.subviews[0] // points to stack view
		// Note: using w = v.frame.width picks up the width assigned by xCode.
		cellWidth = cellRect.width-20.0 // work around to get a right width
		cellHeight = cellRect.height
		
		var x:CGFloat = 0.0
		for i in 0 ..< labels.count {
			let wl = cellWidth * CGFloat(widths[i])
			let lFrame = CGRect(origin:CGPoint(x: x,y: 0),size: CGSize(width:wl,height: cellHeight))
			let label = UILabel(frame: lFrame)
			label.textAlignment = .center
			label.text = labels[i]
			v.addSubview(label)
			x = x + wl
			print("i = ",i,v.subviews[i])
			v.subviews[i].backgroundColor = colors[i]
		}
		
		
		return cell
	}
}
