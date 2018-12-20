import Foundation

struct Material {
	let id: Int
	let type: Int
	let name: String
	let image: Data
}

struct MaterialWithCount {
	let id: Int
	let type: Int
	let name: String
	let image: Data
	let count: Int
}

struct Boost {
	let id: Int
	let name: String
	let value: Any
	let stage: Int
}
