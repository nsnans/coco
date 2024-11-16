import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui show Codec;

import 'ffi.dart';

class ImageCacheProvider extends ImageProvider<ImageCacheProvider> {
  final String url;
  final String useful;
  final double scale;
  final int? extendsFieldIntFirst;
  final int? extendsFieldIntSecond;
  final int? extendsFieldIntThird;

  ImageCacheProvider({
    required this.url,
    required this.useful,
    this.extendsFieldIntFirst,
    this.extendsFieldIntSecond,
    this.extendsFieldIntThird,
    this.scale = 1.0,
  });

  @override
  ImageStreamCompleter load(ImageCacheProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: key.scale,
    );
  }

  @override
  Future<ImageCacheProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ImageCacheProvider>(this);
  }

  Future<ui.Codec> _loadAsync(ImageCacheProvider key) async {
    assert(key == this);
    return PaintingBinding.instance!.instantiateImageCodec(
      await _loadImageFile((await native.loadCacheImage(
        url: url,
        useful: useful,
        extendsFieldIntFirst: extendsFieldIntFirst,
        extendsFieldIntSecond: extendsFieldIntSecond,
        extendsFieldIntThird: extendsFieldIntThird,
      ))
          .absPath),
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final ImageCacheProvider typedOther = other;
    return url == typedOther.url && scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(url, scale);

  @override
  String toString() => '$runtimeType('
      'path: ${describeIdentity(url)},'
      ' scale: $scale'
      ')';
}

Future<Uint8List> _loadImageFile(String path) {
  return File(path).readAsBytes();
}

class DownloadImageProvider extends ImageProvider<DownloadImageProvider> {
  final String dlKey;
  final double scale;

  DownloadImageProvider({
    required this.dlKey,
    this.scale = 1.0,
  });

  @override
  ImageStreamCompleter load(DownloadImageProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: key.scale,
    );
  }

  @override
  Future<DownloadImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<DownloadImageProvider>(this);
  }

  Future<ui.Codec> _loadAsync(DownloadImageProvider key) async {
    assert(key == this);
    return PaintingBinding.instance!.instantiateImageCodec(
      await _loadImageFile((await native.loadDlImage(
        dlKey: dlKey,
      ))),
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final DownloadImageProvider typedOther = other;
    return dlKey == typedOther.dlKey && scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(dlKey, scale);

  @override
  String toString() => '$runtimeType('
      ' dlKey: ${describeIdentity(dlKey)},'
      ' scale: $scale'
      ')';
}
