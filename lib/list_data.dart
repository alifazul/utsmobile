import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutterworkingwithapi/side_menu.dart';
import 'package:flutterworkingwithapi/tambah_data.dart';
import 'package:flutterworkingwithapi/edit_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListData extends StatefulWidget {
  const ListData({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataCatatan = [];
  String url = 
      //'http://192.168.1.28/moneytracker/index.php';
     'http://localhost/moneytracker/index.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if ((response.statusCode == 200) &&
        response.body != "Data catatan kosong.") {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataCatatan = List<Map<String, String>>.from(data.map((item) {
          return {
            'keterangan': item['keterangan'] as String,
            'masuk': item['masuk'] as String,
            'keluar': item['keluar'] as String,
            'id': item['id'] as String,
          };
        }));
      });
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('List Data Catatan'),
        ),
        drawer: const SideMenu(),
        body: Column(children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TambahData(),
                ),
              );
            },
            child: const Text('Tambah Data Catatan'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataCatatan.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dataCatatan[index]['keterangan']!),
                  subtitle: Text('masuk: ${dataCatatan[index]['masuk']} \nkeluar: ${dataCatatan[index]['keluar']} '),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          //lihatMahasiswa(index);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title:
                                    Text('${dataCatatan[index]['keterangan']}'),
                                    content: Text(
                                    'masuk : ${dataCatatan[index]['masuk']} \nkeluar: ${dataCatatan[index]['keluar']}',
                                    )
                                  );
                              });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          //editMahasiswa(index);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditData(
                                      id: int.parse(
                                          dataCatatan[index]['id']!),
                                          keterangan: '${dataCatatan[index]['keterangan']}',
                                          masuk: '${dataCatatan[index]['masuk']}',
                                          keluar: '${dataCatatan[index]['keluar']}')));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteData(int.parse(dataCatatan[index]['id']!))
                              .then((result) {
                            if (result['pesan'] == 'berhasil') {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Data berhasil dihapus'),
                                      // content: const Text('ok'),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ListData(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ]));
  }
}
