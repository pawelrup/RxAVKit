//
//  AVPlayerItem.swift
//  RxAVKit
//
//  Created by Pawel Rup on 10/06/2019.
//

import Foundation
import AVKit
import RxSwift
import RxCocoa

extension Reactive where Base: AVPlayerItem {

	/// Sets the current playback time to the specified time and executes the specified block when the seek operation completes or is interrupted.
	/// - Parameter time: The time to which to seek.
	@available(iOS 5.0, tvOS 9.0, *)
	public func seek(to time: CMTime) -> Single<Bool> {
		return Single.create { event -> Disposable in
			self.base.seek(to: time) { finished in
				event(.success(finished))
			}
			return Disposables.create()
		}
	}

	/// Sets the current playback time within a specified time bound and invokes the specified block when the seek operation completes or is interrupted.
	/// - Parameter time: The time to which to seek.
	/// - Parameter toleranceBefore: The temporal tolerance before time.
	///		Pass zero to request sample accurate seeking (this may incur additional decoding delay).
	/// - Parameter toleranceAfter: The temporal tolerance after time.
	///		Pass zero to request sample accurate seeking (this may incur additional decoding delay).
	@available(iOS 5.0, tvOS 9.0, *)
	public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime) -> Single<Bool> {
		return Single.create { event -> Disposable in
			self.base.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter) { finished in
				event(.success(finished))
			}
			return Disposables.create()
		}
	}

	/// Sets the current playback time to the time specified by the date object.
	/// - Parameter date: The time to which to seek.
	@available(iOS 6.0, tvOS 9.0, *)
	public func seek(to date: Date) -> Single<Bool> {
		return Single.create { event -> Disposable in
			self.base.seek(to: date) { finished in
				event(.success(finished))
			}
			return Disposables.create()
		}
	}
}
