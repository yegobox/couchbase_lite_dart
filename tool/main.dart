// Copyright (c) 2020, Rudolf Martincsek. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: dead_code, always_declare_return_types, omit_local_variable_types

import 'dart:convert';
import 'dart:io';

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';

const testDB = 'plugintest';
const testDir = 'D:\\tmp\\';

const testDB1 = 'plugintest_1';
const testDir1 = 'D:\\tmp1\\';

// ignore
void main() async {
  Cbl.init();
  print('**** Hello World!****');

  // testIndexes();

  testMutableProps();

  // Cbl.init();

  // print(Cbl.isPlatformSupported());

  // for (var i = 0; i < 10; i++) {
  //   print('MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM');
  //   await testFleece();
  // }

  // print('FINISHED');

  // testBlob();

  // testQuery();

  // testReplicator();

  //testDatabaseChangeListener();

  // testDocumentChangeListener();

  //testDocumentExpiration();

  // testSaveDocument();

  //testAccessors();

  //testDatabaseDelete();

  // testDatabaseBatch();

  //testDatabaseDelete();

  // testDatabaseCompact();

  // testDatabaseClose();

  // testDatabaseExists();

  // testDBCopy();

  // testDatabaseCopy();

  //? LIFE CYCLE TESTS
/*
  var db = Database(testDB, directory: testDir);

  print('*** db.open() START ****');
  try {
    db.open();
  } on DatabaseException catch (e) {
    print(e);
  }
  print('*** db.open() END ****');

  print(db.name);
  print(db.isOpen);
  print(db.path);*/
}

testIndexes() {
  var db = Database(testDB);
  db.open();
  print('Database is open > ' + db.isOpen.toString());
  print('Document count >' + db.count.toString());

  var indexes = db.indexNames();
  print(indexes.length);
  print(indexes.json);

  var result = db.createIndex('nameidx', ['name']);
  var result1 = db.createIndex('email-index', ['email']);
  print(result);
  print(result1);

  indexes = db.indexNames();
  print(indexes.length);
  print(indexes.json);

  db.deleteIndex('nameidx');

  indexes = db.indexNames();
  print(indexes.length);
  print(indexes.json);
}

testMutableProps() async {
  var doc = FLDoc.fromJson('{"foo": "bar", "map": [1,2,3,4]}');

  print(doc.error);

  var d = doc.root.asMap.mutableCopy;

  print(d['test'] = 'hello');
  print(d['foo'] = 10);

  print(d.json);

  return;
  var root1 = FLArray();
  var map1 = FLArray();

  print(map1.json);
  print(root1.json);

  root1[0] = map1;

  map1[1] = ['value1'];
  map1[2] = 10;
  map1[3] = 10.5;
  map1[4] = 10.0;
  map1[5] = true;
  map1[6] = 'hello';

  print(map1.json);
  print(root1.json);
  print('************************');
  final fldoc = FLDoc.fromJson(jsonEncode({
    'name': 'Rudolf',
    'email': 'example',
    'map1': {
      'key1': 'value1',
      'map2': {'key2': 'value2'},
    },
  }));

  print(fldoc.root.json);
  print(fldoc.root.type);

  var root = fldoc.root.asMap.mutableCopy;
  print('Map changed: ' + root.changed.toString());

  print(root.value['map1.map2'].json);
  var map = root.value['map1.map2'].asMap;

  print(map.isMutable);
  // print(map);

  print('Map changed: ' + root.changed.toString());
  await pause(100);
  map['key2'] = {'key3': 'value3'};
  map['key4'] = true;

  print('Map changed: ' + map.changed.toString());
  print(map.json);

  // root.value['map1'].asMap['map2'] = map;

  print(root.json);
  print(fldoc.root.json);

  // return;

  // var map1 = root['map1'].asMap.mutable;
  // var map2 = map1['map2'].asMap.mutable;
  // map2['key2'] = {'key3': 'value3'};

  // map1['map2'] = map2;

  // root['map1'] = map1;

  // print('map2 -----');

  // print(map2.json);
  // print(map1.json);

  // print('mut -----');
  // print(root.json);
  // // fldoc.root = root.value;

  // print('Mutated>');
  // print(fldoc.root.json);
}

testFleece() async {
  print('----- FLEECE ---');

  var f = File('assets/testdoc1.json');
  var json = f.readAsStringSync();
  // print(json);
  final doc4 = FLDoc.fromJson(json);
  print(doc4.error);
  print(doc4.root.json);
  print('*******************');

  print(doc4.root['menu'].json);
  await pause(1);
  print(doc4.root['menu.dict'].json);
  await pause(1);
  print(doc4.root['menu.dict.first'].json);
  await pause(1);
  print(doc4.root['menu.dict.first'].asList[0]);
  await pause(1);
  print(doc4.root['menu.dict.first'].asList[1]);
  await pause(1);
  print(doc4.root['menu.dict.first'].asList[2]);
  await pause(1);
  print(doc4.root['menu.popup'].asMap.json);
  print('****** LISTS *******');
  final list1 = doc4.root['menu.popup.menuitem'].asList;
  print(list1.json);
  print('iterating list1...');
  for (var v in list1) {
    print('---');
    print(v.json);
  } // await pause(1);
  return;

  print(list1.toString());

  print('iterating menuitem1 ...');
  print(doc4.root['menu.popup.menuitem1'].asList.length);
  for (var v in doc4.root['menu.popup.menuite1'].asList) {
    print('1---');
    print(v.runtimeType);
  }
  // await pause();
  print('******** MAPS *********');

  print('  map1:');
  final map1 = doc4.root['menu.dict'].asMap;
  print(map1.json);
  for (var v in map1) {
    print('---');
    print(v.json);
  }
  print('  map2:');
  final map2 = doc4.root['menu.dict1'];
  print(map2.json);

  return;

  var doc1 = FLDoc.fromJson(
      '{"string" : "Hello world", "string1": "10", "double": 10, "double1": 10.25, "int" : 10, "bool" : true}');
  print('-----');
  print(doc1.root.toString());

  <FLValue>[
    doc1.root['string'],
    doc1.root['string1'],
    doc1.root['double'],
    doc1.root['double1'],
    doc1.root['int'],
    doc1.root['bool']
  ].forEach((v) {
    print('-----');
    print(v.type);
    print('As string > ' + v.asString);
    print('To string > ' + v.toString());
  });

  return;

  var db = Database(testDB);
  db.open();
  print('Database is open > ' + db.isOpen.toString());
  print('Document count >' + db.count.toString());

  var doc = db.getDocument('testdoc');
  var props = doc.properties;
  print(props);
  print('-----');
  print(props['foo']);
  print(props['foo'].type);

  print('-----');
  print(props['logo.length']);
  print(props['logo.length'].type);

  // DocumentProperties_Benchmark().report();
  // DocumentJsonProperties_Benchmark().report();
}

testBlob() async {
  var db = Database(testDB);
  db.open();
  print('Database is open > ' + db.isOpen.toString());
  print('Document count >' + db.count.toString());

  //db.compact();
  // return;
  // Read, modify and save document
  try {
    var f = File('lib/src/Untitled1.png');

    var img = f.readAsBytesSync();

    var bl = Blob.createWithData(db, 'image/png', img);
    print(bl.pointer);
/*
    print(bl.contentType);
    print(bl.digest);
    print(bl.length);

    print(bl.toMap());
*/
/*
    var doc1 = db.getMutableDocument('testdoc3');
    doc1.properties = {
      'foo': 'bar8',
      'logo': bl.toMap(),
    };
    db.saveDocument(doc1);*/
  } catch (e) {
    print('Exception caught > $e');
  }

  await pause(5);

  //var bl = Blob.createWithData('text/txt', '1234');
  //print(bl.pointer);
}

void testQuery() async {
  var db = Database(testDB);
  db.open();
  print('Database is open > ' + db.isOpen.toString());
  print('Document count >' + db.count.toString());
  // testReplicator();
  await pause(1);

  db.saveDocument(Document('test1',
      data: {'name': 'Rudolf', 'pwd': '', 'age': 0, 'active': false}));
  db.saveDocument(Document('test2', data: {
    'name': 'Rudolf',
    'age': 1,
    'email': 'example.com',
    'pwd': 'ddd',
    'active': true
  }));

  try {
    // final q = Query(db, 'SELECT * AS center WHERE dt="AC" AND id=\$ID');
    final q =
        Query(db, 'SELECT pwd,active, name, age, email WHERE name = "Rudolf"');

    // q.setParameters = {'ID': 'testcenter1'};
/*
    q.addChangeListener((List results) {
      print('New query results for: ');
      print(results);
    });
*/
    var results1 = q.execute();
    print(results1);
  } on Exception catch (e) {
    print('!!! Exception caught > $e');
    print(StackTrace.current);
  }

  await pause(1);
/*
  try {
    var q1 = Query(db, 'SELECT * AS center WHERE dt='AC' AND id=\$ID');

    q1.setParameters({'ID': 'testcenter2'});

    q1.addChangeListener((List results) {
      print('New query results for: ');
      print(results);
    });

    q1.execute();
    // print(results2);
  } on Exception catch (e) {
    print('!!! Exception caught > $e');
    print(StackTrace.current);
  }
*/
}

testPushFilter() {
  var db = Database('replchangelistener', directory: '_tmp');
  var basicAuth = Authenticator.basic('cblc_test', 'cblc_test');

  // ignore: unused_local_variable
  var doc_received = false;
  // ignore: unused_local_variable
  Document doc_filtered;

  var replicator = Replicator(
    db,
    endpointUrl: 'ws',
    authenticator: basicAuth,
    pushFilter: (document, _) {
      doc_received = true;
      doc_filtered = document;
      return true;
    },
  );

  replicator.start();

  db.saveDocument(Document(
    'testdoc',
    data: {'foo': 'bar', 'dt': 'test'},
  ));
}

testReplicator() async {
  var db = Database(testDB);
  db.open();
  print('Database is open > ' + db.isOpen.toString());
  print('Document count >' + db.count.toString());

  var basicAuth = Authenticator.basic('testuser', 'testuser');

  try {
    var replicator = Replicator(
      db,
      endpointUrl: 'ws://localhost:4984/divemanager/',
      authenticator: basicAuth,
    );

    print(replicator);
    print(replicator.status());
    replicator.start();

    // replicator.addChangeListener((status) {
    //   print('Replicator status: ' + status.activityLevel.toString());
    // });
    await pause(1);
    print(replicator.status());

    await pause(1);
    replicator.suspend();

    await pause(1);
    print(replicator.status());

    await pause(1);
    replicator.stop();

    await pause(1);
    print(replicator.status());
  } catch (e) {
    print('!!! Exception caught > $e');
  }

  while (true) {
    await pause(1);
  }
}

testReplicator1() async {
  var db = Database(testDB);
  db.open();
  print('Database is open > ' + db.isOpen.toString());
  print('Document count >' + db.count.toString());

  await pause(1);

  var basicAuth = Authenticator.basic('testuser', 'testuser');

  var sessionAuth =
      Authenticator.session('5edb36ffdfd3530ba75574f3e45d68ee2a774a70');

  print(basicAuth.auth);
  print(sessionAuth.auth);

  final pullFilter = (doc, isDeleted) {
    print('Inside app pull filter');
    print(doc.ID);
    print('Response: ' + (doc.ID != 'testcenter1').toString());
    return doc.ID != 'testcenter1';
  };

  final pushFilter = (doc, isDeleted) {
    print('Inside app push filter');
    print(doc.ID);
    print('Response: ' + (doc.ID != 'testcenter1').toString());
    return doc.ID != 'testcenter1';
  };

  try {
    var replicator = Replicator(
      db,
      endpointUrl: 'ws://localhost:4984/divemanager/',
      authenticator: basicAuth,
      //channels: ['channel1', 'docs::testusssssdfd'],
      //documentIDs: ['testuser1'],
      //headers: {'First': 'Header', 'Another': 'Header'},
      pushFilter: pushFilter,
      pullFilter: pullFilter,
    );

    print(replicator);
    replicator.start();

    // replicator.addChangeListener((status) {
    //   print('Replicator status: ' + status.activityLevel.toString());
    // });

    var doc = db.getMutableDocument('testcenter1');
    print(doc.properties.json);
    doc.jsonProperties = doc.properties.json.replaceAll('qdffd', 'RRR');
    db.saveDocument(doc);
    print('here');
    await pause(1);
  } catch (e) {
    print('!!! Exception caught > $e');
  }
  // while (true) {
  //   await pause(1);
  // }

  // await pause(10);
}

testDatabaseChangeListener() async {
  var db = Database(testDB);
  db.open();

  db.bufferNotifications(() {
    // Do work and/or scheduling...
    // Then
    db.sendNotifications();
  });

  print('Database is open > ' + db.isOpen.toString());
  print('Document count >' + db.count.toString());

  // Create two documents
  db.saveDocument(Document(
    'testdoc',
    data: {'foo': 'bar'},
  ));

  db.saveDocument(Document(
    'testdoc1',
    data: {'foo': 'bar1'},
  ));

  var token1 = db.addChangeListener((change) {
    print('+++Inside first top level listener');
    print(change.database?.name);
    print(change.documentIDs);
    print('----Inside first top level listener');
  });

  print('Token > ' + token1.toString());

  // var token2 = db.addChangeListener((change) {
  //   print('+++Inside second top level listener');
  //   print(change.database?.name);
  //   print(change.documentIDs);
  //   print('----Inside second top level listener');
  // });

  // print('Token > ' + token2.toString());

  //await pause();

  print('                   updating testdoc');
  // Update testdoc
  db.saveDocument(Document(
    'testdoc',
    data: {'foo': 'bar_new'},
  ));

  await pause();

  print('                   updating testdoc1');
  // Update testdoc
  db.saveDocument(Document(
    'testdoc1',
    data: {'foo': 'bar1_new'},
  ));

  await pause();
  print('removing listener on testdoc');
  db.removeChangeListener(token1);

  await pause();

  print('                   updating testdoc again');
  // Update testdoc
  db.saveDocument(Document(
    'testdoc',
    data: {'foo': 'bar1_new1'},
  ));

  await pause();

  print('                   updating testdoc1 again');
  // Update testdoc
  db.saveDocument(Document(
    'testdoc1',
    data: {'foo': 'bar1_new1'},
  ));

  await pause();
}

testDocumentChangeListener() async {
  var db = Database(testDB);
  db.open();
  print('Database is open > ' + db.isOpen.toString());
  print('Document count >' + db.count.toString());

  // Create two documents
  db.saveDocument(Document(
    'testdoc',
    data: {'foo': 'bar'},
  ));

  db.saveDocument(Document(
    'testdoc1',
    data: {'foo': 'bar1'},
  ));

  var token1 = db.addDocumentChangeListener('testdoc', (change) {
    print('+++Inside first top level listener');
    print(change.database?.name);
    print(change.documentID);
    print('----Inside first top level listener');
  });

  print('Token > ' + token1.toString());

  var token2 = db.addDocumentChangeListener('testdoc1', (change) {
    print('+++Inside second top level listener');
    print(change.database?.name);
    print(change.documentID);
    print('----Inside second top level listener');
  });

  print('Token > ' + token2.toString());

  await pause();

  print('updating testdoc');
  // Update testdoc
  db.saveDocument(Document(
    'testdoc',
    data: {'foo': 'bar_new'},
  ));

  await pause();

  print('updating testdoc1');
  // Update testdoc
  db.saveDocument(Document(
    'testdoc1',
    data: {'foo': 'bar1_new'},
  ));

  print('removing listener on testdoc');
  db.removeChangeListener(token1);

  await pause();

  print('updating testdoc again');
  // Update testdoc
  db.saveDocument(Document(
    'testdoc',
    data: {'foo': 'bar1_new1'},
  ));

  await pause();

  print('updating testdoc1 again');
  // Update testdoc
  db.saveDocument(Document(
    'testdoc1',
    data: {'foo': 'bar1_new1'},
  ));

  await pause();
}

pause([int secs = 2]) async {
  print('...');
  await Future.delayed(Duration(milliseconds: secs));
}

testDocumentExpiration() async {
  var db = Database(testDB);
  db.open();
  print('Database is open > ' + db.isOpen.toString());

  print('Document count >' + db.count.toString());

  // Create new document
  var doc = Document('testdoc');
  doc.properties = {'foo': 'bar'};
  var savedDoc = db.saveDocument(doc);
  print('Created document > ' + savedDoc.toString());

  bool result;

  // Read document
  print('reading document');
  var doc1 = db.getDocument('testdoc');
  print('Document ID > ' + doc1.ID);
  print('Document revisionID > ' + doc1.revisionID.toString());
  print('Document sequence > ' + doc1.sequence.toString());
  print(doc1?.properties);
  print(doc1?.jsonProperties);

  var ex = db.documentExpiration('testdoc');
  print('Document expiration time > ' + (ex?.toIso8601String() ?? 'never'));

  result = db.setDocumentExpiration(
    'testdoc',
    DateTime.now().add(Duration(seconds: 20)),
  );

  print('Setting document expiration time > ' + result.toString());

  var ex1 = db.documentExpiration('testdoc');
  print('Document expiration time > ' + (ex1?.toIso8601String() ?? 'never'));

  await Future.delayed(Duration(seconds: 30));

  // Read document
  print('reading document');
  var doc2 = db.getDocument('testdoc');

  print(doc2);
  if (doc2 != null) {
    print('Document ID > ' + doc2.ID);
    print('Document revisionID > ' + doc2.revisionID.toString());
    print('Document sequence > ' + doc2.sequence.toString());
    print(doc2?.properties);
    print(doc2?.jsonProperties);
  }
}

testSaveDocument() async {
  var db = Database(testDB);
  db.open();
  print('Database is open > ' + db.isOpen.toString());

  print('Document count >' + db.count.toString());

  // Read, modify and save document
  try {
    var doc1 = db.getMutableDocument('testdoc3');
    doc1.properties = {'foo': 'bar12'};

    await pause(10);
    // db.saveDocument(doc1);
    db.saveDocumentResolving(doc1, (doc1, doc2) {
      print('---- doc being saved----');
      print(doc1.ID);
      print(doc1.properties.json);
      print('----- conflicting document ---');
      print(doc2.ID);
      print(doc2.properties.json);

      return false;
    });
    print('document saved');
  } catch (e) {
    print('Exception caught > $e');
  }

  return;

  // Create new document
  var doc = Document('testdoc3');
  doc.properties = {'foo': 'bar3'};
  var savedDoc = db.saveDocument(doc);
  print('Created document > ' + savedDoc.toString());

  // Read, modify and save document
  Document doc1;
  try {
    doc1 = db.getDocument('testdoc3');
    doc1.properties = {'foo': 'bar4'};
  } catch (e) {
    print('Exception caught > $e');
  }

  var mutDoc = doc1.mutableCopy;
  mutDoc.properties = {'foo': 'bar5'};
  db.saveDocument(mutDoc);

  // Read, modify and save document
  try {
    var doc1 = db.getMutableDocument('testdoc3');
    doc1.properties = {'foo': 'bar8'};
    db.saveDocument(doc1);
    print('document saved');
  } catch (e) {
    print('Exception caught > $e');
  }

  print('Document count >' + db.count.toString());
}

testDocument() {
  var db = Database(testDB);
  db.open();
  print('Database is open > ' + db.isOpen.toString());

  print('Document count >' + db.count.toString());

  // Create new document
  var doc = Document('testdoc');
  doc.properties = {'foo': 'bar1'};
  var savedDoc = db.saveDocument(doc);
  print('Created document > ' + savedDoc.toString());

  bool result;

  // Read document
  print('reading document');
  var doc1 = db.getDocument('testdoc');
  print('Document ID > ' + doc1.ID);
  print('Document revisionID > ' + doc1.revisionID.toString());
  print('Document sequence > ' + doc1.sequence.toString());
  print(doc1?.properties);
  print(doc1?.jsonProperties);

  print('reading missing document');
  var doc2 = db.getDocument('missingdoc');
  print(doc2?.properties);

  // Delete documents
  var result1 = doc1.delete();
  print('Deleting document >' + result1.toString());

  // Purge
  try {
    result = doc1.purge();
    print('Purge new document >' + result.toString());
  } catch (e) {
    print('!!! Exception caught >$e ');
  }

  print('Purge by id');

  var doc3 = Document('testdoc');
  doc.properties = {'foo': 'bar1'};
  db.saveDocument(doc3);

  try {
    result = db.purgeDocument('testdoc');
    print('Purge >' + result.toString());
  } catch (e) {
    print('!!! Exception caught >$e ');
  }

  print('Purge already purged document');
  try {
    result = db.purgeDocument('testdoc');
    print('Purge >' + result.toString());
  } catch (e) {
    print('!!! Exception caught >$e ');
  }

  print('Purge inexisting id');
  try {
    result = db.purgeDocument('testdoc11111');
    print('Purge >' + result.toString());
  } catch (e) {
    print('!!! Exception caught >$e ');
  }

  print('Document count >' + db.count.toString());
}

testDatabaseExists() {
  print('**** Database.exists() START');

  print('$testDir$testDB > ' +
      Database.exists(testDB, directory: testDir).toString());
  print('$testDir1$testDB > ' +
      Database.exists(testDB, directory: testDir1).toString());
  print(' ');
  print('$testDB1 > ' + (Database.exists(testDB1)).toString());
  print('$testDir$testDB1 > ' +
      Database.exists(testDB1, directory: testDir).toString());
  print('$testDir1$testDB1 > ' +
      Database.exists(testDB1, directory: testDir1).toString());

  print('**** Database.exists() END');
}

testDBCopy() {
  Database db = Database(testDB), db1 = Database(testDB, directory: testDir);
  List<String> copyDb = List.generate(10, (i) => '_copy$i');
  bool result = false;

  try {
    db.open();
    db1.open();
  } on DatabaseException catch (e) {
    print(e);
  }

  print('----');
  print('Copying ' + testDB + '.cblite2\\' + ' -> ' + copyDb[0]);

  result = false;
  try {
    result = db.copy(
      copyDb[0],
      // directory: testDir,
    );
  } on DatabaseException catch (e) {
    print('Exception caught > $e');
  }
  print('Result > $result');

  print('----');
  print('Copying ' + testDB + '.cblite2\\' + ' -> ' + testDir + copyDb[1]);

  result = false;
  try {
    result = db.copy(
      copyDb[1],
      directory: testDir,
    );
  } on DatabaseException catch (e) {
    print('Exception caught > $e');
  }
  print('Result > $result');

  print('----');
  print('Copying ' + testDir + testDB + '.cblite2\\' + ' -> ' + copyDb[2]);

  result = false;
  try {
    result = db1.copy(
      copyDb[2],
      // directory: testDir,
    );
  } on DatabaseException catch (e) {
    print('Exception caught > $e');
  }
  print('Result > $result');

  print('----');
  print('Copying ' +
      testDir +
      testDB +
      '.cblite2\\' +
      ' -> ' +
      testDir +
      copyDb[3]);

  result = false;
  try {
    result = db1.copy(
      copyDb[3],
      directory: testDir,
    );
  } on DatabaseException catch (e) {
    print('Exception caught > $e');
  }
  print('Result > $result');
}

testDatabaseCopy() {
  print('****');
  bool result = false;
  List<String> copyDb = List.generate(10, (i) => '_copy$i');

  print('----');
  print('Copying ' + testDB + '.cblite2\\' + ' -> ' + copyDb[0]);
  result = false;
  try {
    result = Database.Copy(
      testDB + '.cblite2\\',
      copyDb[0],
      // directory: testDir,
    );
  } on DatabaseException catch (e) {
    print('Exception caught > $e');
  }
  print('Result > $result');

  print('----');
  print('Copying ' + testDir + testDB + '.cblite2\\' + ' -> ' + copyDb[1]);
  result = false;
  try {
    result = Database.Copy(
      testDir + testDB + '.cblite2\\',
      copyDb[1],
      // directory: testDir,
    );
  } on DatabaseException catch (e) {
    print('Exception caught > $e');
  }
  print('Result > $result');

  print('----');
  print('Copying ' + testDB + '.cblite2\\' + ' -> ' + testDir + copyDb[2]);
  result = false;
  try {
    result = Database.Copy(
      testDB + '.cblite2\\',
      copyDb[2],
      directory: testDir,
    );
  } on DatabaseException catch (e) {
    print('Exception caught > $e');
  }
  print('Result > $result');

  print('----');
  print('Copying ' +
      testDir +
      testDB +
      '.cblite2\\' +
      ' -> ' +
      testDir +
      copyDb[3]);
  result = false;
  try {
    result = Database.Copy(
      testDir + testDB + '.cblite2\\',
      copyDb[3],
      directory: testDir,
    );
  } on DatabaseException catch (e) {
    print('Exception caught > $e');
  }
  print('Result > $result');

  print('****');
}

testDatabaseClose() {
  Database db = Database(testDB), db1 = Database(testDB);
  bool result = false;
  print('*****');
  db.open();
  db1.open();
  result = db.close();

  print('Closing $testDB > $result');
  print(db.isOpen);
  result = db.close();

  print('Closing $testDB > $result');
  print(db.isOpen);
}

testDatabaseCompact() {
  Database db = Database(testDB), db1 = Database(testDB);
  bool result = false;
  print('*****');
  db.open();
  //db1.open();
  result = db.compact();
  print('Compacting $testDB > $result');

  result = db1.compact();
  print('Compacting $testDB1 > $result');
}

testDatabaseDelete() {
  Database db = Database(testDB);
  bool result = false;
  print('*****');

  try {
    db.open();
    db.close();
    result = Database.Delete(testDB);
  } catch (e) {
    print('!!! Exception caught >$e ');
  }
  print('Deleting existing `$testDB` without open connections > $result');

  result = null;
  try {
    result = Database.Delete(testDB);
  } catch (e) {
    print('!!! Exception caught >$e ');
  }
  print('Deleting non existing `$testDB`  > $result');

  result = null;
  try {
    db.open();
    result = Database.Delete(testDB);
  } catch (e) {
    print('!!! Exception caught > $e');
  }
  print('Deleting existing `$testDB` with open connections > $result');
}

testDBDelete() {
  Database db = Database(testDB), db1 = Database(testDB);
  bool result = false;
  print('*****');

  try {
    db.open();
    result = db.delete();
  } on DatabaseException catch (e) {
    print('Exception caught >$e ');
  }
  print('Deleting $testDB > $result');

  db = Database(testDB);
  db1 = Database(testDB);

  result = false;
  try {
    db.open();
    db1.open();
    result = db.delete();
  } on DatabaseException catch (e) {
    print('Exception caught >$e ');
  }
  print('Deleting $testDB > $result');
}

testDatabaseBatch() {
  Database db = Database(testDB);
  bool result = false;
  print('*****');

  db.open();

  result = db.beginBatch();

  print('Begin batch on $testDB > $result');

  result = db.endBatch();

  print('End batch on $testDB > $result');
}

testAccessors() {
  Database db = Database(testDB);
  print('*****');

  db.open();

  print('DB count > ' + db.count.toString());
}

const testjson = '''
{
  "TESTDOC": "THIS DOCUMENT IS RECREATED EVERY TIME THE APP RUNS",
    "int": 10,
    "double": 2.2,
    "bool": true,
    "string": "hello world!",
    "list": [
        1,
        "2",
        3.3
    ],
    "map": {
        "first": [1, 2,3],
        "second": "hello again",
        "third": false,
        "dart": {"is": "cool"}
    },
    "map1": {
        "list": [
            {"first": [1, 2, 3, 4]},
            {"second": [6, 7, 8]},
            true,
            10,
            2.5
        ]
    }
}
''';
