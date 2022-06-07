import Foundation

struct Odd: Codable {
    let oddsId: String
    let nameOdds: String
    let value: Float?
    let previousValue: Float?
    let order: Int
    let displayRow: Int
    let displayOrder: Int
    let displayCount: Int
    let marketId: String
    let info: Int?
    let readOnly: Bool
}

struct Player: Codable, Hashable {
    let oddsId: String
    let nameOdds: String
    let order: Int
    let displayRow: Int
    let displayOrder: Int
    let displayCount: Int
    let marketId: String
    let readOnly: Bool
}

extension Bundle {
    func decode<T: Codable>(type: T.Type, from file: String) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("No file named: \(file) in Bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load")
        }
        
        let decoder = JSONDecoder()
        
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundel, missing file '\(key.stringValue)' - \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Type mismatch context \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(type) - context: \(context.debugDescription)")
        }  catch DecodingError.dataCorrupted(_) {
            fatalError("Wrong JSON")
        } catch {
            fatalError("Filed to decode \(file) from bundle")
        }
    }

    func transformToPlayer(odd: Odd) -> Player {
        let player = Player(oddsId: odd.oddsId,
                            nameOdds: odd.nameOdds,
                            order: odd.order,
                            displayRow: odd.displayRow,
                            displayOrder: odd.displayOrder,
                            displayCount: odd.displayCount,
                            marketId: odd.marketId,
                            readOnly: odd.readOnly)
        return player
    }
}
