//
//  AVCaptureView+Rx.swift
//  RxAVKit
//
//  Created by Pawel Rup on 18/07/2020.
//

import Foundation
import AVKit
import RxSwift
import RxCocoa

#if os(macOS)

extension AVCaptureView: HasDelegate {
	public typealias RestoreUserInterfaceCompletionHandler = @convention(block) (Bool) -> Void
}

private class RxAVCaptureViewDelegateProxy: DelegateProxy<AVCaptureView, AVCaptureViewDelegate>, DelegateProxyType, AVCaptureViewDelegate {
	
	public weak private (set) var view: AVCaptureView?
	
	private var startRecordingToFileOutputSubject = PublishSubject<AVCaptureFileOutput>()
	
	var startRecordingToFileOutput: Observable<AVCaptureFileOutput>
	
	public init(view: ParentObject) {
		self.view = view
		startRecordingToFileOutput = startRecordingToFileOutputSubject.asObservable()
		super.init(parentObject: view, delegateProxy: RxAVCaptureViewDelegateProxy.self)
	}
	
	static func registerKnownImplementations() {
		register { RxAVCaptureViewDelegateProxy(view: $0) }
	}
	
	func captureView(_ captureView: AVCaptureView, startRecordingTo fileOutput: AVCaptureFileOutput) {
		startRecordingToFileOutputSubject.onNext(fileOutput)
	}
}

extension Reactive where Base: AVCaptureView {
	
	public var delegate: DelegateProxy<AVCaptureView, AVCaptureViewDelegate> {
		RxAVCaptureViewDelegateProxy.proxy(for: base)
	}
	
	/// Called when a call is changed.
	var startRecordingToFileOutput: Observable<AVCaptureFileOutput> {
		(delegate as! RxAVCaptureViewDelegateProxy).startRecordingToFileOutput
	}
}
#endif
