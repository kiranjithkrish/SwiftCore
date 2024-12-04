//3.Find Minimum In Rotated Sorted Array

/*
 You are given an array of length n which was originally sorted in ascending order. It has now been rotated between 1 and n times. For example, the array nums = [1,2,3,4,5,6] might become:

 [3,4,5,6,1,2] if it was rotated 4 times.
 [1,2,3,4,5,6] if it was rotated 6 times.
 Notice that rotating the array 4 times moves the last four elements of the array to the beginning. Rotating the array 6 times produces the original array.

 Assuming all elements in the rotated sorted array nums are unique, return the minimum element of this array.

 A solution that runs in O(n) time is trivial, can you write an algorithm that runs in O(log n) time?
 */

//Note that the array is sorted,the expected time complexity is O(logn) and it is a search problem - A good indication that binary search could be a possible solution.
func findMin(nums: [Int]) -> Int {
	var res = nums[0] //Initial result
	var left = 0
	var right = nums.count-1
	
	while(left<=right) {
		if nums[left] <= nums[right] {
			return min(res, nums[left])
		}
		let mid = Int((left + right) / 2)
		res = min(res, nums[mid])
		if nums[mid] >= nums[left] {
			left = mid+1
		} else {
			right = mid-1
		}
	}
	return res
}

func searchInARotatedSortedArray(_ nums: [Int], _ target: Int) -> Int {
	var left = 0
	var right = nums.count - 1
	
	while left<=right {
		let mid = (left+right)/2
		if nums[mid] == target {
			return mid
		}
		//Left sorted
		if nums[left] <= nums[mid] {
			
			if target >= nums[left] && target < nums[mid] {
				right = mid - 1
			} else {
				left = mid + 1
			}
		} else {
			if target > nums[mid] && target <= nums[right] {
				left = mid + 1
			} else {
				right = mid - 1
			}
		}
		print("Searching in array from \(left) to \(right)")
	}
	return -1
}

print("index of target",searchInARotatedSortedArray([4,5,6,7,0,1,2,15,0,77], 5))


print(findMin(nums: [4,5,6,7,0,1,2]))
// The strategy here is


//4. Find Target in Rotated Sorted Array

/*
 You are given an array of length n which was originally sorted in ascending order. It has now been rotated between 1 and n times. For example, the array nums = [1,2,3,4,5,6] might become:

 [3,4,5,6,1,2] if it was rotated 4 times.
 [1,2,3,4,5,6] if it was rotated 6 times.
 Given the rotated sorted array nums and an integer target, return the index of target within nums, or -1 if it is not present.

 You may assume all elements in the sorted rotated array nums are unique,

 A solution that runs in O(n) time is trivial, can you write an algorithm that runs in O(log n) time?
 */

func search(nums: [Int], target: Int) -> Int {
	var l = 0
	var r = nums.count-1
	while l<=r {
		let m = Int((l+r)/2)
		if target == nums[m] {
			return m
		} else if target == nums[l] {
			return l
		} else if target == nums[r] {
			return r
		} else if nums[l] <= nums[m] {
			//left is the sorted array
			if target > nums[m] || target < nums[l] {
				l = m + 1
			} else {
				r = m - 1
			}
			
		} else {
			// right is the sorted array
			if target < nums[m] || target > nums[r] {
				r = m - 1
			} else {
				l = m + 1
			}
		}
	}
	return -1
}
// The strategy here is to figure out the sorted portion. Once sorted portion is figured, it is easy to locate the target


//3. Search in a 2D Matrix

class Problem3 {
	
	func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
		//check if matrix[0] exits?
		let (rows, colums) = (matrix.count, matrix[0].count)
		var (top, bottom) = (0, rows-1)
		var midRow = (top+bottom)/2
		while top<=bottom {
			if target > matrix[midRow][colums-1] {
				top = midRow + 1
			} else if target < matrix[midRow][0] {
				bottom = midRow - 1
			} else {
				midRow = top
				break
			}
		}
		
		if top>bottom {
			return false
		}
		
		var (left, right) = (0, colums-1)
		var mid = (left+right)/2
		while left <= right {
			if target < matrix[midRow][mid] {
				right = mid - 1
			} else if target > matrix[midRow][mid] {
				left = mid + 1
			} else {
				return true
			}
		}
		
		return false
			
		
	}
}


//4. Time map dictionary

/*
 Implement a time-based key-value data structure that supports:

 Storing multiple values for the same key at specified time stamps
 Retrieving the key's value at a specified timestamp

 Note that since the set is time stamped, the list of tuples(value, timestamp) will be sorted in time
 */

class Problem4 {
	
	class TimeMap {
		var map = [String:[(String, Int)]]()

		init() {
			
		}
		
		func set(_ key: String, _ value: String, _ timestamp: Int) {
			map[key, default: []].append((value, timestamp))
		}
		
		func get(_ key: String, _ timestamp: Int) -> String {
			var res = ""
			guard let mapValues = map[key] else { return res }
			// as the tuples are sorted we do binary search to find out if the value fo timestamp exists
			var (left, right) = (0, mapValues.count-1)
			while left<=right {
				let mid = (left+right)/2
				if mapValues[mid].1 == timestamp {
					return mapValues[mid].0
				} else if mapValues[mid].1 < timestamp {
					left = mid + 1
					res = mapValues[mid].0
				} else if mapValues[mid].1 > timestamp {
					right = mid - 1
				}
			}
			
			return res
		}
	}
}
