import 'dart:io';
import 'dart:ui';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/models/fav_song_model.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(currentUserProvider)?.token ?? '';
  final res = await ref
      .watch(homeRepositoryProvider)
      .getAllSongs(
        token: token,
      );

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getFavSongs(Ref ref) async {
  final token = ref.watch(currentUserProvider.select((user) => user?.token));
  final res = await ref
      .watch(homeRepositoryProvider)
      .getFavSongs(
        token: token ?? '',
      );

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserProvider)!.token,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSongs();
  }

  Future<void> favSong({required String songId}) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.favSong(
      songId: songId,
      token: ref.read(currentUserProvider)?.token ?? '',
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => r, //_favSongSuccess(r, songId),
    };
    print(val);
  }

  // AsyncValue _favSongSuccess(bool isFavorited, String songId) {
  //   final userNotifier = ref.read(currentUserProvider.notifier);
  //   if (isFavorited) {
  //     userNotifier.addUser(
  //       ref
  //           .read(currentUserProvider)?
  //           .copyWith(
  //             favorites: [
  //               ...ref.read(currentUserProvider)?.favorites,
  //               FavSongModel(
  //                 id: '',
  //                 song_id: songId,
  //                 user_id: '',
  //               ),
  //             ],
  //           ),
  //     );
  //   } else {
  //     userNotifier.addUser(
  //       ref
  //           .read(currentUserProvider)?
  //           .copyWith(
  //             favorites: ref
  //                 .read(currentUserProvider)?
  //                 .favorites
  //                 .where(
  //                   (fav) => fav.song_id != songId,
  //                 )
  //                 .toList(),
  //           ),
  //     );
  //   }
  //   ref.invalidate(getFavSongsProvider);
  //   return state = AsyncValue.data(isFavorited);
  // }
}
