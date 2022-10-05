import 'package:flutter/material.dart';
import 'package:mukurewini/service/database_service.dart';

class RegisterVet extends StatefulWidget {
  String name;
  RegisterVet({required this.name});
  @override
  _RegisterVetState createState() => _RegisterVetState();
}

class _RegisterVetState extends State<RegisterVet> {
  final formKey = GlobalKey<FormState>();
  TextEditingController priceController = new TextEditingController();
  TextEditingController experienceController = new TextEditingController();
  //DatabaseMethods databaseMethods = new DatabaseMethods();

   String selected = '';
   String selectedHour ='';
  bool isLoading = false;
  Widget displayBoard() {
    List loan = [
      "Microbiology",
      "Nutrition",
      "Ophthalmology",
      "Pathology",
      "Surgery",
      "Theriogenology",
      "Toxicology"
    ];
    List<DropdownMenuItem> menuItemList = loan
        .map((val) => DropdownMenuItem(value: val, child: Text(val)))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.green, spreadRadius: 3),
          ],
        ),
        child: Card(
          child: DropdownButtonFormField(
            value: selected,
            validator: (value) =>
                value == null ? 'Please select specialization' : null,
            onChanged: (val) => setState(() => selected = val),
            items: menuItemList,
            hint: Text("choose specialization"),
          ),
        ),
      ),
    );
  }

  Widget showWorkingHours() {
    List loan = [
      "6AM - 6PM",
      "6PM - 6AM",
    ];
    List<DropdownMenuItem> menuItemList = loan
        .map((val) => DropdownMenuItem(value: val, child: Text(val)))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.green, spreadRadius: 3),
          ],
        ),
        child: Card(
          child: DropdownButtonFormField(
            value: selectedHour,
            validator: (value) =>
                value == null ? 'Please select working Hours' : null,
            onChanged: (val) => setState(() => selectedHour = val),
            items: menuItemList,
            hint: Text("choose working hours"),
          ),
        ),
      ),
    );
  }

  

  submitVetsDetails() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      print("done");
      Map<String, dynamic> userInfoMap = {
        'vet name': widget.name,
        "specialization": selected,
        "Charges": priceController.text,
        "working hours": selectedHour,
        "experience": experienceController.text,
      };

      //databaseMethods.uploadVetInfo(userInfoMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Veterinary Registration"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.green, spreadRadius: 3),
                      ],
                    ),
                    child: TextFormField(
                      validator: (val) {
                        return val!.isEmpty ? "Cannot be empty" : null;
                      },
                      initialValue: widget.name,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink, width: 2.0))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                displayBoard(),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.green, spreadRadius: 3),
                      ],
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        return val!.length > 5 || val.isEmpty
                            ? "Value cannot be more than 100"
                            : null;
                      },
                      controller: priceController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: 'charges per service?',
                          fillColor: Colors.white54,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink, width: 2.0))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.green, spreadRadius: 3),
                      ],
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        return val!.length > 2 || val.isEmpty
                            ? "Value cannot be more than this"
                            : null;
                      },
                      controller: experienceController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: 'Years of Experience?',
                          fillColor: Colors.white54,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink, width: 2.0))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                showWorkingHours(),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  
                  onPressed: () {
                    submitVetsDetails();
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
