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

#if os(iOS) || os(tvOS)

extension AVPlayerViewController: HasDelegate {
	public typealias Delegate = AVPlayerViewControllerDelegate
	public typealias RestoreUserInterfaceCompletionHandler = @convention(block) (Bool) -> Void
	public typealias SkipToNextChannelCompletionHandler = @convention(block) (Bool) -> Void
	public typealias SkipToPreviousChannelCompletionHandler = @convention(block) (Bool) -> Void
}

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

extension Reactive where Base: AVPlayerViewController {

	public var delegate: DelegateProxy<AVPlayerViewController, AVPlayerViewControllerDelegate> {
		RxAVPlayerViewControllerDelegateProxy.proxy(for: base)
	}
	
	/// Tells the delegate Picture in Picture is about to start.
	public var willStartPictureInPicture: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewControllerWillStartPictureInPicture(_:)))
			.map { _ in () }
	}
	
	/// Tells the delegate Picture in Picture playback has started.
	public var didStartPictureInPicture: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewControllerDidStartPictureInPicture(_:)))
			.map { _ in () }
	}
	
	/// Tells the delegate Picture in Picture failed to start.
	public var failedToStartPictureInPictureWithError: Observable<AVError> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:failedToStartPictureInPictureWithError:)))
			.compactMap { $0[1] as? AVError }
	}
	
	/// Tells the delegate Picture in Picture is about to stop.
	public var willStopPictureInPicture: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewControllerWillStopPictureInPicture(_:)))
			.map { _ in () }
	}

	/// Tells the delegate Picture in Picture playback has stopped and the stopping animation has finished.
	public var didStopPictureInPicture: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewControllerDidStopPictureInPicture(_:)))
			.map { _ in () }
	}
	
	/// Implement this method to restore the user interface before Picture in Picture stops.
	public var restoreUserInterfaceForPictureInPictureStopWithCompletion: Observable<AVPlayerViewController.RestoreUserInterfaceCompletionHandler> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:)))
			.map {
				let blockPointer = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained($0[1] as AnyObject).toOpaque())
				let handler = unsafeBitCast(blockPointer, to: AVPlayerViewController.RestoreUserInterfaceCompletionHandler.self)
				return handler
			}
	}

	#if os(iOS)

	/// Informs the delegate that AVPlayerViewController is about to start displaying its contents full screen.
	@available(iOS 12.0, *)
	public var willBeginFullScreenPresentationWithAnimationCoordinator: Observable<UIViewControllerTransitionCoordinator> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:willBeginFullScreenPresentationWithAnimationCoordinator:)))
			.compactMap { $0[1] as? UIViewControllerTransitionCoordinator }
	}

	/// Informs the delegate that AVPlayerViewController is about to stop displaying its contents full screen.
	@available(iOS 12.0, *)
	public var willEndFullScreenPresentationWithAnimationCoordinator: Observable<UIViewControllerTransitionCoordinator> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:willEndFullScreenPresentationWithAnimationCoordinator:)))
			.compactMap { $0[1] as? UIViewControllerTransitionCoordinator }
	}
	
	#elseif os(tvOS)

	public var willBeginDismissalTransition: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewControllerWillBeginDismissalTransition(_:)))
			.map { _ in () }
	}

	public var didEndDismissalTransition: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewControllerDidEndDismissalTransition(_:)))
			.map { _ in () }
	}

	public var willPresent: Observable<AVInterstitialTimeRange> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:willPresent:)))
			.compactMap { $0[1] as? AVInterstitialTimeRange }
	}

	public var didPresent: Observable<AVInterstitialTimeRange> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:didPresent:)))
			.compactMap { $0[1] as? AVInterstitialTimeRange }
	}

	public var willResumePlaybackAfterUserNavigated: Observable<(oldTime: CMTime, targetTime: CMTime)> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:willResumePlaybackAfterUserNavigatedFrom:to:)))
			.map { ($0[1] as! CMTime, $0[2] as! CMTime) }
	}

	public var timeToSeekAfterUserNavigated: Observable<(oldTime: CMTime, targetTime: CMTime)> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:timeToSeekAfterUserNavigatedFrom:to:)))
			.map { ($0[1] as! CMTime, $0[2] as! CMTime) }
	}

	public var didSelect: Observable<(mediaSelectionOption: AVMediaSelectionOption?, mediaSelectionGroup: AVMediaSelectionGroup)> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:didSelect:in:)))
			.map { ($0[1] as? AVMediaSelectionOption, $0[2] as! AVMediaSelectionGroup) }
	}

	public var skipToNextItem: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.skipToNextItem(for:)))
			.map { _ in () }
	}

	public var skipToPreviousItem: Observable<Void> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.skipToPreviousItem(for:)))
			.map { _ in () }
	}
	
	@available(tvOS 13.0, *)
	public var skipToNextChannel: Observable<AVPlayerViewController.SkipToNextChannelCompletionHandler> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:skipToNextChannel:)))
			.map {
				let blockPointer = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained($0[1] as AnyObject).toOpaque())
				let handler = unsafeBitCast(blockPointer, to: AVPlayerViewController.SkipToNextChannelCompletionHandler.self)
				return handler
			}
	}
		
	@available(tvOS 13.0, *)
	public var skipToPreviousChannel: Observable<AVPlayerViewController.SkipToPreviousChannelCompletionHandler> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:skipToPreviousChannel:)))
			.map {
				let blockPointer = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained($0[1] as AnyObject).toOpaque())
				let handler = unsafeBitCast(blockPointer, to: AVPlayerViewController.SkipToPreviousChannelCompletionHandler.self)
				return handler
			}
	}

	public var didAccept: Observable<AVContentProposal> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:didAccept:)))
			.compactMap { $0[1] as? AVContentProposal }
	}

	public var didReject: Observable<AVContentProposal> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:didReject:)))
			.compactMap { $0[1] as? AVContentProposal }
	}

	public var willTransitionToVisibilityOfTransportBar: Observable<(visible: Bool, coordinator: AVPlayerViewControllerAnimationCoordinator)> {
		delegate
			.methodInvoked(#selector(AVPlayerViewControllerDelegate.playerViewController(_:willTransitionToVisibilityOfTransportBar:with:)))
			.map { ($0[1] as! Bool, $0[2] as! AVPlayerViewControllerAnimationCoordinator) }
	}

	#endif
}

#endif
