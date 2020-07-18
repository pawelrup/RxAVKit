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

extension Reactive where Base: AVContentProposalViewController {

	/// Dismisses the current content proposal.
	public func dismissContentProposal(for action: AVContentProposalAction, animated: Bool) -> Single<Void> {
		Single.create { event in
			base.dismissContentProposal(for: action, animated: animated) {
				event(.success(()))
			}
			return Disposables.create()
		}
	}
}

#endif
