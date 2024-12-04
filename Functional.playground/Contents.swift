//1. How to flatten a dictionary into array in swift

let dictionary = ["a" : 1, "b" : 2, "c": 3, "d": 4]

let result1 = dictionary.map { ($0.key, $0.value) }

//2. Given an array of integers, use map and filter to create a new array containing the squares of only the even numbers.

let input = [1,2,3,4,5,6,7,8]

let result2 = input.map({$0*$0}).filter({$0%2==0})

//3. Use the reduce function to calculate the product of all numbers in an array.
let input2 = [1,2,3]

let result = input2.reduce(1) { partialResult, result in
	return partialResult * result
}


//4. Use flatMap to flatten an array of arrays of integers into a single array of integers.

let arrayOfArrays = [[1, 2, 3], [4, 5], [6, 7, 8, 9], [10.0]]

let arrayOfArrays2 = [[1, 2, 3], [4, 5], [6, 7, 8, 9], ["What?"]]


let resultCompactMap2 = arrayOfArrays.flatMap({$0}).map({Int($0)})

let resultFlatmap = arrayOfArrays2.flatMap( { $0 })


let numbers: [Any] = [1, 2, 3, "4s"]

let integers = numbers.map { (item) -> Int? in
	if let itemInt = item as? Int {
		return itemInt
	} else if let itemString = item as? String, let number = Int(itemString) {
		return number
	}
	return nil
}

let integersCompact = numbers.compactMap { (item) in
	if let itemInt = item as? Int {
		return itemInt
	} else if let itemString = item as? String, let number = Int(itemString) {
		return number
	}
	return nil
}

print(integersCompact)

let words = ["apple", "banana", "apricot", "blueberry", "avocado", "blackberry"]


let wordsReduceToDict = words.reduce(into: [Character: [String]]()) { result, word in
	guard let first = word.first else { return }
	result[first, default: []].append(word)
}.map {  $0.value }


let wordsReduceToArray = words.reduce(into: [[String]]()) { result, word in
	guard let firstLetter = word.first else { return }
	print(result)
	if let index = result.firstIndex(where: { $0.first?.first == firstLetter }) {
		   // Append the word to the existing group
		   result[index].append(word)
	   } else {
		   // Create a new group with the current word
		   result.append([word])
	   }
}

let wordsToReduceArrayAgain = words.reduce(into: [[String]]()) { partialResult, word in
	guard let firstChar = word.first else {
		return
	}
	if let idx = partialResult.firstIndex(where: {$0.first?.first == firstChar}) {
		partialResult[idx].append(word)
	} else {
		partialResult.append([word])
	}
}

//print(wordsToReduceArrayAgain)


let inputDict: [String: Int] = ["apple": 5, "banana": 3, "orange": 8, "grape": 2]
let threshold = 4

let filteredStrings = inputDict.compactMap { (key, val) in
	if val > 4 {
		return key + ":" + String(val)
	}
	return nil
}
 print(filteredStrings)


struct Reduce {
	
	
	func whatIsReduce() {
		let nums = [1, 2, 3, 4, 5]
		let totals =  nums.reduce(into:[Int]()) {
			
			return $0.append(($0.last ?? 0) + $1)
		}
		print(totals)
		// For reduce into, the accumalator is mutable. This is not the case for reduce.
		let totals2 = nums.reduce([Int]()) {
			$0 + [($0.last ?? 0) + $1]
		}
		print(totals2)
	}
}


func flattenDictionary(_ dict: [String: Any], prefix: String = "") -> [String: Any] {
	var result = [String: Any]()
	
	for (key, value) in dict {
		let newKey = prefix.isEmpty ? key : "\(prefix).\(key)"
		
		if let nestedDict = value as? [String: Any] {
			// If the value is a nested dictionary, recurse
			let flattened = flattenDictionary(nestedDict, prefix: newKey)
			result.merge(flattened) { (_, new) in new }
		} else {
			// If the value is not a dictionary, add it to the result
			result[newKey] = value
		}
	}
	
	return result
}

let nestedDict: [String: Any] = [
	"a": 5,
	"b": 6,
	"c": [
		"f": 9,
		"g": [
			"m": 17,
			"n": 3
		]
	]
]

//let flattened = flattenDictionary(nestedDict)
//print(flattened)
Reduce().whatIsReduce()
