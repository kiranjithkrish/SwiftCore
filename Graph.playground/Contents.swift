//1. Number of islands

/*
 Given an m x n 2D binary grid grid which represents a map of '1's (land) and '0's (water), return the number of islands.

 An island is surrounded by water and is formed by connecting adjacent lands horizontally or vertically. You may assume all four edges of the grid are all surrounded by water.

 */

func numIslands(_ grid: [[Character]]) -> Int {
	let (rows, colums) = (grid.count, grid[0].count)
	var island = 0
	var visited = Array(repeating: Array(repeating: false, count: colums), count: rows)
	
	func bfs(r: Int, c: Int) {
		var q = [(Int,Int)]()
		q.append((r,c))
		visited[r][c] = true
		while !q.isEmpty {
			let current = q.removeFirst()
			let directions = [(1,0), (-1,0), (0,1), (0,-1)]
			for direction in directions {
				let (row, col) = (current.0 + direction.0, current.1 + direction.1)
				if row >= 0 && row < rows && col >= 0 && col < colums && grid[row][col] == "1" && visited[row][col] == false {
					q.append((row,col))
					visited[row][col] = true
				}
			}
			
		}
	}
	
	for i in 0..<rows {
		for j in 0..<colums {
			if grid[i][j] == "1" && !visited[i][j] {
				bfs(r: i, c: j)
				island += 1
			}
		}
	}
	return island
}


//2. Clone Graph

/*
 Given a reference of a node in a connected undirected graph.

 Return a deep copy (clone) of the graph.
 */


class Problem2 {
	
	class Node: Hashable {

		var val: Int
		var neighbors: [Node]
		
		init(val: Int) {
			self.val = val
			self.neighbors = []
		}
		
		static func == (lhs: Problem2.Node, rhs: Problem2.Node) -> Bool {
			return lhs.val == rhs.val
		}
		
		func hash(into hasher: inout Hasher) {
			hasher.combine(val)
		}
	}
	
	func cloneGraph(_ node: Node?) -> Node? {
		var oldToNew = [Node:Node]()
		
		func dfs(current: Node) -> Node {
			if let currentIn = oldToNew[current] {
				return  currentIn
			}
			let copy = Node(val: current.val)
			oldToNew[current] = copy
			for neighbor in current.neighbors {
				let current = dfs(current: neighbor)
				copy.neighbors.append(current)
			}
			return copy
		}
		if let currentNode = node {
			return dfs(current: currentNode)
		}
		return nil
	}
}

struct Tuple: Hashable {
	let x: Int
	let y: Int
	
	init(_ x: Int, _ y: Int) {
		self.x = x
		self.y = y
	}
}

//3. pacificAtlantic

class Solution3 {
	
	func pacificAtlantic(_ heights: [[Int]]) -> [[Int]] {
		let (rows, cols) = (heights.count, heights[0].count)
		var (p_que, a_que) = ([Tuple](),[Tuple]())
		var (p_seen, a_seen) = (Set<Tuple>(), Set<Tuple>())
		
		for j in 0..<cols {
			p_que.append(Tuple(0,j))
			p_seen.insert(Tuple(0, j))
			
		}
		for i in 1..<rows {
			p_que.append(Tuple(i, 0))
			p_seen.insert(Tuple(i, 0))
			
		}
		
		for i in 0..<rows {
			a_que.append(Tuple(rows-1, i))
			a_seen.insert(Tuple(rows-1, i))
			
		}
		for i in 1..<cols-1 {
			a_que.append(Tuple(i, cols-1))
			a_seen.insert(Tuple(i, cols-1))
			
		}
		
		func bfs(queue: [Tuple], seen: Set<Tuple>) -> Set<Tuple> {
			var coord = Set<Tuple>()
			var queue = queue
			var seen = seen
			while !queue.isEmpty {
				let current = queue.removeFirst()
				coord.insert(current)
				let directions = [Tuple(1,0),Tuple(-1,0),Tuple(0,1),Tuple(0,-1)]
				for direction in directions {
					let (curX, curY) = (direction.x + current.x, direction.y + current.y)
					if curX>=0 && curX<rows && curY>=0 && curY<cols &&
						heights[direction.x][direction.y] >= heights[current.x][current.y] &&
						seen.contains(where: {$0 == direction}) {
						queue.append(direction)
						seen.insert(direction)
					}
				}
			}
			return coord
		}
		
		let pacific = bfs(queue: p_que, seen: p_seen)
		let altantic = bfs(queue: a_que, seen: a_seen)
		let result =  pacific.intersection(altantic).map({[$0.x, $0.y]})
		return result
		
	}
}

//4. Course Schedule

/*
 There are a total of numCourses courses you have to take, labeled from 0 to numCourses - 1. You are given an array prerequisites where prerequisites[i] = [ai, bi] indicates that you must take course b first if you want to take course a.
 */


class Problem3 {
	func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
		var preMap = [Int:[Int]]()
		var visited = Set<Int>()
		for pre in prerequisites {
			preMap[pre[0], default: []].append(pre[1])

		}
		print("Pre map is",preMap)
		func dfs(crs: Int) -> Bool {
			print("current course in dfs is", crs)
			if visited.contains(crs) { return false } //This is  loop and hence cannot complete course
			guard let pres = preMap[crs], !pres.isEmpty else {
				print("Prerequisite of \(crs) is empty list")
				return true
			}
			visited.insert(crs)
			print("Added \(crs) to visited")
			for pre in pres {
				print("pre requisite for current course \(crs) is", pre)
				if !dfs(crs: pre) { return false }
			}
			print("Remove \(crs) from visited")
			visited.remove(crs) //In dfs or recursion remove the node after processing
			print("current pre array for \(crs) in premap is", preMap[crs] ?? [])
			print("Clear premap for \(crs)")
			preMap[crs]?.removeAll() // This is an important step, otherwise the program will exceed time limit for large input because we have to again process every course that we already processed. Remember we are calling the dfs for every course in the numCourses.
			return true
		}
		
		for crs in 0..<numCourses {
			print("current course starting is", crs)
			if !dfs(crs: crs) {return false}
		}
		return true
	}
}

// Test Cases
//let solution = Problem3()

//print(solution.canFinish(5, [[0, 1], [0, 2], [1, 3], [1,4], [3,4]]))

//5. Valid Tree
/*
 Given n nodes labeled from 0 to n - 1 and a list of undirected edges (each edge is a pair of nodes), write a function to check whether these edges make up a valid tree.
 */

class Problem4 {
	func validTree(n: Int, edges: [[Int]]) -> Bool {
		if n == 0 {
			return true
		}
		if n-1 != edges.count {
			return false
		}
		var adjList = [Int:[Int]]()
		guard  !edges.isEmpty else {
			return false
		}
		for (n1,n2) in edges.map({($0[0],$0[1])}) {
			adjList[n1, default: []].append(n2)
			adjList[n2, default: []].append(n1)
		}
		print("adj list",adjList)
		var visited = Set<Int>()
		
		func dfs(cur: Int, prev: Int) -> Bool {
			if visited.contains(cur) {
				return false
			}
			visited.insert(cur)
			
			for neighbor in adjList[cur]! {
				if neighbor == prev {
					continue
				}
				if !dfs(cur: neighbor, prev: cur) { return false }
			}
			return true
			
		}
		return dfs(cur: 0, prev: -1) && visited.count == n
	}
}

//print(Problem4().validTree(n: 5, edges: [[0, 1], [0, 2], [0, 3], [1, 4]]))

//5. Count Connected Components

/*
 There is an undirected graph with n nodes. There is also an edges array, where edges[i] = [a, b] means that there is an edge between node a and node b in the graph.
 */

class DisjointSet {
	var parent: [Int]
	var size: Array<Int>
	
	init(n: Int) {
		self.parent = Array(0...n)
		self.size = Array(repeating: 0, count: n+1)
	}
	
	func findTopParentOf(node: Int) -> Int {
		if node == parent[node] {
			return node
		}
		parent[node] = findTopParentOf(node: parent[node])
		return parent[node]
	}
	
	func UnionBySize(u: Int, v: Int) -> Int {
		let top_u = self.findTopParentOf(node: u)
		let top_v = self.findTopParentOf(node: v)
		if top_u == top_v {
			return 0
		}
		if size[top_u] > size[top_v] {
			parent[top_v] = top_u
			size[top_u] += size[top_v]
		} else {
			parent [top_u] = top_v
			size[top_v] += size[top_u]
		}
		return 1
 	}
}

class Problem5 {
	
	func countConnectedComponents(n: Int, edges: [[Int]]) -> Int {
		guard n>0 else {
			return 0
		}
		var res = n
		var ds = DisjointSet(n: n)
		for (n1,n2) in edges.compactMap({ edge -> (Int,Int)? in
			guard edge.count>=2 else {
				return nil // Skip malformed edges
			}
			let n1 = edge[0]
			let n2 = edge[1]
			guard n1>=0 && n1<n+1 && n2>=0 && n2<n, n1 != n2 else {
				return nil
			}
			// we have to also check for out of range edge node and self-loops
			
			return (n1, n2)
		}) {
			res -= ds.UnionBySize(u: n1, v: n2)
		}
		return res
	}
}
Problem5().countConnectedComponents(n: <#T##Int#>, edges: <#T##[[Int]]#>)


