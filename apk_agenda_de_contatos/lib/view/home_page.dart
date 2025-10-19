import 'dart:io';
import 'package:apk_agenda_de_contatos/database/helper/contact_helper.dart';
import 'package:apk_agenda_de_contatos/database/model/contact_model.dart';
import 'package:apk_agenda_de_contatos/view/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderAZ, orderZA }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agenda de Contatos",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              PopupMenuItem(
                value: OrderOptions.orderAZ,
                child: Text("Ordenar de A-Z"),
              ),
              PopupMenuItem(
                value: OrderOptions.orderZA,
                child: Text("Ordenar de Z-A"),
              ),
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null
                        ? FileImage(File(contacts[index].img!))
                        : AssetImage("assets/imgs/images.png") as ImageProvider,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? "",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      launch("tel: ${contacts[index].phone}");
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Ligar",
                      style: TextStyle(color: Colors.green, fontSize: 20.0),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showContactPage(contact: contacts[index]);
                    },
                    child: Text(
                      "Editar",
                      style: TextStyle(color: Colors.blue, fontSize: 20.0),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Confirmar exclusão"),
                            content: Text(
                              "Deseja excluir ${contacts[index].name}?",
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (contacts[index].id != null) {
                                    helper.deleteContact(contacts[index].id!);
                                  }
                                  setState(() {
                                    contacts.removeAt(index);
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Excluir",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Excluir",
                      style: TextStyle(color: Colors.red, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showContactPage({Contact? contact}) async {
    final updatedContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact)),
    );
    if (updatedContact != null) {
      setState(() {
        helper.getAllContacts().then((list) {
          setState(() {
            contacts = list;
          });
        });
      });
    }
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderAZ:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderZA:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
