//
//  AVPlaybackRouteSelecting+Rx.swift
//  RxAVKit
//
//  Created by Pawel Rup on 10/06/2019.
//

import Foundation
import AVKit
import RxSwift
import RxCocoa

#if os(iOS)

extension Reactive where Base: AVAudioSession {

	@available(iOS 13.0, *)
	public func prepareRouteSelectionForPlayback() -> Single<(Bool, AVAudioSession.RouteSelection)> {
		Single.create { event in
			base.prepareRouteSelectionForPlayback { shouldStartPlayback, routeSelection in
				event(.success((shouldStartPlayback, routeSelection)))
			}
			return Disposables.create()
		}
	}
}

#endif
