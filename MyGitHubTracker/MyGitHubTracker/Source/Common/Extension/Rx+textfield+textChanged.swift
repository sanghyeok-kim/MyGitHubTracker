//
//  Rx+textfield+textChanged.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/17.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    public var textChanged: ControlProperty<String?> {
        let events = base.rx.controlEvent(.editingChanged)
            .withLatestFrom(base.rx.text)

        return ControlProperty<String?>(
            values: events,
            valueSink: Binder(base) { textField, value in
                if textField.text != value {
                    textField.text = value
                }
            }
        )
    }
}
