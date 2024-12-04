//0. Find all subsequences

func subsequences<T: Collection>(_ sequence:T) -> [[T.Element]] where T.Element: Equatable {
	let n = sequence.count
	var result = [[T.Element]]()
	var cur = [T.Element]()
	func helper(_ ind: T.Index) {
		if ind == sequence.endIndex {
			result.append(cur)
			return
		}
		//take
		cur.append(sequence[ind])
		helper(sequence.index(ind, offsetBy:1))
		// don't take
		cur.removeLast()
		helper(sequence.index(ind, offsetBy:1))
	}
	helper(sequence.startIndex)
	return result
}
	
//print("sub sequences are",subsequences("abc"))
//1. Combination sum one. Allow same candidate more than once.
/*
 Given an array of distinct integers (candidates) and a target integer (target), return a list of all unique combinations of candidates where the chosen numbers sum to target. You may return the combinations in any order.
 
 The same number may be chosen from candidates an unlimited number of times. Two combinations are unique if the
 frequency
  of at least one of the chosen numbers is different.
 
 */


class Problem1 {
	func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
		var res = [[Int]]()
		dfs(0, target, [])
		return res
		
		func dfs(_ i: Int, _ target: Int, _ current: [Int]) {
			var current = current
			if target == 0 {
				res.append(current)
				return
			}
			if i >= candidates.count || target<0 {
				return
			}
			current.append(candidates[i])
			dfs(i, target-candidates[i], current)
			current.popLast()
			dfs(i+1, target, current)
		}
	}
}


//2. Combination sum 2
/*
 Given a collection of candidate numbers (candidates) and a target number (target), find all unique combinations in candidates where the candidate numbers sum to target.

 Each number in candidates may only be used once in the combination.

 Note: The solution set must not contain duplicate combinations.
 */

class Problem2 {
	
	func combinationSum2(_ candidates: [Int], _ target: Int) -> [[Int]] {
		var candidates = candidates.sorted()
		var result: [[Int]] = []
		var cur: [Int] = []
		func dfs(i: Int, total: Int) {
			if total == target {
				let curCopy = cur
				return result.append(curCopy)
			}
			if i == candidates.count || total > target {
				return
			}
			//include the candidates[i]
			cur.append(candidates[i])
			
			dfs(i: i+1, total: total + candidates[i])
			
			cur.removeLast()
			
			var nextIdx = i + 1
			while nextIdx < candidates.count && candidates[nextIdx] == candidates[i] {
				nextIdx += 1
			}
			dfs(i: nextIdx, total: total)
			
		}
		dfs(i: 0, total: 0)
		return result
	}
	
	
	func combinationSum2Approach2(_ candidates: [Int], _ target: Int) -> [[Int]] {
		var sortedCandidates = candidates.sorted()
		var result = [[Int]]()
		var current = [Int]()
		findCombination(0, target, current)
		
		func findCombination(_ idx: Int, _ target: Int, _ current: [Int]) {
			var current = current
			if target == 0 {
				result.append(current)
				return
			}
			for i in idx..<sortedCandidates.count {
				if i>idx, sortedCandidates[i] == sortedCandidates[i-1] { continue } // i>idx is to make sure that the equality check of elemtns happens only after the first iteration else the execution will not happen for the i == idx at the next level
				if sortedCandidates[i] > target { break }
				current.append(sortedCandidates[i])
				findCombination(i+1, target-sortedCandidates[i], current)
				current.popLast()
			}
		}
		return result
	}
}

//3. Word search

/*
 Given a 2-D grid of characters board and a string word, return true if the word is present in the grid, otherwise return false.

 For the word to be present it must be possible to form it with a path in the board with horizontally or vertically neighboring cells. The same cell may not be used more than once in a word.
 */


class Problem3 {
	func exist(_ board: [[Character]], _ word: String) -> Bool {
		let rows = board.count
		var board = board
		let colums = board[0].count
		let word = Array(word)
		
		func dfs(_ r: Int, _ c: Int, k: Int) -> Bool {
			if k == word.count {
				return true
			} else if r<0 || c<0 || r>=rows || c >= colums || board[r][c] != word[k] {
					return false
			} else {
				let current = board[r][c]
				board[r][c] =  "#"
				let contains = dfs(r+1, c, k: k+1) ||  dfs(r-1, c, k: k+1) || dfs(r, c+1, k: k+1) ||  dfs(r, c+1, k: k+1)
				board[r][c] = current
				return contains
			}
		}
		
		for r in 0..<rows {
			for c in 0..<colums {
				if dfs(0, 0, k: 0) {
					return true
				}
			}
		}
		
		return false
	}
	
	
	func exist2(_ board: [[Character]], _ word: String) -> Bool {
		let row = board.count
		let col = board[0].count
		//since Type '(Int, Int)' does not conform to protocol 'Hashable', we have to either convert this to a hashed string like
		var path = [(Int,Int)]()

		func dfs(_ r: Int, _ c: Int, _ k: Int) -> Bool {
			if k == word.count {
				return true
			}
			if r < 0 || c < 0 || r >= row || c >= col || board[r][c] != Array(word)[k] || path.contains(where: { $0.0 == r && $0.1 == c }) {
				return false
			}
			
			path.append((r,c))
			let right = dfs(r + 1, c, k + 1)
			let left = dfs(r - 1, c, k + 1)
			let down = dfs(r, c + 1, k + 1)
			let up = dfs(r, c - 1, k + 1)
			path.removeLast()
			
			return right || left || down || up
		}

		for i in 0..<row {
			for j in 0..<col {
				if dfs(i, j, 0) {
					return true
				}
			}
		}
		return false
	}
}
//print("CS2 ", Problem2().combinationSum2([2,1,3,1,4], 10))


//4. All the subsets
/*
 Given an array nums of unique integers, return all possible subsets of nums.

 The solution set must not contain duplicate subsets. You may return the solution in any order.
 */

class Problem4 {
	
	func subsets(_ nums: [Int]) -> [[Int]] {
		var result = [[Int]]()
		var subSet = [Int]()
		
		func subsetsHelper(_ i: Int) {
			if i>=nums.count {
				result.append(subSet)
				return
			}
			
			subSet.append(nums[i])
			subsetsHelper(i+1)
			subSet.removeLast()
			subsetsHelper(i+1)
		}
		subsetsHelper(0)
		return result
	}
	
	func subsetsBitManipulation(_ nums: [Int]) -> [[Int]] {
		   let n = nums.count
		   let subsetCount = 1 << n // 2^n
		   var result = [[Int]]()
		   
		   for i in 0..<subsetCount {
			   var subset = [Int]()
			   for j in 0..<n {
				   if (i & (1 << j)) == 1 {
					   subset.append(nums[j])
				   }
			   }
			   result.append(subset)
		   }
		   
		   return result
	}
	/*
	 1. The binary representation of i acts as a "blueprint" for each subset.
	 2. Each bit in this binary number corresponds to an element in the original array.
	 3. If a bit is set (1), we include the corresponding element in the subset.
	 4. If a bit is not set (0), we exclude that element.
	 */
	
	
}

//print(Problem4().subsets([1,2,3]))


//5. Permutations
/*
 Given an array nums of unique integers, return all the possible permutations. You may return the answer in any order.
 */

class Problem5 {
	func permute(_ nums: [Int]) -> [[Int]] {
		var nums = nums
		var result = [[Int]]()
		
		func permuteHelper(level: Int) {
			if level >= nums.count {
				result.append(nums)
				return
			}
			for i in level..<nums.count {
				if i != level {
					nums.swapAt(i, level)
				}
				print("Level is \(level)")
				if level == 0 {print("You are back to top\n")}
				print("swap at i = \(i) and level = \(level)",nums)
				permuteHelper(level: level+1)
				nums.swapAt(i, level)
				print("return Level is \(level)")
				print("swap back at i = \(i) and level = \(level) now",nums)
			}
		}
		permuteHelper(level: 0)
		return result
	}
	
	func permute2(_ nums: [Int]) -> [[Int]] {
		var nums = nums
		var result = [[Int]]()
		var track = Array(repeating: false, count: nums.count)
		
		func permute2Helper(current: [Int]) {
			if current.count == nums.count {
				result.append(current)
				return
			}
			for i in 0..<nums.count {
				if track[i]  {continue}
				track[i] = true
				permute2Helper(current: current + [nums[i]])
				track[i] = false
			}
		}
		permute2Helper(current: [])
		return result
	}
	
	func permute3(_ nums: [Int]) -> [[Int]] {
		var result = [[Int]]()
		if nums.count == 0 {
			return [[]]
		}
		let perms = permute3(Array(nums[1...]))
		for  permutation in perms {
			var permutation = permutation + []
			for i in 0...permutation.count {
				var per_copy = permutation
				per_copy.insert(nums[0], at: i)
				result.append(per_copy)
			}
		}
		return result
	}
	
//	func permute4(_ nums: [Int]) -> [[Int]] {
//		var result = [[Int]]()
//
//	}
}

//print(Problem5().permute3([1,2,3]))


//Problem 6 Subset 2
/*
 Given an array nums of unique integers, return all the possible permutations. You may return the answer in any order.
 */

class Problem6 {
	func subsets2(_ nums: [Int]) -> [[Int]] {
		var result = [[Int]]()
		var subSet = [Int]()
		var nums = nums.sorted()
		
		func subsetsHelper(_ i: Int) {
			if i>=nums.count {
				result.append(subSet)
				return
			}
			
			subSet.append(nums[i])
			subsetsHelper(i+1)
			subSet.removeLast()
			var nextIndex = i + 1
			while nextIndex<nums.count && nums[nextIndex] == nums[i] { nextIndex += 1 }
			subsetsHelper(nextIndex)
		}
		subsetsHelper(0)
		return result
	}
}


//7. Palindrome Partitioning

/*
 Given a string s, split s into substrings where every substring is a palindrome. Return all possible lists of palindromic substrings.
 */

class Problem7 {
	
	func partition(_ s: String) -> [[String]] {
		   var res = [[String]]()
		   var path = [String]()
		func partitionHelper(_ i: Int, _ str: String) {
			   if i == s.count {
				   res.append(path)
				   return
			   }
			   for j in i..<str.count {
				   if isPalindrome(str, i, j) {
					   var start = str.index(str.startIndex, offsetBy: i)
					   var end = str.index(str.startIndex, offsetBy: j)
					   let left = str[start...end]
					   path.append(String(left))
					   partitionHelper(j+1, String(str))
					   path.removeLast()
				   }
			   }
		   }

		   func isPalindrome(_ s: String, _ i: Int, _ j: Int) -> Bool {
			   var s = Array(s)
			   var left = i
			   var right = j
			   while left<right {
				   if s[left] != s[right] {
					   return false
				   }
				   left += 1
				   right -= 1
			   }
			   return true
		   }
		   partitionHelper(0, s)
		   return res
	   }
}

//print("partition", Problem7().partition("aab"))


//8 Letter combinations

class Problem8 {
	func letterCombinations(_ digits: String) -> [String] {
		let digitToLetters: [String] = ["", "", "abc", "def", "ghi",
											  "jkl", "mno", "pqrs", "tuv", "wxyz"]
		var res = [String]()
		func backtrack(i: Int, cur: String) {
			if cur.count == digits.count {
				return res.append(cur)
			}
			let sdx = digits[digits.index(digits.startIndex, offsetBy: i)]
			var idx = 0
			if let ascii = sdx.asciiValue  {
				idx = Int(ascii) - Int(Character("0").asciiValue!)
			}
			
			for char in digitToLetters[idx] {
				backtrack(i: i+1, cur: cur + String(char))
			}
		}
		if digits.count>0 {
			backtrack(i: 0, cur: "")
		}
		return res
	   }
}

//print(Problem8().letterCombinations("23"))


class NQueenOptimised {
	func solveNQueens(_ n: Int) -> [[String]] {
		var res = [[String]]()
		var rowLeft = Array(repeating: 0, count: n)
		var leftDiagonal = Array(repeating: 0, count: 2*n - 1)
		var rightDiagonal = Array(repeating: 0, count: 2*n - 1)
		var board = Array(repeating: String(repeating: ".", count: n), count: n)
		
		
		func solve(col: Int) {
			if col == n {
				res.append(board)
				return
			}
			for row in 0..<n {
				if rowLeft[row] == 0 && leftDiagonal[row + col] == 0 &&
					rightDiagonal[n - 1 + col - row] == 0 {
					var newString = board[row]
					let startIndex = newString.index(newString.startIndex, offsetBy: col)
					let endIndex = newString.index(after: startIndex)
					newString.replaceSubrange(startIndex..<endIndex, with: "Q")
					board[row] = newString
					rowLeft[row] = 1
					leftDiagonal[row + col] = 1
					rightDiagonal[n - 1 + col - row] = 1
					
					solve(col: col+1)
					
					newString.replaceSubrange(startIndex..<endIndex, with: ".")
					board[row] = newString
					rowLeft[row] = 0
					leftDiagonal[row + col] = 0
					rightDiagonal[n - 1 + col - row] = 0
				
				}
			}
		}
		solve(col: 0)
		return res
	}
	
	
	func solveNQueensWithoutStringIndex(_ n: Int) -> [[String]] {
		var res = [[String]]()
		var rowLeft = Array(repeating: 0, count: n)
		var leftDiagonal = Array(repeating: 0, count: 2*n - 1)
		var rightDiagonal = Array(repeating: 0, count: 2*n - 1)
		var board = Array(repeating: Array(repeating: ".", count: n), count: n)
		
		func solve(col: Int) {
			if col == n {
				print("Printing board", board)

				let temp = board.reduce(into: [String](), {
					$0.append($1.joined())
				})
				res.append(temp)
				
				return
			}
			for row in 0..<n {
				if rowLeft[row] == 0 && leftDiagonal[row + col] == 0 &&
					rightDiagonal[n - 1 + col - row] == 0 {
					board[row][col] = "Q"
					rowLeft[row] = 1
					leftDiagonal[row + col] = 1
					rightDiagonal[n - 1 + col - row] = 1
					
					solve(col: col+1)
					
					board[row][col] = "."
					rowLeft[row] = 0
					leftDiagonal[row + col] = 0
					rightDiagonal[n - 1 + col - row] = 0
					
				}
			}
		}
		solve(col: 0)
		return res
	}
}

//print(NQueenOptimised().solveNQueensWithoutStringIndex(4))
//print("String.Index imp result below")
//print(NQueenOptimised().solveNQueens(4))


class PalindromePartition {
	func partition(_ s: String) -> [[String]] {
		let str = Array(s)
		var res = Array<Array<String>>()
		var cur = Array<String>()
		let n = s.count
		
		func solve(_ ind: Int) {
			if ind == n {
				res.append(cur)
				return
			}
			for i in ind..<n {
				if isPalindrome(str, ind, i) {
					let pre = s.prefix(i)
					cur.append(String(str[ind...i]))
					solve(i + 1)
					cur.removeLast()
				}
			}
		}
		solve(0)
		return res
	}
	
	private func isPalindrome(_ string: [Character], _ l: Int, _ r: Int) -> Bool {
		if l >= r {
			return true
		}
		if string[l] != string[r] {
			return false
		}
		return isPalindrome(string, l+1, r-1)
	}
}
//print(PalindromePartition().partition("aab"))

struct PermutationsSequence {
	func getPermutation(_ n: Int, _ k: Int) -> String {
		var res = ""
		var nums1 = Array(1...n)
		var nums = (1...n).map{$0}
		var fact = (1..<n).reduce(1,*)
		var k = k - 1
		
		while true {
			// We have to find in which range does k-1 belong
			res += String(nums[k/fact])
			nums.remove(at:k/fact)
			// Removing in a loop so check if empty at any level
			if nums.isEmpty {
				break
			}
			k = k % fact
			fact = fact/nums.count
		}
		return res
	}
}

//print(PermutationsSequence().getPermutation(4, 17))

	// Define a generic recursive operation handler
func recursiveOperation<T>(_ operation: @escaping (T, (T) -> T) -> T) -> (T) -> T {
	func recursive(_ value: T) -> T {
		print("In recursive function")
		return operation(value, recursive)
	}
	return recursive
}

func myRecursiveOp<T>(operation: @escaping (T, (T)->T) -> T) -> (T)->T {
	func recursiveFunction(_ value:T) -> T {
		return operation(value, recursiveFunction)
	}
	return recursiveFunction
}

let fibOperation: (Int, (Int)->Int) -> Int = { value, fibinocci in
	//guard let value >= 0 else { return -1 }
	return value <= 1 ? value : fibinocci(value-1) + fibinocci(value-2)
}

// Example usage with factorial
// Specify Int as the generic type
let operation:(Int, (Int) -> Int) -> Int = { n, factorial in
	return n <= 1 ? n : n * factorial(n - 1)
}

let fib = recursiveOperation(fibOperation)
print(fib(6))

// Using the factorial function
//let result = factorial(3)

let countOperation: (Int, (Int)->Int) -> Int = { number, recurse in
	// Print current number
	print(number)
	if number <= 0 {
		return 0
	}
	// Call itself with number - 1
	return recurse(number - 1)
}

let countDown = recursiveOperation(countOperation)
let countResult = countDown(3)


//
