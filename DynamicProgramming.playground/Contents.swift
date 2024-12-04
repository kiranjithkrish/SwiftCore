import UIKit

actor ProblemOne {
	func longestIncreasingSubSequence(_ nums: [Int]) -> Int  {
		// This is a kind of subsequence problem. We can use recursion and use pick and not pick 2^n time approach.
		let n = nums.count
		var len = 0
		func lis(_ index: Int, _ pre_index: Int) -> Int {
			if index >= n {
				return 0
			}
			len = 0 + lis(index+1, pre_index)
			// Not including the current so len added is 0
			if (pre_index == -1 || nums[pre_index] < nums[index]) {
				len = max(len, 1 + lis(index+1, index))
				// Including the current if the condition is true so len added is 1
			}
			return len
		}
		return lis(0,-1)
	}
}

actor ProblemTwo {
	func getAllSubSequences(_ nums: [Int]) -> [[Int]] {
		var res = [[Int]]()
		var cur = [Int]()
		let n = nums.count
		
		func sub_s(_ index: Int) {
			if index >= n {
				res.append(cur)
				return
			}
			sub_s(index+1)
			cur.append(nums[index])
			sub_s(index+1)
			cur.removeLast()
			
		}
		sub_s(0)
		return res
	}
}

struct ProblemThree {
	func lengthOfLIS(_ nums: [Int]) -> Int {
		let n = nums.count
		var lis = Array(repeating: 1, count: nums.count)
		for i in (0..<n).reversed() {
			for j in i+1..<n {
				if nums[i] < nums[j] {
					lis[i] = max(lis[i], 1 + lis[j])
				}
			}
		}
		let max_len = lis.reduce(Int.min) { (accumalator, current) in
				return max(accumalator, current)
		}
		return lis.max() ?? 1
	}
}


struct  ProblemFour {
	func longestPalindrome(_ s: String) -> String {
		var res: Substring = ""
		//Build this string res and return it.
		// Note that we will use the EXPAND AROUND CENTER technique
		var res_len = 0
		var str = Array(s)
		let n = s.count
		for i in 0..<s.count {
			// Odd length
			var (lo,ro) = (i,i)
			while (lo>=0 && ro<n && str[lo] == str[ro]) {
				if (ro-lo+1) > res_len {
					res_len = ro - lo + 1
					let start = s.index(s.startIndex, offsetBy:lo)
					let end = s.index(s.startIndex, offsetBy:ro+1)
					res = s[start..<end]
				}
				lo -= 1
				ro += 1
			}
			// Even length
			
			var (le,re) = (i,i+1)
			while (le>=0 && re<n && str[le] == str[re]) {
				if (re-le+1) > res_len {
					res_len = re - le + 1
					let start = s.index(s.startIndex, offsetBy:le)
					let end = s.index(s.startIndex, offsetBy:re+1)
					res = s[start..<end]
				}
				le -= 1
				re += 1
			}
		}
		return String(res)
	}
}


struct ProblemFive {
	
	func countSubstrings(_ s: String) -> Int {
		var str = Array(s)
		let n = s.count
		var count = 0
		var count_even = n
		for i in 0..<s.count {
				// Odd length
			var (lo,ro) = (i,i)
			while (lo>=0 && ro<n && str[lo] == str[ro]) {
				count += 1
				lo -= 1
				ro += 1
			}
				// Even length
			
			var (le,re) = (i,i+1)
			while (le>=0 && re<n && str[le] == str[re]) {
				count += 1
				le -= 1
				re += 1
			}
		}
		return count
	}
}
//print(ProblemFive().countSubstrings("abba"))

struct ProblemSix {
	func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
		let n = s.count
		var dp = Array(repeating: false, count: n+1)
		dp[n] = true
		//n+1 because the base condition is if we can reach the end of string s then we can work break else false
		for i in (0..<n).reversed() {
			for word in wordDict {
				if (word.count + i <= n) {
					let start = s.index(s.startIndex, offsetBy:i)
					let end = s.index(s.startIndex, offsetBy: i + word.count)
					let subString = s[start..<end]
					if (subString == word) {
						dp[i] = dp[i + word.count]
					}
				}
				if dp[i] {
					break
				}
			}
		}
		return dp[0]
	}
}

struct ProblemSeven {
	func canPartition(_ nums: [Int]) -> Bool {
		let s:Int = nums.reduce(0,+)
		let n = nums.count
		if s % 2 != 0 { return false }
		let k = s/2
		var dp = Set<Int>()
		dp.insert(0)
		for i in (0..<n).reversed() {
			var dpCopy = dp
			for target in dp {
				dpCopy.insert(target + nums[i])
				if dpCopy.contains(k) {return true}
			}
			dp = dpCopy
		}
		
		return false
	}
}

struct ProblemEight {
	func longestCommonSubsequenceTLE(_ text1: String, _ text2: String) -> Int {
		var dp = Array(repeating: Array(repeating: 0, count: text2.count), count: text1.count)
		for i in (0..<text1.count).reversed() {
			for j in (0..<text2.count).reversed() {
				// this below is a time consuming operation when executed in a double for loop so you get TLE error. Use convert string to arrays before the loop itself
				let idx = text1.index(text1.startIndex, offsetBy:i)
				let jdx = text2.index(text2.startIndex, offsetBy:j)
				if (text1[idx] == text2[jdx]) {
					dp[i][j] = 1 + dp[i+1][j+1]
				} else {
					dp[i][j] = max(dp[i+1][j], dp[i][j+1])
				}
			}
		}
		return dp[0][0]
	}
	
	func longestCommonSubsequence(_ text1: String, _ text2: String) -> Int {
//		var dp = Array(repeating: Array(repeating: 0, count: text2.count + 1), count: text1.count + 1)
		var dp = Array(0..<text1.count + 1).map { _ in Array(repeating: 0, count: text2.count + 1)}
		print("dp is", dp)
		let text1Array = Array(text1)
		let text2Array = Array(text2)
		for i in (0..<text1.count).reversed() {
			for j in (0..<text2.count).reversed() {
					// this below is a time consuming operation when executed in a double for loop so you get TLE error. Use convert string to arrays before the loop itself
				//let idx = text1.index(text1.startIndex, offsetBy:i)
				//let jdx = text2.index(text2.startIndex, offsetBy:j)
				if (text1Array[i] == text2Array[j]) {
					dp[i][j] = 1 + dp[i+1][j+1]
				} else {
					dp[i][j] = max(dp[i+1][j], dp[i][j+1])
				}
			}
		}
		return dp[0][0]
	}
}
//print(ProblemSix().wordBreak("neetcode",["neet", "code", "leet"]))


//print(ProblemOneDP().lengthOfLIS([0,3,1,3,2,3]))
print(ProblemEight().longestCommonSubsequence("Kiran", "Manji"))

//Task {
//	try await Task.sleep(for: .seconds(1))
//	let subs =  await ProblemTwo().getAllSubSequences([1,2,3])
//	
//	subs.map {
//		print("\($0)")
//	}
//}

	


//Task {
//	try await Task.sleep(for: .seconds(2))
//	let max_len = await ProblemOne().longestIncreasingSubSequence([0,3,1,3,2,3])
//	print(max_len)
//}





