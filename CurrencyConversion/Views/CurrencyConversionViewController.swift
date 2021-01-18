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
            cell.currencyCodeLabel.text = money.currencyCode
            cell.amountLabel.text = String(money.amount)
            return cell
        })

    private var viewModel: CurrencyConversionViewModel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CurrencyConversionViewModel(
            store: CurrencyConversionStore(
                repository: CurrencyRepository(
                    api: CurrencyAPI(),
                    db: CurrencyDB()
                )
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
            viewModel.currenciyCodes.asObservable()
        ) { selectedRow, codes -> CurrencyCode in
            return codes[selectedRow]
        }
        .bind(to: viewModel.onCurrencyCodeSelected)
        .disposed(by: disposeBag)
    }

    private func handleOutputs() {
        viewModel.currenciyCodes
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
