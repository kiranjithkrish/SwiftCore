//1. Build Prefix Tree
/*
 A trie (pronounced as "try") or prefix tree is a tree data structure used to efficiently store and retrieve keys in a dataset of strings. There are various applications of this data structure, such as autocomplete and spellchecker.
 */

class TrieNode {
	
	var value: Character
	var children = [Character:TrieNode]()
	var endOfWord = false
	
	init(value: Character) {
		self.value = value
	}
}

class Trie {
	
	let root: TrieNode

	init() {
		self.root = TrieNode(value: "|")
	}
	
	func insert(_ word: String) {
		var current = self.root
		for c in word {
			
//			if current.children[c] == nil {
//				current.children[c] = TrieNode(value: c)
//			}
//			if let currentNode = current.children[c] {
//				current  = currentNode
//			}
			// This is short hand way to writing the above logic
			current = current.children[c, default: {
						   let newNode = TrieNode(value: c)
						   current.children[c] = newNode
						   return newNode
					   }()]
		}
		current.endOfWord = true
	}
	
	func search(_ word: String) -> Bool {
		var current = self.root
		for c in word {
			if let currentNode = current.children[c] {
				current = currentNode
			} else {
				return false
			}
		}
		return current.endOfWord
	}
	
	func startsWith(_ prefix: String) -> Bool {
		var current = self.root
		for c in prefix {
			if let currentNode = current.children[c] {
				current = currentNode
			} else {
				return false
			}
		}
		return true
	}
}


let trie = Trie()
trie.insert("apple")
trie.insert("ape")
trie.startsWith("apple")

//2. Design Word Search Data Structure
/*
 Design a data structure that supports adding new words and searching for existing words.
 
 Implement the WordDictionary class:

 void addWord(word) Adds word to the data structure.
 bool search(word) Returns true if there is any string in the data structure that matches word or false otherwise. word may contain dots '.' where dots can be matched with any letter.

 */


class WordDictionary {
	let root: TrieNode
	init() {
		self.root = TrieNode(value: "|")
	}
	
	func addWord(_ word: String) {
		var current = self.root
		for c in word {
			// This is short hand way to writing the above logic
						if current.children[c] == nil {
							current.children[c] = TrieNode(value: c)
						}
						if let currentNode = current.children[c] {
							current  = currentNode
						}
		}
		current.endOfWord = true
	}
	
	func search(_ word: String) -> Bool {
		
		func dfs(_ start: Int, root: TrieNode) -> Bool {
			var current = root
			var word = Array(word)
			for idx in start..<word.count {
				var c = word[idx]
				if c == "." {
					let childrenNodes = current.children.values
					for child in childrenNodes {
						if dfs(idx+1, root: child) { return true }
					}
					return false
				} else {
					if let currentNode = current.children[c] {
						current = currentNode
					} else {
						return false
					}
				}
				
			}
			return current.endOfWord
		}
		return dfs(0, root: TrieNode(value: "|"))
		
	}
}

let wordDicr = WordDictionary()
wordDicr.addWord("bad")
wordDicr.addWord("dad")
wordDicr.addWord("mad")
wordDicr.search("bad")

