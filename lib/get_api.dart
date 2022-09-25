import 'dart:convert';
import 'dart:developer';
import 'package:lottie/lottie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetApi extends StatefulWidget {
  const GetApi({Key? key}) : super(key: key);

  @override
  State<GetApi> createState() => _GetApiState();
}

class _GetApiState extends State<GetApi> {
  String statement = '';
  String punchline = '';
  bool loading = false;
  bool showPunch = false;
  bool networkError = false;

  getData() async {
    try {
      networkError = false;
      showPunch = false;
      loading = true;
      log('api calling.....');
      setState(() {});
      var api = "https://official-joke-api.appspot.com/random_joke";

      var response = await http
          .get(
            Uri.parse(api),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        statement = data['setup'];
        punchline = data['punchline'];
        if (kDebugMode) {
          print(response.statusCode);
          print(data);
          print(statement);
          print(punchline);
        }
      } else {
        if (kDebugMode) {
          print(response.statusCode);
          print('server error');
        }
      }
      loading = false;
      log('api end.....');
      setState(() {});
    } catch (error) {
      loading = false;
      networkError = true;
      debugPrint('Network Error');
      debugPrint(error.toString());
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Lottie.asset(
                'assets/images/gradient-animated-background.json',
                fit: BoxFit.cover),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Center(
              child: networkError
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                            'assets/lotti_files/network-error-super-hero.json',
                            height: 300),
                        const Text(
                          'Please check Your Internet Connection', textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            getData();
                          },
                          child: loading
                              ? Lottie.asset('assets/lotti_files/loading.json',
                                  height: 70)
                              : const Text(
                                  'Refresh',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          statement,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showPunch = true;
                            });
                          },
                          child: showPunch
                              ? Column(
                                  children: [
                                    Text(
                                      punchline,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                    Lottie.asset(
                                        'assets/lotti_files/einstein_funny.json',
                                        height: 150),
                                  ],
                                )
                              : Container(
                                  width: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.greenAccent,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'click',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            color: Colors.blueGrey),
                                      ),
                                      Text(
                                        ' >>Punchline<< ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.deepOrangeAccent),
                                      ),
                                      Text(
                                        'click',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            getData();
                          },
                          child: loading
                              ? Lottie.asset('assets/lotti_files/loading.json',
                                  height: 70)
                              : const Text(
                                  'Try New',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    ));
  }
}
