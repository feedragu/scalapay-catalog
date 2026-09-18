import 'dart:io' as io;

import 'package:file/memory.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Serves fixture PNGs from an in-memory file system for known URLs and fails
// for anything else, so images resolve inside the test zone with no network
// or cache directory involved.
class FakeCacheManager implements BaseCacheManager {
  FakeCacheManager([Map<String, String> files = const {}]) {
    for (final entry in files.entries) {
      _fileSystem.file(entry.key.hashCode.toString())
        ..createSync()
        ..writeAsBytesSync(io.File(entry.value).readAsBytesSync());
      _urls.add(entry.key);
    }
  }

  final _fileSystem = MemoryFileSystem();
  final _urls = <String>{};

  static Map<String, String> shoes() => {
    for (var i = 1; i <= 4; i++)
      'https://img.test/shoe_$i.png': 'test/fixtures/images/shoe_$i.png',
  };

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool withProgress = false,
  }) async* {
    if (!_urls.contains(url)) {
      throw HttpExceptionWithStatus(
        404,
        'No fixture for $url',
        uri: Uri.parse(url),
      );
    }
    yield FileInfo(
      _fileSystem.file(url.hashCode.toString()),
      FileSource.Cache,
      DateTime.now().add(const Duration(days: 1)),
      url,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
