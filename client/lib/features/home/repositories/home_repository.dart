import 'package:client/core/constants/server_constant.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<void> uploadSong() async {
    // Upload song logic
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ServerConstant.serverURL}/song/upload'),
    );
    request
      ..files.addAll(
        [
          await http.MultipartFile.fromPath(
            'song',
            "C:\\Users\\dhawa\\Downloads\\file_example_MP3_700KB.mp3",
          ),
          await http.MultipartFile.fromPath(
            'thumbnail',
            "C:\\Users\\dhawa\\Downloads\\file_example_JPG_100kB.jpg",
          ),
        ],
      )
      ..fields.addAll(
        {
          'song_name': 'Test Song',
          'artist': 'Test Artist',
          'hex_code': 'FFFFFF',
        },
      )
      ..headers.addAll(
        {
          'Content-Type': 'multipart/form-data',
          'x_auth-token': '',
        },
      );
    final response = await request.send();
    print(response);
  }
}
