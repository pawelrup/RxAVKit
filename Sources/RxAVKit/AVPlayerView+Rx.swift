//
//  AVPlayerViewr+Rx.swift
//  RxAVKit
//  
//
//  Created by Pawel Rup on 18/07/2020.
//

import Foundation
import AVKit
import RxSwift
import RxCocoa

#if os(macOS)

extension AVPlayerView: HasDelegate {
	public typealias RestoreUserInterfaceCompletionHandler = @convention(block) (Bool) -> Void
	public var delegate: AVPlayerViewPictureInPictureDelegate? {
		get {
			pictureInPictureDelegate
		}
		set(newValue) {
			pictureInPictureDelegate = newValue
		}
	}
}

private class RxAVPlayerViewPictureInPictureDelegateProxy: DelegateProxy<AVPlayerView, AVPlayerViewPictureInPictureDelegate>, DelegateProxyType, AVPlayerViewPictureInPictureDelegate {

	public weak private (set) var view: AVPlayerView?

	public init(view: ParentObject) {
		self.view = view
		super.init(parentObject: view, delegateProxy: RxAVPlayerViewPictureInPictureDelegateProxy.self)
	}

	static func registerKnownImplementations() {
		register { RxAVPlayerViewPictureInPictureDelegateProxy(view: $0) }
	}
}

extension Reactive where Base: AVPlayerView {
	
	public var delegate: DelegateProxy<AVPlayerView, AVPlayerViewPictureInPictureDelegate> {
		RxAVPlayerViewPictureInPictureDelegateProxy.proxy(for: base)
	}

	/// Dismisses the current content proposal.
	public func beginTrimming() -> Single<AVPlayerViewTrimResult> {
		Single.create { event in
			base.beginTrimming { result in
				event(.success(result))
			}
			return Disposables.create()
		}
	}
	
	/// Tells the delegate when Picture in Picture is about to start.
	public var willStartPictureInPicture: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPlayerViewPictureInPictureDelegate.playerViewWillStartPicture(inPicture:)))
			.map { _ in () }
	}

	/// Tells the delegate when Picture in Picture playback has started.
	public var didStartPictureInPicture: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPlayerViewPictureInPictureDelegate.playerViewDidStartPicture(inPicture:)))
			.map { _ in () }
	}

	/// Tells the delegate if Picture in Picture failed to start.
	public var failedToStartPictureInPictureWithError: Observable<AVError> {
		delegate
			.methodInvoked(#selector(AVPlayerViewPictureInPictureDelegate.playerView(_:failedToStartPictureInPictureWithError:)))
			.compactMap { $0[1] as? AVError }
	}

	/// Tells the delegate when Picture in Picture is about to stop.
	public var willStopPictureInPicture: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPlayerViewPictureInPictureDelegate.playerViewWillStopPicture(inPicture:)))
			.map { _ in () }
	}

	/// Tells the delegate when Picture in Picture playback stops.
	public var didStopPictureInPicture: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPlayerViewPictureInPictureDelegate.playerViewDidStopPicture(inPicture:)))
			.map { _ in () }
	}
	
	/// Implement this method to restore the user interface before Picture in Picture stops.
	public var restoreUserInterfaceForPictureInPictureStopWithCompletion: Observable<AVPlayerView.RestoreUserInterfaceCompletionHandler> {
		delegate
			.methodInvoked(#selector(AVPlayerViewPictureInPictureDelegate.playerView(_:restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:)))
			.map {
				let blockPointer = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained($0[1] as AnyObject).toOpaque())
				let handler = unsafeBitCast(blockPointer, to: AVPlayerView.RestoreUserInterfaceCompletionHandler.self)
				return handler
			}
	}
}
#endif
