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

    private var viewModel: CurrencyConversionViewModel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CurrencyConversionViewModel(
            store: CurrencyConversionStore(
                repository: DebugRepository()
            )
        )
        viewModel.onViewDidLoad.accept(())

        setInputs()
        handleOutputs()
    }

    private func setInputs() {
        amountTextField.rx.text
            .bind(to: viewModel.onAmountTextChanged)
            .disposed(by: disposeBag)

        Observable.combineLatest(
            currencyPickerView.rx.itemSelected.map { $0.0 },
            viewModel.currencies.asObservable()
        ) { selectedRow, currencies -> Currency in
            return currencies[selectedRow]
        }
        .bind(to: viewModel.onCurrencySelected)
        .disposed(by: disposeBag)
    }

    private func handleOutputs() {
        viewModel.currencies
            .map { $0.map { $0.code } }
            .drive(currencyPickerView.rx.items(adapter: currencyPickerAdapter))
            .disposed(by: disposeBag)

        viewModel.convertedList
            .map { moneys -> [SectionModel<String, Money>] in
                return [SectionModel<String, Money>(model: "", items: moneys)]
            }
            .drive(convertedListTableView.rx.items(dataSource: convertedListDataSource))
            .disposed(by: disposeBag)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

class DebugRepository: CurrencyRepositoryProtocol {
    func getSupportedCurrencies() -> Single<[Currency]> {
        return Single.just([
            Currency(code: "USD", name: ""),
            Currency(code: "AAA", name: ""),
            Currency(code: "BBB", name: ""),
            Currency(code: "CCC", name: ""),
            Currency(code: "DDD", name: ""),
            Currency(code: "EEE", name: ""),
            Currency(code: "FFF", name: ""),
            Currency(code: "GGG", name: ""),
            Currency(code: "HHH", name: ""),
            Currency(code: "III", name: ""),
            Currency(code: "JJJ", name: ""),
            Currency(code: "KKK", name: ""),
            Currency(code: "LLL", name: ""),
        ])
    }
    
    func getConversionRates() -> Single<[ConversionRate]> {
        return Single.just([
            ConversionRate(before: "USD", after: "USD", rate: 1),
            ConversionRate(before: "USD", after: "AAA", rate: 1000),
            ConversionRate(before: "USD", after: "BBB", rate: 200),
            ConversionRate(before: "USD", after: "CCC", rate: 50),
            ConversionRate(before: "USD", after: "DDD", rate: 1000),
            ConversionRate(before: "USD", after: "EEE", rate: 200),
            ConversionRate(before: "USD", after: "FFF", rate: 50),
            ConversionRate(before: "USD", after: "GGG", rate: 1000),
            ConversionRate(before: "USD", after: "HHH", rate: 200),
            ConversionRate(before: "USD", after: "III", rate: 50),
            ConversionRate(before: "USD", after: "JJJ", rate: 1000),
            ConversionRate(before: "USD", after: "KKK", rate: 200),
            ConversionRate(before: "USD", after: "LLL", rate: 50),
        ])
    }
}
