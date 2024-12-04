//1.Lower common ancestor
/*Given a binary search tree (BST), find the lowest common ancestor (LCA) node of two given nodes in the BST.*/

//class TreeNode {
//	let val: Int
//	var left: TreeNode?
//	var right: TreeNode?
//	
//	init(val: Int, left: TreeNode? = nil, right: TreeNode? = nil) {
//		self.val = val
//		self.left = left
//		self.right = right
//	}
//}

public class TreeNode {
	public var val: Int
	public var left: TreeNode?
	public var right: TreeNode?
	public init() { self.val = 0; self.left = nil; self.right = nil; }
	public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
	public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
		self.val = val
		self.left = left
		self.right = right
	}
}
 


class Solution {
	func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
		var current = root
		while let currentNode = current, let pNode = p, let qNode = q {
			if pNode.val > currentNode.val, qNode.val > currentNode.val, let right = currentNode.right {
				current = right
			} else if pNode.val < currentNode.val, qNode.val < currentNode.val, let left = currentNode.left {
				current = left
			} else {
				return current
			}
		}
		return current
	}
	
	
}


//2. Level Order Traversal
/*Given a binary tree root, return the level order traversal of it as a nested list, where each sublist contains the vals of nodes at a particular level in the tree, from left to right.*/

// Note :
/*
 while i<q.count is not working
 Changing this inner loop to for _ in 0..<q.count is working
 This is because with while loop the array is getting removed and also i is being incremented. This will cause undesirable behaviour. Use for loop here so that q.removeFirst() doesn't effect the current iteration. 0..q.count is the current level so removing the first doesn't effect 

 */
class Solution2 {
	func levelOrder(_ root: TreeNode?) -> [[Int]] {
		var q = [TreeNode?]()
		var result = [[Int]]()
		q.append(root)
		while !q.isEmpty {
			var level = [Int]()
			// To process each level
			for _ in 0..<q.count { // Note that appending items below will not change the count in the for loop
				//print("Looping")
				var current: TreeNode?
				//Pop
				if let first = q.removeFirst() {
					current = first
				}
				// Add its children to Q
				if let currentNode = current {
					level.append(currentNode.val)
					//print("Level is", level)
					q.append(currentNode.left)
					q.append(currentNode.right)
				}
				q.map({print($0?.val ?? 0)})
				//print("\n")
				
			}
			//print("Adding to result", level)
			result.append(level)
		}
		return result
		
	}
	
	func levelOrderRecursion(_ root: TreeNode?) -> [[Int]] {
			var result = [[Int]]()
			func levelOrderHelper(_ node: TreeNode?, level: Int){
				guard let node = node else {
					return
				}
				if result.count == level {
					result.append([])
				}
				result[level].append(node.val)
				levelOrderHelper(node.left, level: level+1)
				levelOrderHelper(node.right, level: level+1)
			}
		return result
	}
}


	
//3. Validate BST
/*
 Given the root of a binary tree, return true if it is a valid binary search tree, otherwise return false.

 A valid binary search tree satisfies the following constraints:

 The left subtree of every node contains only nodes with keys less than the node's key.
 The right subtree of every node contains only nodes with keys greater than the node's key.
 Both the left and right subtrees are also binary search trees.

 */

class Solution3 {
	func isValidBST(_ root: TreeNode?) -> Bool {
		func isValid(current: TreeNode?, left: Int, right: Int) -> Bool {
			guard let current else {
				return true
			}
			if !(right > current.val && left<current.val) {
				return false
			}
			return isValid(current: current.left, left: left, right: current.val) &&
			isValid(current: current.right, left: current.val, right: right)
		}
		return isValid(current: root, left: Int.max, right: Int.min)
	}
}

//4. Kth smallest interget in BST

/*Given the root of a binary search tree, and an integer k, return the kth smallest value (1-indexed) in the tree.*/

class Solution4 {
	func kthSmallest(_ root: TreeNode?, _ k: Int) -> Int {
		var n = 0
		var stack = [TreeNode?]()
		var current = root
		while current != nil || !stack.isEmpty {
			while current != nil {
				stack.append(current)
				current = current?.left
			}
			current = stack.removeLast()
			n += 1
			if n == k {
				return current?.val ?? Int.min
			}
			current = current?.right
		}
		return Int.min
	}
}

class Solution5 {
	func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
		var rootMap = [Int: Int]()
//		for (idx, value) in inorder.enumerated() {
//			rootMap[value] = idx
//		}
		let indices = 0..<inorder.count
		var rootDict = Dictionary(uniqueKeysWithValues: zip(inorder, indices))
		
		return buildTreeHelper2(preorder[0], 0, preorder.count-1)
		
		func buildTreeHelper(_  preStart: Int, _ preEnd: Int, _ inStart: Int, _ inEnd: Int) -> TreeNode? {
			if preStart > preEnd || inStart > inEnd {
				return nil
			}
			var root = TreeNode(preorder[preStart])
			guard let mid = inorder.firstIndex(of: preorder[preStart])  else {
				return nil
			}
			let numsLeft = mid - inStart
			let numsRight = inEnd - mid
			
			root.left = buildTreeHelper(preStart+1, preStart + numsLeft, inStart, mid-1)
			
			root.right = buildTreeHelper(preStart + numsLeft + 1, preEnd, mid + 1, inEnd)
			
			return root
			
			
		}
		
		func buildTreeHelper2(_ rootIndex: Int, _ left: Int, _ right: Int) -> TreeNode? {
			if left > right {
				return nil
			}
			var root = TreeNode(preorder[rootIndex])
			guard let mid = rootDict[preorder[rootIndex]]  else {
				return nil
			}
			let numsLeft = mid - left
			let numsRight = right - mid
			
			if mid > left {
				root.left = buildTreeHelper2(rootIndex+1, left, mid-1)
			}
			if mid < right {
				root.right  = buildTreeHelper2(rootIndex + numsLeft + 1, mid+1, right)
			}
			return root
		}
		
	}
	
}
// This program is crashing ***************.../////********
let solution = Solution5()
let preorder = [3, 9, 20, 15, 7]
let inorder = [9, 3, 15, 20, 7]


//if let tree = solution.buildTree(preorder, inorder) {
//	print("Tree constructed successfully.")
//} else {
//	print("Failed to construct tree.")
//}


//6: Binary Tree Right Side View

/*
 Given the root of a binary tree, imagine yourself standing on the right side of it, return the values of the nodes you can see ordered from top to bottom.
 */

class Problem6 {
	func rightSideView(_ root: TreeNode?) -> [Int] {
		var result = [Int]()
		var q = [TreeNode?]()
		q.append(root)
		
		while !q.isEmpty {
			var rightSide: TreeNode?
			for i in 0..<q.count {
				var current = q.removeFirst()
				print("Current is", current?.val ?? 0)
				// The for loop loops every item in the level, so the value in the var rightSide will be item in the right most by the time loop exits
				if let current {
					rightSide = current
					q.append(current.left)
					q.append(current.right)
				}
			}
			print("right side", rightSide)
			
			if let rightSide {
				result.append(rightSide.val)
			}
		}
		
		return result
	}
}


let root = TreeNode(1)
root.left = TreeNode(2)
//root.right = TreeNode(3)
//root.left?.left = TreeNode(4)
//root.left?.right = TreeNode(5)
//root.right?.left = TreeNode(6)
//root.right?.right = TreeNode(7)

//print(Problem6().rightSideView(root))

class Problem7 {
	func goodNodes(_ root: TreeNode?) -> Int {
		
		func dfs(_ node: TreeNode?, _ maxValue: Int) -> Int {
			guard let node = node else { return 0 }
			var res =  node.val >= maxValue ? 1 : 0
			let maxNow = max(maxValue, node.val)
			res += dfs(node.left, maxNow)
			res += dfs(node.right, maxNow)
			return res
		}
		let start = root?.val ?? Int.min
		return dfs(root, start)
	}
}

//8. Max depth of as binary tree
class Problem8 {
	// There are 3 approaches to solving this problem
	// 1. Recursive Depth First Traversal
	// 2. Breadth First traversal similar to level order traversal
	//3. Iterative DFT using stack
	
}
