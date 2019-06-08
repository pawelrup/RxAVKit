//
//  AVContentProposalViewController+Rx.swift
//  RxAVKit
//
//  Created by Pawel Rup on 11/06/2019.
//

import Foundation
import AVKit
import RxSwift
import RxCocoa

#if os(tvOS)
@available(tvOS 10.0, *)
extension Reactive where Base: AVContentProposalViewController {

	/// Dismisses the current content proposal.
	public func dismissContentProposal(for action: AVContentProposalAction, animated: Bool) -> Single<Void> {
		return Single.create { event -> Disposable in
			self.base.dismissContentProposal(for: action, animated: animated) {
				event(.success(()))
			}
			return Disposables.create()
		}
	}
}
#endif
