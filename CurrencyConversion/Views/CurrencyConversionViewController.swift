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

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        Observable.just(["One", "Two", "Tree"])
            .bind(to: currencyPickerView.rx.items(adapter: currencyPickerAdapter))
            .disposed(by: disposeBag)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
