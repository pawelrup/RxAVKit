//
//  AVPictureInPictureController+Rx.swift
//  RxAVKit
//
//  Created by Pawel Rup on 11/06/2019.
//

import Foundation
import AVKit
import RxSwift
import RxCocoa

#if os(iOS)

@available(iOS 9.0, *)
extension AVPictureInPictureController: HasDelegate {
	public typealias Delegate = AVPictureInPictureControllerDelegate
}

@available(iOS 9.0, *)
private class RxAVPictureInPictureControllerDelegateProxy: DelegateProxy<AVPictureInPictureController, AVPictureInPictureControllerDelegate>, DelegateProxyType, AVPictureInPictureControllerDelegate {

	public weak private (set) var view: AVPictureInPictureController?

	public init(view: ParentObject) {
		self.view = view
		super.init(parentObject: view, delegateProxy: RxAVPictureInPictureControllerDelegateProxy.self)
	}

	static func registerKnownImplementations() {
		register { RxAVPictureInPictureControllerDelegateProxy(view: $0) }
	}
}

extension Reactive where Base: AVPictureInPictureController {

	public var delegate: DelegateProxy<AVPictureInPictureController, AVPictureInPictureControllerDelegate> {
		return RxAVPictureInPictureControllerDelegateProxy.proxy(for: base)
	}

	/// Tells the delegate when Picture in Picture is about to start.
	@available(iOS 9.0, *)
	public var willStartPictureInPicture: Observable<Void> {
		return delegate.methodInvoked(#selector(AVPictureInPictureControllerDelegate.pictureInPictureControllerWillStartPictureInPicture(_:)))
			.map { _ in () }
	}

	/// Tells the delegate when Picture in Picture playback has started.
	@available(iOS 9.0, *)
	public var didStartPictureInPicture: Observable<Void> {
		return delegate.methodInvoked(#selector(AVPictureInPictureControllerDelegate.pictureInPictureControllerDidStartPictureInPicture(_:)))
			.map { _ in () }
	}

	/// Tells the delegate if Picture in Picture failed to start.
	@available(iOS 9.0, *)
	public var failedToStartPictureInPictureWithError: Observable<AVError> {
		return delegate.methodInvoked(#selector(AVPictureInPictureControllerDelegate.pictureInPictureController(_:failedToStartPictureInPictureWithError:)))
			.map { $0[1] as! AVError }
	}

	/// Tells the delegate when Picture in Picture is about to stop.
	@available(iOS 9.0, *)
	public var willStopPictureInPicture: Observable<Void> {
		return delegate.methodInvoked(#selector(AVPictureInPictureControllerDelegate.pictureInPictureControllerWillStopPictureInPicture(_:)))
			.map { _ in () }
	}

	/// Tells the delegate when Picture in Picture playback stops.
	@available(iOS 9.0, *)
	public var didStopPictureInPicture: Observable<Void> {
		return delegate.methodInvoked(#selector(AVPictureInPictureControllerDelegate.pictureInPictureControllerDidStopPictureInPicture(_:)))
			.map { _ in () }
	}
}

#endif
