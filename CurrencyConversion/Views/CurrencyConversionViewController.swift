//
//  CurrencyConversionViewController.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CurrencyConversionViewController: UIViewController {
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    private let currencyPickerAdapter = RxPickerViewStringAdapter<[String]>(
        components: [],
        numberOfComponents: { _, _, _  in 1 },
        numberOfRowsInComponent: { _, _, items, _ -> Int in
            return items.count
        },
        titleForRow: { _, _, items, row, _ -> String? in
            return items[row]
        })
    @IBOutlet weak var convertedListTableView: UITableView!
    private lazy var convertedListDataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, Money>> =
        RxTableViewSectionedReloadDataSource<SectionModel<String, Money>>(configureCell: { dataSource, tableView, indexPath, money -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConvertedTableViewCell") as? ConvertedTableViewCell else { return UITableViewCell() }
            cell.currencyCodeLabel.text = money.currency.code
            cell.amountLabel.text = String(money.amount)
            return cell
        })

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        Observable.just(["One", "Two", "Tree"])
            .bind(to: currencyPickerView.rx.items(adapter: currencyPickerAdapter))
            .disposed(by: disposeBag)

        Observable.just([
            Money(amount: 1, currency: Currency(code: "USD", name: "USD")),
            Money(amount: 103, currency: Currency(code: "JPY", name: "USD")),
            Money(amount: 100, currency: Currency(code: "USD", name: "USD")),
            Money(amount: 100, currency: Currency(code: "USD", name: "USD")),
        ])
        .map { moneys -> [SectionModel<String, Money>] in
            return [SectionModel<String, Money>(model: "", items: moneys)]
        }
        .bind(to: convertedListTableView.rx.items(dataSource: convertedListDataSource))
        .disposed(by: disposeBag)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
