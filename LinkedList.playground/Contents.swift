/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init() { self.val = 0; self.next = nil; }
 *     public init(_ val: Int) { self.val = val; self.next = nil; }
 *     public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
 * }
 */

class ListNode {
	let val: Int
	var next: ListNode?
	init(val: Int, next: ListNode? = nil) {
		self.val = val
		self.next = next
	}
}
//1. Reorder List
class Solution {
	func reorderList(_ head: ListNode?) {
		// Step 1: Find the middle of the list and break the list
		var slow = head
		var fast = head?.next
		while fast != nil, fast?.next != nil {
			slow = slow?.next
			fast = fast?.next?.next ?? nil
		}
		var mid  = slow?.next
		slow?.next = nil
		// Step 2:Reverse the second list
		var second = mid
		var prev: ListNode? = nil
		while second != nil {
			let next = second?.next
			second?.next = prev
			prev = second
			second = next
		}

		//Step 3: Merge the list
		var first = head
		var last: ListNode? = prev
		while last != nil {
			let temp1 = first?.next
			let temp2 = last?.next
			first?.next = last
			last?.next = temp1
			last = temp2
			first = temp1
		}
		
		
		
	}
}

var one = ListNode(val: 2, next: nil)
one.next = ListNode(val: 4, next: nil)
one.next?.next = ListNode(val: 6, next: nil)
one.next?.next?.next = ListNode(val: 8, next: nil)
one.next?.next?.next?.next = ListNode(val: 10, next: nil)

//print(Solution().reorderList(one))
// Remember the steps here. Also make sure the links are properly set during merging.

/*
 You are given the beginning of a linked list head, and an integer n.

 Remove the nth node from the end of the list and return the beginning of the list.
 */

//2. Remove Nth Node
class Node {
	let value: Int
	var next: Node?
	
	init(value: Int, next: Node? = nil) {
		self.value = value
		self.next = next
	}
}


func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode?  {
	let dummy = ListNode(val: 0, next: head)
	var left: ListNode? = dummy
	var right = head
	var target = n
	
	while right != nil, target>0 {
		right = right?.next
		target -= 1
	}
	
	while let rightNode = right, let leftNode = left, let rightNext = rightNode.next, let leftNext = leftNode.next {
		right = rightNext
		left = leftNext
	}
	
	left?.next = left?.next?.next
	return dummy.next ?? nil
}

removeNthFromEnd(one, 2)


//3. Merge two sorted list

//4. Copy Random List

class ProblemNo4 {
	
	//Definition for a Node.
	public class Node: Hashable {
		public var val: Int
		public var next: Node?
		public var random: Node?
		public init(_ val: Int) {
			self.val = val
			self.next = nil
			self.random = nil
		}
		
		public static func ==(lhs: Node, rhs: Node) -> Bool {
			return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
		}
		
		public func hash(into hasher: inout Hasher) {
			hasher.combine(ObjectIdentifier(self))
		}
	}
	

	
		func copyRandomList(_ head: Node?) -> Node? {
			var nodeMapping = [Node?: Node]()
			
			// First pass: Create copies of all nodes
			var current = head
			while let currentNode = current {
				nodeMapping[currentNode] = Node(currentNode.val)
				current = currentNode.next
			}
			
			// Second pass: Connect next and random pointers of copied nodes
			current = head
			while let currentNode = current {
				if let copiedNode = nodeMapping[currentNode] {
					// Note here we are able to modiy the properties though copiedNode is declared let is as Node is reference type. Not possible with struct
					copiedNode.next = nodeMapping[currentNode.next]
					copiedNode.random = nodeMapping[currentNode.random]
				}
				current = currentNode.next
			}
			
			// Return the head of the copied list
			return nodeMapping[head]
		}
	
}


//5. Add two non empty lists

class Problem5 {
	
	func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
		let dummy = ListNode(val: 0)
		var l1 = l1
		var l2 = l2
		var current = dummy
		var carry = 0
		while l1 != nil || l2 != nil || carry > 0 {
			let v1 = l1?.val ?? 0
			let v2 = l2?.val ?? 0
			
			let val = v1 + v2 + carry
			
			carry = val / 10
			let digit = val % 10
			
			current.next = ListNode(val: digit)
			if let next = current.next {
				current = next
			}
			l1 = l1?.next
			l2 = l2?.next
			
		}
		return dummy.next ?? nil
	}
}

//6. Detect cycle in in list

class Problem6 {
	
	func hasCycle(_ head: ListNode?) -> Bool {
		var slow = head
		var fast = head
		
		while let fastPtr = fast, let slowPtr = slow, let fastNextPtr = fast?.next {
			slow = slowPtr.next
			fast = fastNextPtr.next
			if slow === fast {
				return true
			}
		}
		return false
	}
}

// Find duplicate in the given list

/*
 Given an array of integers nums containing n + 1 integers where each integer is in the range [1, n] inclusive.

 There is only one repeated number in nums, return this repeated number.

 You must solve the problem without modifying the array nums and using only constant extra space.

 */

class Problem7 {
	func findDuplicate(_ nums: [Int]) -> Int {
		var slow = 0
		var fast = 0
		// Note here the condition for the repeat while loop is always true because we know for sure this is a linked list with a loop. So we are trying to find the starting of the loop in two steps
		//step 1. Find the intersection of slow and fast pointer
		repeat {
			slow = nums[slow]
			print("step 1, slow is", slow)
			fast = nums[nums[fast]]
			print("step 1, fast is", fast)
			if slow == fast {
				break
			}
			
		} while(true)
		print("\n")
		//step 2: find the second intersection. This will be the starting of the loop. Note that the distance of the slow 2 and the slow(at the first intersection) from the second intersection will always be the same.
		var slow2 = 0
		repeat {
			slow = nums[slow]
			print("step 2, slow is", slow)
			slow2 = nums[slow2]
			print("step 2, slow 2 is", slow2)
			if slow == slow2 {
				return slow
			}
		} while (true)
	}
}


Problem7().findDuplicate([1,2,3,4,4])
