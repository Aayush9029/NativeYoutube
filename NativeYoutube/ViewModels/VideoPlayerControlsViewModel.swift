//
//  VideoPlayerControlsViewModel.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/3/22.
//

import Combine
import YouTubePlayerKit
import Foundation

class VideoPlayerControlsViewModel: ObservableObject {

    enum Input {
        case onAppear
        case playVideo
        case pauseVideo
        case muteVideo
        case unmuteVideo
        case nextVideo
        case prevVideo
        case playbackRate(PlaybackRate)
        case seeking(Bool)
        case changingVolume(Bool)
    }

    func apply(_ input: Input) {
        switch input {
        case .onAppear:
            onAppearSubject.send()
        case .playVideo:
            playVideoSubject.send()
        case .pauseVideo:
            pauseVideoSubject.send()
        case .muteVideo:
            muteVideoSubject.send()
        case .unmuteVideo:
            umuteVideoSubject.send()
        case .nextVideo:
            nextVideoSubject.send()
        case .prevVideo:
            prevVideoSubject.send()
        case .playbackRate(let rate):
            playbackRateSubject.send(rate)
        case .seeking(let seeking):
            currentlySeeking = seeking
        case .changingVolume(let changing):
            currentlyChangingVolume = changing
        }
    }

    // Input Subjects

    private let onAppearSubject = PassthroughSubject<Void, Never>()
    private let playVideoSubject = PassthroughSubject<Void, Never>()
    private let pauseVideoSubject = PassthroughSubject<Void, Never>()
    private let muteVideoSubject = PassthroughSubject<Void, Never>()
    private let umuteVideoSubject = PassthroughSubject<Void, Never>()
    private let nextVideoSubject = PassthroughSubject<Void, Never>()
    private let prevVideoSubject = PassthroughSubject<Void, Never>()
    private let playbackRateSubject = PassthroughSubject<PlaybackRate, Never>()

    private var cancellables = Set<AnyCancellable>()

    // Properties

    private let youtubePlayer: YouTubePlayer
    private var currentlySeeking = false
    private var currentlyChangingVolume = false

    @Published var playbackState: YouTubePlayer.PlaybackState = .unstarted
    @Published var playbackRate: PlaybackRate = .normal
    @Published var isMuted: Bool = false
    @Published var volume: Double = 100
    @Published var seekbar: Double = 0
    @Published var duration: TimeInterval = 0.001

    init(youtubePlayer: YouTubePlayer) {
        self.youtubePlayer = youtubePlayer
        bindInputs()
    }
}

// MARK: - View Model

extension VideoPlayerControlsViewModel {
    private func bindInputs() {

        let appearSubject = onAppearSubject
            .eraseToAnyPublisher()
            .share()

        // Bind and observe playback state changes

        appearSubject
            .flatMap({ [youtubePlayer] in
                youtubePlayer.playbackStatePublisher
            })
            .assign(to: \.playbackState, on: self)
            .store(in: &cancellables)

        // Bind and observe playback rate changes

        appearSubject
            .flatMap { [youtubePlayer] in
                youtubePlayer.playbackRatePublisher
            }
            .map({ $0 < 1.0 ? .slow : $0 == 1.0 ? .normal : .fast })
            .assign(to: \.playbackRate, on: self)
            .store(in: &cancellables)

        // Bind and observe mute states

        appearSubject
            .flatMap { [youtubePlayer] in
                youtubePlayer.isMutedPublisher()
            }
            .replaceError(with: false)
            .assign(to: \.isMuted, on: self)
            .store(in: &cancellables)

        // Bind and observe volume changes if user not changing it

        appearSubject
            .flatMap { [youtubePlayer] in
                youtubePlayer.volumePublisher()
            }
            .filter({ [unowned self] _ in !self.currentlyChangingVolume })
            .map { Double($0) }
            .assign(to: \.volume, on: self)
            .store(in: &cancellables)

        // Bind and observe duration changss

        appearSubject
            .flatMap { [youtubePlayer] in
                youtubePlayer.durationPublisher
            }
            .assign(to: \.duration, on: self)
            .store(in: &cancellables)

        // Bind and observe seek changes if not seeking

        appearSubject
            .flatMap { [youtubePlayer] in
                youtubePlayer.currentTimePublisher()
            }
            .filter({ [unowned self] _ in !self.currentlySeeking })
            .assign(to: \.seekbar, on: self)
            .store(in: &cancellables)

        // MARK: - User Input Changes

        // Bind and observe any user seek changes and handle the input

        appearSubject
            .combineLatest($seekbar)
            .map { $1 }
            .filter({ [unowned self] _ in self.currentlySeeking })
            .removeDuplicates()
            .sink(receiveValue: { [youtubePlayer] in youtubePlayer.seek(to: $0, allowSeekAhead: true) })
            .store(in: &cancellables)

        // Bind and observe any user volume changes and handle the input

        appearSubject
            .flatMap { [unowned self] in  self.$volume }
            .filter({ [unowned self] _ in self.currentlyChangingVolume })
            .map { Int($0) }
            .removeDuplicates()
            .sink(receiveValue: { [youtubePlayer] in youtubePlayer.set(volume: $0) })
            .store(in: &cancellables)

        prevVideoSubject
            .eraseToAnyPublisher()
            .sink(receiveValue: youtubePlayer.previousVideo)
            .store(in: &cancellables)

        playVideoSubject
            .eraseToAnyPublisher()
            .sink(receiveValue: youtubePlayer.play)
            .store(in: &cancellables)

        pauseVideoSubject
            .eraseToAnyPublisher()
            .sink(receiveValue: youtubePlayer.pause)
            .store(in: &cancellables)

        muteVideoSubject
            .eraseToAnyPublisher()
            .sink(receiveValue: youtubePlayer.mute)
            .store(in: &cancellables)

        umuteVideoSubject
            .eraseToAnyPublisher()
            .sink(receiveValue: youtubePlayer.unmute)
            .store(in: &cancellables)

        nextVideoSubject
            .eraseToAnyPublisher()
            .sink(receiveValue: youtubePlayer.nextVideo)
            .store(in: &cancellables)

        playbackRateSubject
            .eraseToAnyPublisher()
            .removeDuplicates()
            .map({ ($0 == .slow) ? 0.5 : ($0 == .normal) ? 1.0 : 2.0  })
            .sink(receiveValue: youtubePlayer.set(playbackRate: ))
            .store(in: &cancellables)
    }
}

extension VideoPlayerControlsViewModel {
    enum PlaybackRate: String {
        case normal = "speedometer"
        case fast = "hare"
        case slow = "tortoise"
    }
}

extension YouTubePlayer {
    // Allows to observe a value within a time frame.
    func isMutedPublisher(
        updateInterval: TimeInterval = 0.5
    ) -> AnyPublisher<Bool, Never> {
        Just(
            .init()
        )
        .append(
            Timer.publish(
                every: updateInterval,
                on: .main,
                in: .common
            )
            .autoconnect()
        )
        .flatMap { _ in
            Future { [weak self] promise in
                self?.isMuted { result in
                    guard case .success(let muted) = result else {
                        return
                    }
                    promise(.success(muted))
                }
            }
        }
        .removeDuplicates()
        .eraseToAnyPublisher()
    }

    func volumePublisher(
        updateInterval: TimeInterval = 0.5
    ) -> AnyPublisher<Int, Never> {
        Just(
            .init()
        )
        .append(
            Timer.publish(
                every: updateInterval,
                on: .main,
                in: .common
            )
            .autoconnect()
        )
        .flatMap { _ in
            Future { [weak self] promise in
                self?.getVolume(completion: { result in
                    guard case .success(let volume) = result else {
                        return
                    }
                    promise(.success(volume))
                })
            }
        }
        .removeDuplicates()
        .eraseToAnyPublisher()
    }
}
