import Foundation

struct FuzzyResult {
    var match: Bool = false
    var score: Int = 0
    var matchIndices: [Int] = []
}

class ScoredItem {
    var text: String
    var score: Int
    var matchIndices: [Int]

    init(text: String, score: Int, matchIndices: [Int]) {
        self.text = text
        self.score = score
        self.matchIndices = matchIndices
    }
}

func fuzzyMatch(query: String, item: String) -> FuzzyResult {
    var result = FuzzyResult()
    let qChars = Array(query.lowercased())
    let iChars = Array(item.lowercased())
    let origChars = Array(item)
    let qLen = qChars.count
    let iLen = iChars.count
    if qLen == 0 { return FuzzyResult(match: true, score: 0, matchIndices: []) }
    if qLen > iLen { return result }

    var qi = 0
    var score = 0
    var prevMatched = false
    var indices: [Int] = []

    for ii in 0..<iLen {
        guard qi < qLen else { break }
        if qChars[qi] == iChars[ii] {
            indices.append(ii)
            score += 1
            if prevMatched { score += 3 }
            if ii == 0 { score += 5 }
            if ii > 0 {
                let prev = origChars[ii - 1]
                if prev == " " || prev == "-" || prev == "_" {
                    score += 4
                } else if origChars[ii].isUppercase && prev.isLowercase {
                    score += 3
                }
            }
            prevMatched = true
            qi += 1
        } else {
            prevMatched = false
        }
    }

    if qi == qLen {
        result.match = true
        result.score = score * 100 - iLen
        result.matchIndices = indices
    }
    return result
}
