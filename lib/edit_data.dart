import 'dart:convert';
import 'dart:io';
import 'package:flutterworkingwithapi/list_data.dart';
import 'package:flutterworkingwithapi/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditData extends StatefulWidget {
  final int id;
  final String keterangan, masuk, keluar;
  const EditData(
      {Key? key, required this.id, required this.keterangan, required this.masuk, required this.keluar})
      : super(key: key);
  @override
  _EditDataState createState() => _EditDataState(id, keterangan, masuk, keluar);
}

class _EditDataState extends State<EditData> {
  int? id;
  String? keterangan, masuk;
  _EditDataState(int id, String keterangan, String masuk, String keluar) {
    this.id = id;
    this.keterangan = keterangan;
    this.masuk = masuk;
    //this.keluar = keluar;
    keteranganController.text = keterangan;
    masukController.text = masuk;
    keluarController.text = keluar;
  }
  final _formKey = GlobalKey<FormState>();
  final keteranganController = TextEditingController();
  final masukController = TextEditingController();
  final keluarController = TextEditingController();
  Future putData(int? id, String keterangan, String masuk, String keluar) async {
    // print(keterangan);
    String url = //Platform.isAndroid
        //? 'http://192.168.1.28/flutterworkingwithapi/index.php': 
        'http://localhost/flutterworkingwithapi/index.php';
    //String url = 'http://127.0.0.1/apiTrash/prosesLoginDriver.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"id":"$id","keterangan": "$keterangan", "masuk": "$masuk", "keluar": "$keluar"}';
    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to edit data');
    }
  }

  _buatInput(control, x,String hint) {
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
          title: const Text('Edit Catatan Keuangan'),
        ),
        drawer: const SideMenu(),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buatInput(keteranganController,TextInputType.text, 'Masukkan keterangan'),
                _buatInput(masukController, TextInputType.number,'Uang masuk'),
                _buatInput(keluarController, TextInputType.number,'Uang keluar'),
                ElevatedButton(
                  child: const Text('Edit Catatan'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String keterangan = keteranganController.text;
                      String masuk = masukController.text;
                      String keluar = keluarController.text;
                      // print(keterangan);
                      putData(id, keterangan, masuk, keluar).then((result) {
                        //print(result['pesan']);
                        if (result['pesan'] == 'berhasil') {
                          showDialog(
                              context: context,
                              builder: (context) {
                                //var keteranganuser2 = keteranganuser;
                                return AlertDialog(
                                  title: const Text('Data berhasil diupdate'),
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
