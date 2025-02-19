import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<dynamic> products = [];
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _price = TextEditingController();

//Key
  final GlobalKey<FormState> _formkey2 = GlobalKey<FormState>();
  final TextEditingController _name2 = TextEditingController();
  final TextEditingController _desc2 = TextEditingController();
  final TextEditingController _price2 = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchData();
    print(products);
  }

  Future<void> fetchData() async {
    try {
      var response = await http.get(Uri.parse('http://10.0.2.2:8001/products'));
      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
        });
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createProduct() async {
    try {
      var response = await http.post(Uri.parse("http://10.0.2.2:8001/products"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "name": _name.text,
            "description": _desc.text,
            "price": double.parse(_price.text)
          }));
      if (response.statusCode == 201) {
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print(e);
    }
    fetchData();
  }

  Future<void> updateProduct(dynamic idUpdate) async {
    try {
      var response =
          await http.put(Uri.parse("http://10.0.2.2:8001/products/$idUpdate"),
              headers: {
                "Content-Type": "application/json",
              },
              body: jsonEncode({
                "name": _name2.text,
                "description": _desc2.text,
                "price": double.parse(_price2.text)
              }));
      if (response.statusCode == 200) {
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print(e);
    }
    fetchData();
  }

  Future<void> deleteProduct(dynamic idDelete) async {
    try {
      var response = await http
          .delete(Uri.parse("http://10.0.2.2:8001/products/$idDelete"));
      if (response.statusCode == 200) {
      } else {
        throw Exception("Failed to delete products");
      }
    } catch (e) {
      print(e);
    }
    fetchData();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3), // Adjust duration if needed
        behavior: SnackBarBehavior
            .floating, // Makes it appear above bottom navigation
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text("Product"),
        backgroundColor: Colors.lightGreen,
      ),
      body: SlidableAutoCloseBehavior(
        child: ListView.separated(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Slidable(
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {},
                    backgroundColor: Colors.black45,
                    foregroundColor: Colors.white,
                    icon: Icons.pending,
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      _name2.text = products[index]["name"];
                      _desc2.text = products[index]["description"];
                      _price2.text = '${products[index]["price"]}';
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                                  child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Edit Product",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Form(
                                      key: _formkey2,
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Product Name",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          TextFormField(
                                            controller: _name2,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0))),
                                                labelText:
                                                    'Enter Name of Product'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return '*Please Enter Name of Product';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            "Product Description",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          TextFormField(
                                            controller: _desc2,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0))),
                                                labelText:
                                                    'Enter Description of Product'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return '*Please Enter Description of Product';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            "Product Price",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          TextFormField(
                                            controller: _price2,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0))),
                                                labelText:
                                                    'Enter Price of Product'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return '*Please Enter Name of Price';
                                              }
                                              if (double.tryParse(value) ==
                                                  null) {
                                                return '*Please Enter Number';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        if (_formkey2
                                                            .currentState!
                                                            .validate()) {
                                                          updateProduct(
                                                              products[index]
                                                                  ['id']);
                                                          Navigator.pop(
                                                              context);

                                                          _name2.text = "";
                                                          _desc2.text = "";
                                                          _price2.text = "";

                                                          _showSnackBar(context,
                                                              "Data is updated");
                                                        }
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.green[
                                                                      900]),
                                                      child: const Text(
                                                        'Save',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))),
                                              Expanded(
                                                  flex: 1,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        _name2.text = "";
                                                        _desc2.text = "";
                                                        _price2.text = "";
                                                      },
                                                      child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black))))
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )));
                    },
                    backgroundColor: const Color.fromARGB(206, 255, 119, 0),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Delete Data',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w400)),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                deleteProduct(
                                                    products[index]['id']);
                                                Navigator.pop(context);
                                                _showSnackBar(
                                                    context, "Data is deleted");
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ));
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete_outline_outlined,
                  ),
                ],
              ),
              child: Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: Text('${index + 1}'),
                    title: Text(products[index]['name']),
                    subtitle: Text(products[index]['description']),
                    trailing: Text('${products[index]['price']}',
                        style: const TextStyle(color: Colors.green)),
                    onTap: () {},
                  )),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                      child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "New Product",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              const Text(
                                "Product Name",
                                style: TextStyle(fontSize: 16),
                              ),
                              TextFormField(
                                controller: _name,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    labelText: 'Enter Name of Product'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '*Please Enter Name of Product';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Product Description",
                                style: TextStyle(fontSize: 16),
                              ),
                              TextFormField(
                                controller: _desc,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    labelText: 'Enter Description of Product'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '*Please Enter Description of Product';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Product Price",
                                style: TextStyle(fontSize: 16),
                              ),
                              TextFormField(
                                controller: _price,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    labelText: 'Enter Price of Product'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '*Please Enter Name of Price';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return '*Please Enter Number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              createProduct();
                                              Navigator.pop(context);
                                              _name.text = "";
                                              _desc.text = "";
                                              _price.text = "";

                                              _showSnackBar(
                                                  context, "Data is created");
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.green[900]),
                                          child: const Text(
                                            'Save',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))),
                                  Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _name.text = "";
                                            _desc.text = "";
                                            _price.text = "";
                                          },
                                          child: const Text('Cancel',
                                              style: TextStyle(
                                                  color: Colors.black))))
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )));
        },
        backgroundColor: Colors.lightGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
