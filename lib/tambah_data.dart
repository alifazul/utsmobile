import 'dart:convert';
import 'dart:io';
import 'package:flutterworkingwithapi/list_data.dart';
import 'package:flutterworkingwithapi/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);
  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final _formKey = GlobalKey<FormState>();
  final keteranganController = TextEditingController();
  final masukController = TextEditingController();
  final keluarController = TextEditingController();
  Future postData(String keterangan, String masuk, String keluar) async {
    // print(keterangan);
    String url = 
        'http://192.168.1.28/moneytracker/index.php';
      //  : 'http://localhost/flutterworkingwithapi/index.php';
    //String url = 'http://127.0.0.1/apiTrash/prosesLoginDriver.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"keterangan": "$keterangan", "masuk": "$masuk", "keluar": "$keluar",}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add data');
    }
  }

  _buatInput(control,x, String hint) {
    return TextFormField(
      controller: control,
      keyboardType: x,
      decoration: InputDecoration(
        hintText: hint,
      ),
      validator: (String? value) {
        return (value == null || value.isEmpty)
            ? "Please enter some text"
            : null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Catatan'),
        ),
        drawer: const SideMenu(),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buatInput(keteranganController,TextInputType.text, 'Masukkan keterangan'),
                _buatInput(masukController, TextInputType.number,'Masukkan uang masuk'),
                _buatInput(keluarController,TextInputType.number, 'Masukkan uang keluar'),
                ElevatedButton(
                  child: const Text('Tambah Catatan'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String keterangan = keteranganController.text;
                      String masuk = masukController.text;
                      String keluar = keluarController.text;
                      // print(keterangan);
                      postData(keterangan, masuk, keluar).then((result) {
                        //print(result['pesan']);
                        if (result['pesan'] == 'berhasil') {
                          showDialog(
                              context: context,
                              builder: (context) {
                                //var keteranganuser2 = keteranganuser;
                                return AlertDialog(
                                  title: const Text('Data berhasil ditambah'),
                                  // content: const Text('ok'),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.push(
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
                        setState(() {});
                      });
                    }
                  },
                ),
              ],
              // Tugas Kelompok • Lanjutkan untuk delete data, edit data, dan rea
            ),
          ),
        ));
  }
}
