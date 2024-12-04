//1.

/*
 You are given a string s consisting of only uppercase english characters and an integer k. You can choose up to k characters of the string and replace them with any other uppercase English character.

 After performing at most k replacements, return the length of the longest substring which contains only one distinct character.
 */

//func characterReplacements(s: String, k: Int) {
//	var count = [String: Int]()
//	var res = 0
//	var l = s.startIndex
//	var r = s.startIndex
//	while r<s.endIndex {
//		count.updateValue((s[r] ?? 0), forKey: s[r])
//	}
//}


func characterReplacementNoStringIndex(s: String, k: Int) -> Int{
	var frequency = [Character: Int]() // store the count of the characters
	var res = 0 //length of the longest substring after k replacement
	var left = 0
	let input = Array(s) // Doing this so that I don't want to deal with string indices now
	var maxf = 0
	for right in 0..<input.count {
		frequency[input[right], default: 0]  += 1
		let current = frequency[input[right]] ?? 0
		maxf = max(maxf, current)
		while (right - left + 1) - maxf > k {
			frequency[input[left], default: 0] -= 1
			left += 1
		}
		res = max(res, right-left+1)
		
	}
	return res
}



//print(characterReplacementNoStringIndex(s: "AABABBA", k: 1))


//2.

/*
 You are given two strings s1 and s2.

 Return true if s2 contains a permutation of s1, or false otherwise. That means if a permutation of s1 exists as a substring of s2, then return true.

 Both strings only contain lowercase letters.
 */


func checkInclusion(s1: String, s2: String) -> Bool {
	var string1 = Array(s1)
	var string2 = Array(s2)
	if s1.count > s2.count { return false }
	var s1Count = Array(repeating: 0, count: 26)
	var s2Count = Array(repeating: 0, count: 26)
	//set the first window
	for i in 0..<string1.count {
		if let asciivalue = string1[i].asciiValue {
			s1Count[Int(asciivalue) - Int(Character("a").asciiValue!)] += 1
		}
		if let asciivalue = string2[i].asciiValue {
			s2Count[Int(asciivalue) - Int(Character("a").asciiValue!)] += 1
		}
	}
	var matches = 0
	
	for i in 0..<26 {
		if s1Count[i] == s2Count[i] {
			matches += 1
		}
	}
	
	var indexLeft = 0
	for i in string1.count..<string2.count {
		if matches == 26 {return true}
		var indexRight = i
		var indexOne = 0
		if let ascii = string2[indexRight].asciiValue {
			indexOne = Int(ascii) - Int(Character("a").asciiValue!)
		}
		
		s2Count[indexOne] += 1
		if s2Count[indexOne] == s1Count[indexOne] {
			matches += 1
		} else if s1Count[indexOne] + 1 == s2Count[indexOne] {
			matches -= 1
		}
		var indexTwo = 0
		if let ascii = string2[indexLeft].asciiValue {
			indexTwo = Int(ascii) - Int(Character("a").asciiValue!)
		}
		
		s2Count[indexTwo] -= 1
		if s2Count[indexTwo] == s1Count[indexTwo] {
			matches += 1
		} else if s1Count[indexTwo] - 1 == s2Count[indexTwo] {
			matches -= 1
		}
		indexLeft += 1
	}
	print(matches)
	return matches == 26
}

func checkInclusions2(s1: String, s2: String) -> Bool {
	guard s1.count < s2.count else {
		return false
	}
	var s1 = Array(s1)
	var s2 = Array(s2)
	
	var s1Count = Array(repeating: 0, count: 26)
	var s2Count = Array(repeating: 0, count: 26)
	
	zip(s1, s2).forEach { (char1, char2) in
		if let ascii1 = char1.asciiValue {
			s1Count[Int(ascii1) - Int(Character("a").asciiValue!)] += 1
		}
		if let ascii2 = char2.asciiValue {
			s2Count[Int(ascii2) - Int(Character("a").asciiValue!)] += 1
		}
	}
	
	var matches = (0..<26).reduce(0) { (partialResult, idx) in
		partialResult + (s1Count[idx] == s2Count[idx] ? 1 : 0)
	}
	
	var ldx = 0
	
	for rdx in (s1.count..<s2.count) {
		if matches == 26 {
			return true
		}
		let right = Int(s2[rdx].asciiValue ?? 0)  - Int(Character("a").asciiValue!)
		s2Count[right] += 1
		matches += s1Count[right] == s2Count[right] ? 1 : (s1Count[right] + 1) == s2Count[right] ? -1	: 0
		
		let left = Int(s2[ldx].asciiValue ?? 0) - Int(Character("a").asciiValue!)
		s2Count[left] -= 1
		matches += s1Count[left] == s2Count[left] ? 1 : (s1Count[left] - 1) == s2Count[left] ? -1	: 0
		ldx += 1
	}
	
	return matches == 26
}

//checkInclusions2(s1: "abc", s2: "lecabee")

//3. Fruits in basket


func totalFruit(_ fruits: [Int]) -> Int {
	var (left, maxWindow, basketSize) = (0, 0, 0)
	var countMap = [Int:Int]()
	for right in fruits {
		countMap[right, default:0] += 1
		basketSize += 1
		// Before this is done, make sure the window is valid
		while countMap.count > 2 {
			print("left is", left)
			print("map is", countMap)
			let  leftFruit = fruits[left]
			countMap[leftFruit, default: 0] -= 1
			if let leftFruitCount = countMap[leftFruit], leftFruitCount == 0 {
					countMap.removeValue(forKey: leftFruit)
			}
			
			basketSize -= 1
			left += 1
			
		}
		//Now the window is valid, go ahead and find the max
		maxWindow = max(maxWindow, basketSize)
	}
	return maxWindow
}

totalFruit([0,1,2,2])

