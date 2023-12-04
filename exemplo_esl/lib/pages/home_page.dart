import 'dart:convert';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:exemplo_esl/services/api_service.dart';
import 'package:exemplo_esl/pages/ap/ap_page.dart';
import 'package:exemplo_esl/pages/product/product_page.dart';
import 'package:exemplo_esl/pages/tag/tag_page.dart';
import 'package:exemplo_esl/pages/template/template_page.dart';
import 'package:exemplo_esl/pages/user_page.dart';
import 'package:exemplo_esl/classes/branch_class.dart';
import 'package:exemplo_esl/classes/company_class.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService api = ApiService();
  var pageIndex = 0;
  bool finished = false;
  int level = 0;
  var companyList = <Company>[];
  var branchList = <Branch>[];
  Company selectedCompany = Company(0, "Nome");
  Branch selectedBranch = Branch(0, "Nome", 0);

  @override
  void initState() {
    super.initState();
    getCompanies();
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (pageIndex) {
      case 0:
        page = ApPage(store: selectedBranch.id);
        break;
      case 1:
        page = ProductPage(store: selectedBranch.id);
        break;
      case 2:
        page = TagPage(store: selectedBranch.id);
        break;
      case 3:
        page = TemplatePage(store: selectedBranch.id);
        break;
      case 4:
        page = const UserPage();
        break;
      default:
        throw UnimplementedError('no widget for $pageIndex');
    }

    var mainArea = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: page,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Demo API ETIQUETAS TECTOY",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            finished
                ? Expanded(
                    child: Column(
                      children: [
                        Visibility(
                          visible: pageIndex != 4 && level <= 2,
                          child: SizedBox(
                            height: 95,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Visibility(
                                  visible: level == 1,
                                  child: SizedBox(
                                    width: 200,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          label: const Text("Empresa Logada"),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          )),
                                      value: selectedCompany.id == 0
                                          ? null
                                          : selectedCompany,
                                      items: companyList
                                          .map(
                                            (c) => DropdownMenuItem(
                                              value: c,
                                              child: Text(
                                                c.name,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) async {
                                        int c = value!.id;
                                        setState(() {
                                          finished = false;
                                          selectedCompany = value;
                                        });
                                        getBranches(c);
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: level == 1,
                                  child: const SizedBox(
                                    width: 30,
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        label: const Text("Filial Selecionada"),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        )),
                                    value: selectedBranch.id == 0
                                        ? null
                                        : selectedBranch,
                                    items: branchList
                                        .map(
                                          (b) => DropdownMenuItem(
                                            value: b,
                                            child: Text(
                                              b.name,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) async {
                                      setState(() {
                                        selectedBranch = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: mainArea),
                      ],
                    ),
                  )
                : const Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                  ),
            SafeArea(
              child: BottomNavigationBar(
                backgroundColor: const Color.fromARGB(255, 231, 231, 231),
                type: BottomNavigationBarType.fixed,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings_input_antenna,
                      size: 30,
                    ),
                    label: "Ponto de Acesso",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.shopping_cart,
                      size: 30,
                    ),
                    label: "Produtos",
                  ),
                  BottomNavigationBarItem(
                    icon: Transform.rotate(
                      angle: math.pi / 2,
                      child: const Icon(
                        Icons.book_online,
                        size: 30,
                      ),
                    ),
                    label: "Etiquetas",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.image,
                      size: 30,
                    ),
                    label: "Templates",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      size: 30,
                    ),
                    label: "Usuário",
                  ),
                ],
                selectedIconTheme: const IconThemeData(opacity: 1),
                selectedFontSize: 20,
                unselectedIconTheme: const IconThemeData(opacity: 0.4),
                unselectedFontSize: 20,
                currentIndex: pageIndex,
                onTap: (value) => {
                  setState(() {
                    pageIndex = value;
                  })
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getCompanies() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token').toString();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int l = decodedToken['userLevel'];
    int c;
    l == 1 ? c = 1 : c = decodedToken['userCompany'];
    http.Response cResponse;
    if (l == 1) {
      cResponse = await api.companyGetList();
      if (cResponse.statusCode == 200) {
        var cL = jsonDecode(cResponse.body);
        var companies = <Company>[];
        cL.forEach((co) {
          Company company = Company(co['id'], co['name']);
          companies.add(company);
        });
        setState(() {
          level = l;
          companyList = companies;
          selectedCompany = companies[0];
        });
        getBranches(c);
      } else {
        if (context.mounted) {
          api.requestError(context, cResponse);
        }
      }
    } else {
      cResponse = await api.companyGetInfo(c);
      if (cResponse.statusCode == 200) {
        var cL = jsonDecode(cResponse.body);
        var co = Company(cL['id'], cL['name']);
        setState(() {
          level = l;
          companyList.add(co);
          selectedCompany = co;
        });
        getBranches(c);
      } else {
        if (context.mounted) {
          api.requestError(context, cResponse);
        }
      }
    }
  }

  void getBranches(id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token').toString();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int l = decodedToken['userLevel'];
    int b;
    l == 1 ? b = 1 : b = decodedToken['userBranch'];
    http.Response bResponse;
    if (l <= 2) {
      bResponse = await api.branchGetList(id);
      if (bResponse.statusCode == 200) {
        var bL = jsonDecode(bResponse.body);
        var branches = <Branch>[];
        bL.forEach((br) {
          Branch branch = Branch(br['id'], br['name'], br['is_branch_id']);
          branches.add(branch);
        });
        setState(() {
          finished = true;
          branchList = branches;
          selectedBranch = branches[0];
        });
      } else {
        if (context.mounted) {
          api.requestError(context, bResponse);
        }
      }
    } else {
      bResponse = await api.branchGetInfo(b);
      if (bResponse.statusCode == 200) {
        var bL = jsonDecode(bResponse.body);
        var br = Branch(bL['id'], bL['name'], bL['is_branch_id']);
        setState(() {
          finished = true;
          branchList.add(br);
          selectedBranch = br;
        });
      } else {
        if (context.mounted) {
          api.requestError(context, bResponse);
        }
      }
    }
  }
}
