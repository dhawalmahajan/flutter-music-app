import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    // Upload song logic
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.serverURL}/song/upload'),
      );
      request
        ..files.addAll(
          [
            await http.MultipartFile.fromPath(
              'song',
              selectedAudio.path,
            ),
            await http.MultipartFile.fromPath(
              'thumbnail',
              selectedThumbnail.path,
            ),
          ],
        )
        ..fields.addAll(
          {
            'song_name': songName,
            'artist': artist,
            'hex_code': hexCode,
          },
        )
        ..headers.addAll(
          {
            'Content-Type': 'multipart/form-data',
            'x_auth-token': token,
          },
        );
      final response = await request.send();
      if (response.statusCode != 201) {
        final respStr = await response.stream.bytesToString();
        return Left(AppFailure('Upload failed: $respStr'));
      }
      return Right(await response.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
