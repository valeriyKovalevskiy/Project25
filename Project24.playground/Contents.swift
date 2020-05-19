import UIKit

let name = "Taylor"

for letter in name {
    print("give me a letter: \(letter)!")
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]


extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[3]

//

let password = "123456"
password.hasPrefix("123")
password.hasSuffix("456")

let weather = "it's going to rain"
print(weather.capitalized)

let input = "Swift is like objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")
languages.contains(where: input.contains)

let string = "this is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

let newAttributedString = NSMutableAttributedString(string: string)
newAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
newAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
newAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
newAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
newAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))


//newAttributedString.addAttributes([.font : UIFont.systemFont(ofSize: 8)], range: NSRange(location: 0, length: 4))


extension String {
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        
        return String(self.dropLast(suffix.count))
    }
    
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        
        return firstLetter.uppercased() + self.dropFirst()
    }
}

password.deletingPrefix(password[0])

