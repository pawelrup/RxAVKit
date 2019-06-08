//
//  AVPlayerViewController+Rx.swift
//  RxAVKit
//
//  Created by Pawel Rup on 10/06/2019.
//

import Foundation
import AVKit
import RxSwift
import RxCocoa

@available(iOS 8.0, tvOS 9.0, *)
extension AVPlayerViewController: HasDelegate {
	public typealias Delegate = AVPlayerViewControllerDelegate
}

@available(iOS 8.0, tvOS 9.0, *)
private class RxAVPlayerViewControllerDelegateProxy: DelegateProxy<AVPlayerViewController, AVPlayerViewControllerDelegate>, DelegateProxyType, AVPlayerViewControllerDelegate {

	public weak private (set) var view: AVPlayerViewController?

	public init(view: ParentObject) {
		self.view = view
		super.init(parentObject: view, delegateProxy: RxAVPlayerViewControllerDelegateProxy.self)
	}

	static func registerKnownImplementations() {
		register { RxAVPlayerViewControllerDelegateProxy(view: $0) }
	}
}

@available(iOS 8.0, tvOS 9.0, *)
extension Reactive where Base: AVPlayerViewController {

	public var delegate: DelegateProxy<AVPlayerViewController, AVPlayerViewControllerDelegate> {
		return RxAVPlayerViewControllerDelegateProxy.proxy(for: base)
	}

	#if os(iOS)

	/// Informs the delegate that AVPlayerViewController is about to start displaying its contents full screen.
	@available(iOS 12.0, *)
	public var willBeginFullScreenPresentationWithAnimationCoordinator: Observable<UIViewControllerTransitionCoordinator> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:willBeginFullScreenPresentationWithAnimationCoordinator:)))
			.map { $0[1] as! UIViewControllerTransitionCoordinator }
	}

	/// Informs the delegate that AVPlayerViewController is about to stop displaying its contents full screen.
	@available(iOS 12.0, *)
	public var willEndFullScreenPresentationWithAnimationCoordinator: Observable<UIViewControllerTransitionCoordinator> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:willEndFullScreenPresentationWithAnimationCoordinator:)))
			.map { $0[1] as! UIViewControllerTransitionCoordinator }
	}

	/// Tells the delegate Picture in Picture is about to start.
	public var willStartPictureInPicture: Observable<Void> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewControllerWillStartPictureInPicture(_:)))
			.map { _ in () }
	}

	/// Tells the delegate Picture in Picture playback has started.
	public var didStartPictureInPicture: Observable<Void> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewControllerDidStartPictureInPicture(_:)))
			.map { _ in () }
	}

	/// Tells the delegate Picture in Picture failed to start.
	public var failedToStartPictureInPictureWithError: Observable<AVError> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:failedToStartPictureInPictureWithError:)))
			.map { $0[1] as! AVError }
	}

	/// Tells the delegate Picture in Picture is about to stop.
	public var willStopPictureInPicture: Observable<Void> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewControllerWillStopPictureInPicture(_:)))
			.map { _ in () }
	}

	/// Tells the delegate Picture in Picture playback has stopped and the stopping animation has finished.
	public var didStopPictureInPicture: Observable<Void> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewControllerDidStopPictureInPicture(_:)))
			.map { _ in () }
	}
	
	#elseif os(tvOS)

	@available(tvOS 11.0, *)
	public var willBeginDismissalTransition: Observable<Void> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewControllerWillBeginDismissalTransition(_:)))
			.map { _ in () }
	}

	@available(tvOS 11.0, *)
	public var didEndDismissalTransition: Observable<Void> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewControllerDidEndDismissalTransition(_:)))
			.map { _ in () }
	}

	@available(tvOS 9.0, *)
	public var willPresent: Observable<AVInterstitialTimeRange> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:willPresent:)))
			.map { $0[1] as! AVInterstitialTimeRange }
	}

	@available(tvOS 9.0, *)
	public var didPresent: Observable<AVInterstitialTimeRange> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:didPresent:)))
			.map { $0[1] as! AVInterstitialTimeRange }
	}

	@available(tvOS 9.0, *)
	public var willResumePlaybackAfterUserNavigated: Observable<(oldTime: CMTime, targetTime: CMTime)> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:willResumePlaybackAfterUserNavigatedFrom:to:)))
			.map { ($0[1] as! CMTime, $0[2] as! CMTime) }
	}

	@available(tvOS 10.0, *)
	public var timeToSeekAfterUserNavigated: Observable<(oldTime: CMTime, targetTime: CMTime)> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:timeToSeekAfterUserNavigatedFrom:to:)))
			.map { ($0[1] as! CMTime, $0[2] as! CMTime) }
	}

	@available(tvOS 9.0, *)
	public var didSelect: Observable<(mediaSelectionOption: AVMediaSelectionOption?, mediaSelectionGroup: AVMediaSelectionGroup)> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:didSelect:in:)))
			.map { ($0[1] as? AVMediaSelectionOption, $0[2] as! AVMediaSelectionGroup) }
	}

	@available(tvOS 10.0, *)
	public var skipToNextItem: Observable<Void> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.skipToNextItem(for:)))
			.map { _ in () }
	}

	@available(tvOS 10.0, *)
	public var skipToPreviousItem: Observable<Void> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.skipToPreviousItem(for:)))
			.map { _ in () }
	}

	@available(tvOS 10.0, *)
	public var didAccept: Observable<AVContentProposal> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:didAccept:)))
			.map { $0[1] as! AVContentProposal }
	}

	@available(tvOS 10.0, *)
	public var didReject: Observable<AVContentProposal> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:didReject:)))
			.map { $0[1] as! AVContentProposal }
	}

	@available(tvOS 11.0, *)
	public var willTransitionToVisibilityOfTransportBar: Observable<(visible: Bool, coordinator: AVPlayerViewControllerAnimationCoordinator)> {
		return delegate.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:willTransitionToVisibilityOfTransportBar:with:)))
			.map { ($0[1] as! Bool, $0[2] as! AVPlayerViewControllerAnimationCoordinator) }
	}

	#endif
}
