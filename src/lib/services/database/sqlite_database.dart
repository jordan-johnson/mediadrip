import 'dart:ffi';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:mediadrip/exceptions/data_source_exception.dart';
import 'package:mediadrip/exceptions/sqlite_not_found_exception.dart';
import 'package:mediadrip/locator.dart';
import 'package:mediadrip/services/database/data_source.dart';
import 'package:mediadrip/services/index.dart';
import 'package:mediadrip/utilities/file_helper.dart';
import 'package:path/path.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

class SqliteDatabase implements DataSource<Database> {
  final String _databaseFileName = 'core.db';

  Database _sqliteDatabase;

  PathService _pathService = locator<PathService>();

  String _databasePath;

  @override
  Future<void> init() async {
    if(_sqliteDatabase != null)
      return;

    print('init database');

    await _checkIfLocalDatabaseExists();

    try {
      switch(Platform.operatingSystem) {
        case 'windows':
          await _loadWindowsBinary();
        break;
      }
    } on SqliteNotFoundException catch(e) {
      // display an alert that sqlite library not found
      print('exception thrown! ${e.toString()}');
    }
  }

  @override
  Future<void> openConnection() async {
    if(_sqliteDatabase != null)
      return;

    print('opened connection');

    _sqliteDatabase = sqlite3.open(_databasePath);
  }

  @override
  Future<void> closeConnection() async {
    if(_sqliteDatabase == null)
      return;
    
    print('closed sqlite connection');

    _sqliteDatabase.dispose();
  }

  @override
  Database getDatabase() {
    if(_sqliteDatabase == null)
      throw DataSourceException('Cannot get database; returned null. Please initialize.');

    execute((source) => {
      
    });
    
    return _sqliteDatabase;
  }

  /// Hacky method for boilerplate to open a connection to the database,
  /// execute a provided action, then close the connection.
  /// 
  /// This is bad code but necessary until the Dart devs get around to 
  /// detecting application exiting on Windows. I'd prefer opening and 
  /// closing many times subsequently rather than the user closing the 
  /// application and never closing the connection.
  @override
  Future<void> execute(void Function(Database source) action) async {
    try {
      // if a connection already exists, don't open a new one
      if(_sqliteDatabase == null)
        await this.openConnection();

      final Database source = getDatabase();

      action(source);

      await this.closeConnection();
    } catch(e) {
      print('error executing::$e');
    }
  }

  /// Hacky method for boilerplate to open a connection to the database,
  /// execute a provided action, close the connection, then return results 
  /// from the executed action.
  /// 
  /// This is bad code but necessary until the Dart devs get around to 
  /// detecting application exiting on Windows. I'd prefer opening and 
  /// closing many times subsequently rather than the user closing the 
  /// application and never closing the connection.
  @override
  Future<R> retrieve<R>(R Function(Database source) action) async {
    dynamic returnValue;

    try {
      // if a connection already exists, don't open a new one
      if(_sqliteDatabase == null)
        await this.openConnection();

      final Database source = getDatabase();

      returnValue = action(source);

      await this.closeConnection();
    } catch(e) {
      print('error executing::$e');
    }

    return returnValue;
  }

  Future<void> _checkIfLocalDatabaseExists() async {
    var databaseExists = await _pathService.fileExistsInDirectory(_databaseFileName, AvailableDirectories.root);
    var documentsDirectory = await _pathService.mediaDripDirectory;
    
    this._databasePath = join(documentsDirectory, _databaseFileName);

    if(!databaseExists) {
      await _copyDatabaseAssetToDocuments();
    }
  }

  Future<void> _loadWindowsBinary() async {
    var exeDirectory = File(Platform.resolvedExecutable).parent;
    var sqliteLibrary = File('${exeDirectory.path}\\sqlite3.dll');
    var exists = await sqliteLibrary.exists();

    if(exists) {
      open.overrideFor(OperatingSystem.windows, () => DynamicLibrary.open(sqliteLibrary.path));
    } else {
      throw SqliteNotFoundException('Missing sqlite3.dll in application directory!');
    }
  }

  Future<void> _copyDatabaseAssetToDocuments() async {
    var byteData = await rootBundle.load('lib/assets/' + _databaseFileName);
    var bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    var documentsDirectory = await _pathService.mediaDripDirectory;
    
    documentsDirectory = join(documentsDirectory, _databaseFileName);

    await FileHelper.writeBytesToPath(documentsDirectory, bytes);
  }
}