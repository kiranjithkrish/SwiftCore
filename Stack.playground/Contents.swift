import UIKit

//1. Valid Parentheses
func isValid(_ s: String) -> Bool {
	guard s.count % 2 == 0 else {
		return false
	}
	var stack = [Character]()
	for ch in s {
		switch s {
		case "(": stack.append(")")
		case "{": stack.append("}")
		case "[": stack.append("]")
		default :
			if stack.isEmpty || stack.removeLast() != ch {
				return false
			}
 		}
	}
	return stack.isEmpty
}

func isValid2(_ s: String) -> Bool {
	
	   let bracketMap: [Character: Character] = [")": "(", "}": "{", "]": "["]
	   
	   var stack: [Character] = []
	   
	   for char in s {
		   if bracketMap.values.contains(char) {
			   stack.append(char)
			   print("Stack : Append",stack)
		   }
		   else if let openBracket = bracketMap[char] {
			   if stack.isEmpty || stack.last != openBracket {
				   return false
			   }
			   stack.removeLast()
			   print("Stack : Remove", stack)
		   }
	   }
	   
	   return stack.isEmpty
}

isValid2("([{}])[]{}")
