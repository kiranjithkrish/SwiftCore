// 1. Find kth largest using Quick select which gives O(n) in the average case. Other solutions are 1. sort and take nums.cout - k th element 2. use a maxHeap

func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
	var k = nums.count - k
	func quickSelect(l: Int, r: Int) -> Int {
		var nums = nums
		var p = 0
		var pivot = nums[r]
		for i in l..<r {
			if nums[i] <= pivot {
				nums.swapAt(i, p)
				p += 1
			}
			nums.swapAt(p, r)
		}
		if p > k {
			return quickSelect(l: l, r: p-1)
		} else if p < k {
			return quickSelect(l: p+1, r: r)
		} else {
			return nums[p]
		}
		
	}
	return quickSelect(l: 0, r: nums.count-1)
}

//2. Task scheduler
  
func leastInterval(_ tasks: [Character], _ n: Int) -> Int {
	
	var countMap = tasks.reduce(into: [Character:Int]()) { map, char in
		map[char, default: 0] += 1
	}
	var counts = countMap.values.reduce(into: [Int]()) { list, val in
		list.append(val)
	}
	// Create the max heap
	var maxHeap = counts.reduce(into: Heap<Int>(priorityFunction: >)) { heap, count in
		heap.push(count)
	}
	print(maxHeap)
	
	var time = 0
	var q = [(Int,Int)]()
	
	while !maxHeap.isEmpty || !q.isEmpty {
		print("Hello")
		time += 1
		if var count = maxHeap.pop(), count > 1 {
			var newCount = count - 1
			q.append((newCount, time + n))
			print("current q is", q)
		}
		
		print("time is", time)
		if !q.isEmpty, q[0].1 == time {
			let first = q.removeFirst()
			maxHeap.push(first.0)
		}
		print("maxHeap in the end",maxHeap)
		print("q", q)
	}
	
	return time
}


struct Heap<Element: Comparable> {
	private var elements: [Element]
	private let priorityFunction: (Element, Element) -> Bool
	
	var isEmpty: Bool {
		return elements.isEmpty
	}
	
	var count: Int {
		return elements.count
	}
	
	var peek: Element? {
		return elements.first
	}
	
	init(elements: [Element] = [], priorityFunction: @escaping (Element, Element) -> Bool) {
		self.elements = elements
		self.priorityFunction = priorityFunction
		buildHeap()
	}
	
	mutating func push(_ element: Element) {
		elements.append(element)
		siftUp(from: elements.count - 1)
	}
	
	mutating func pop() -> Element? {
		guard !isEmpty else { return nil }
		elements.swapAt(0, count - 1)
		let element = elements.removeLast()
		if !isEmpty {
			siftDown(from: 0)
		}
		return element
	}
	
	private mutating func buildHeap() {
		for i in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
			siftDown(from: i)
		}
	}
	
	private mutating func siftUp(from index: Int) {
		var childIndex = index
		let child = elements[childIndex]
		var parentIndex = self.parentIndex(ofChildAt: childIndex)
		
		while childIndex > 0 && priorityFunction(child, elements[parentIndex]) {
			elements[childIndex] = elements[parentIndex]
			childIndex = parentIndex
			parentIndex = self.parentIndex(ofChildAt: childIndex)
		}
		
		elements[childIndex] = child
	}
	
	private mutating func siftDown(from index: Int) {
		let parent = elements[index]
		var parentIndex = index
		
		while true {
			let leftChildIndex = self.leftChildIndex(ofParentAt: parentIndex)
			let rightChildIndex = leftChildIndex + 1
			
			var candidateIndex = parentIndex
			
			if leftChildIndex < count && priorityFunction(elements[leftChildIndex], elements[candidateIndex]) {
				candidateIndex = leftChildIndex
			}
			
			if rightChildIndex < count && priorityFunction(elements[rightChildIndex], elements[candidateIndex]) {
				candidateIndex = rightChildIndex
			}
			
			if candidateIndex == parentIndex {
				elements[parentIndex] = parent
				return
			}
			
			elements[parentIndex] = elements[candidateIndex]
			parentIndex = candidateIndex
		}
	}
	
	private func parentIndex(ofChildAt index: Int) -> Int {
		return (index - 1) / 2
	}
	
	private func leftChildIndex(ofParentAt index: Int) -> Int {
		return 2 * index + 1
	}
	
	private func rightChildIndex(ofParentAt index: Int) -> Int {
		return 2 * index + 2
	}
}


let res = leastInterval(["A","A","A","B","B","B"], 2)
print("min time is", res)
