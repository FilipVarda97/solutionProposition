import UIKit

typealias MatrixDictionaryType = [[Player: [Odd]]]

class MatrixTableViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MatrixRowCell.self, forCellReuseIdentifier: MatrixRowCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()

    let items = Bundle.main.decode(type: [Odd].self, from: "data.json")
    var bets = MatrixDictionaryType()
    var players: [Player] = [Player]()
    var odds: [Odd] = [Odd]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        sortData()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func sortData() {
        for item in items {
            if item.readOnly == true {
                let player = Bundle.main.transformToPlayer(odd: item)
                players.append(player)
            }
        }

        for item in items {
            if item.readOnly == false {
                odds.append(item)
            }
        }

        pairData()
    }

    private func pairData() {
        for player in players {
            var arrayOdOdds = [Odd]()
            for odd in odds {
                if odd.marketId == player.marketId {
                    arrayOdOdds.append(odd)
                }
            }
            bets.append([player : arrayOdOdds])
        }
        print("**This is first element after sorting: \(bets[0]) , **Total number of possible bets: \(bets.count)")
    }
}

extension MatrixTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MatrixRowCell.identifier) as? MatrixRowCell else {
            return UITableViewCell()
        }
        let element = bets[indexPath.row]
        
        if indexPath.row == 0 && indexPath.section == 0 {
            cell.isFirst = true
        }
        if indexPath.section == bets.count - 1 {
            cell.isLast = true
        }
        cell.element = element
        cell.delegate = self
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return bets.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bets[section].count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension MatrixTableViewController: MatrixCellDelegate {
    func press(odd: Odd) {
        print("Pressed odd: \(odd)")
    }
    
    func longPress(odd: Odd) {
        print("Long pressed odd: \(odd)")
    }
}

