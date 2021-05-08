// Prod Storage API
const String STORAGE_API_ROOT_GET_PROD = '192.168.51.179:4000';
const String STORAGE_API_ROOT_PROD = 'http://$STORAGE_API_ROOT_GET_PROD';

// Dev Storage API
const String STORAGE_API_ROOT_GET_DEV = '192.168.51.179:3999';
const String STORAGE_API_ROOT_DEV = 'http://$STORAGE_API_ROOT_GET_DEV';

String storageApiRoot = STORAGE_API_ROOT_PROD;
String storageApiRootGet = STORAGE_API_ROOT_GET_PROD;

// APP KEY
const String APP_KEY = 'apna_classroom_app_24x7_789';

// File Route
const String FILE_ROOT = '/file';

// Upload File
const String UPLOAD_FILE = '$FILE_ROOT/upload';

// Stream
const String STREAM_FILE = '$FILE_ROOT/stream';

// TYPES

class StorageConstant {
  static const String APP_KEY = 'appKey';

  // UID
  static const String USER_ID = 'userId';

  static const String PATH = 'path';
  static const String QUALITY = 'quality';
  static const String TYPE = 'type';

  static const String FILE = 'file';
  static const String THUMBNAIL = 'thumbnail';

  static const String NAME = 'name';
  static const String SIZES = 'sizes';
}

class FileType {
  static const String IMAGE = 'image';
  static const String VIDEO = 'video';
  static const String DOC = 'doc';
}

class FileName {
  static const String THUMBNAIL = 'thumbnail';
  static const String MAIN = 'main';
}
