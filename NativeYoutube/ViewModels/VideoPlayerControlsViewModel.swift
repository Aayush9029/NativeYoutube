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
            seekingSubject.send(seeking)
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
    private let seekingSubject = PassthroughSubject<Bool, Never>()

    private var cancellables = Set<AnyCancellable>()

    // Properties

    private let youtubePlayer: YouTubePlayer
    private var currentlySeeking = false

    @Published var playbackState: YouTubePlayer.PlaybackState = .unstarted
    @Published var playbackRate: PlaybackRate = .normal
    @Published var isMuted: Bool = false
    @Published var currentDuration: String = "00:00"
    @Published var seekbar: Double = 0.001
    @Published var endDuration: TimeInterval = 0.001

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

        // Bind and observe duration changss

        appearSubject
            .flatMap { [youtubePlayer] in
                youtubePlayer.durationPublisher
            }
            .assign(to: \.endDuration, on: self)
            .store(in: &cancellables)

        // Bind and observe seek changes if not seeking

        appearSubject
            .flatMap {[youtubePlayer] in
                youtubePlayer.currentTimePublisher()
            }
            .combineLatest($endDuration)
            .filter({ [unowned self] _ in !self.currentlySeeking })
            .map { $0 / $1 }
            .assign(to: \.seekbar, on: self)
            .store(in: &cancellables)

        // Bind and observe current time changes

        appearSubject
            .combineLatest($seekbar, $endDuration)
            .map {  String(timeInterval: $1 * $2) }
            .assign(to: \.currentDuration, on: self)
            .store(in: &cancellables)

        // Bind and observe any user seek changes and handle the input

        appearSubject
            .combineLatest($seekbar, $endDuration)
            .filter({ [unowned self] _ in self.currentlySeeking })
            .map { $1 * $2 }
            .sink(receiveValue: { [youtubePlayer] in youtubePlayer.seek(to: $0, allowSeekAhead: true) })
            .store(in: &cancellables)

        // Bind Inputs

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
            .map({ ($0 == .slow) ? 0.5 : ($0 == .normal) ? 1.0 : 2.0  })
            .sink(receiveValue: youtubePlayer.set(playbackRate: ))
            .store(in: &cancellables)

        seekingSubject
            .eraseToAnyPublisher()
            .assign(to: \.currentlySeeking, on: self)
            .store(in: &cancellables)
    }
}

extension VideoPlayerControlsViewModel{
    enum PlaybackRate: String{
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
}
