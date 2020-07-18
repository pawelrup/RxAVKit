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

#if os(iOS) || os(tvOS) || os(macOS)

@available(tvOS 14.0, *)
extension AVPictureInPictureController: HasDelegate {
	public typealias RestoreUserInterfaceCompletionHandler = @convention(block) (Bool) -> Void
	public typealias Delegate = AVPictureInPictureControllerDelegate
}

@available(tvOS 14.0, *)
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

@available(tvOS 14.0, *)
extension Reactive where Base: AVPictureInPictureController {

	public var delegate: DelegateProxy<AVPictureInPictureController, AVPictureInPictureControllerDelegate> {
		RxAVPictureInPictureControllerDelegateProxy.proxy(for: base)
	}

	/// Tells the delegate when Picture in Picture is about to start.
	public var willStartPictureInPicture: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPictureInPictureControllerDelegate.pictureInPictureControllerWillStartPictureInPicture(_:)))
			.map { _ in () }
	}

	/// Tells the delegate when Picture in Picture playback has started.
	public var didStartPictureInPicture: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPictureInPictureControllerDelegate.pictureInPictureControllerDidStartPictureInPicture(_:)))
			.map { _ in () }
	}

	/// Tells the delegate if Picture in Picture failed to start.
	public var failedToStartPictureInPictureWithError: Observable<AVError> {
		delegate
			.methodInvoked(#selector(AVPictureInPictureControllerDelegate.pictureInPictureController(_:failedToStartPictureInPictureWithError:)))
			.compactMap { $0[1] as? AVError }
	}

	/// Tells the delegate when Picture in Picture is about to stop.
	public var willStopPictureInPicture: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPictureInPictureControllerDelegate.pictureInPictureControllerWillStopPictureInPicture(_:)))
			.map { _ in () }
	}

	/// Tells the delegate when Picture in Picture playback stops.
	public var didStopPictureInPicture: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPictureInPictureControllerDelegate.pictureInPictureControllerDidStopPictureInPicture(_:)))
			.map { _ in () }
	}
	
	/// Implement this method to restore the user interface before Picture in Picture stops.
	public var restoreUserInterfaceForPictureInPictureStopWithCompletion: Observable<AVPictureInPictureController.RestoreUserInterfaceCompletionHandler> {
		delegate
			.methodInvoked(#selector(AVPictureInPictureControllerDelegate.pictureInPictureController(_:restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:)))
			.map {
				let blockPointer = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained($0[1] as AnyObject).toOpaque())
				let handler = unsafeBitCast(blockPointer, to: AVPictureInPictureController.RestoreUserInterfaceCompletionHandler.self)
				return handler
			}
	}
}

#endif
