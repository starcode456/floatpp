import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:float/models/submittedResource.dart';
import 'package:float/models_services/resources_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SubmitResource extends StatefulWidget {
  @override
  _SubmitResourceState createState() => _SubmitResourceState();
}

class _SubmitResourceState extends State<SubmitResource> {
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TextEditingController> controllers =
      List<TextEditingController>.generate(
          2, (generator) => TextEditingController());
  bool enableSubmit = false;
  submitResource() async {
    setState(() {
      isLoading = true;
    });
    SubmittedResource submittedResource = SubmittedResource(
      dateSubmitted: Timestamp.now(),
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      subject: controllers[0].text,
      title: controllers[1].text,
    );
    bool result = await ResourceHelper().submitResource(submittedResource);
    setState(() {
      isLoading = false;
    });
    if (result) {
      Get.back();
    } else {
      Get.snackbar(
          'An error occured', 'Check your internet connection and try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white30,
          elevation: 0,
          title: Text(
            "Submit a book title",
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                  color: Color(0xff4a4a4a),
                  fontSize: 24,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700),
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
                onPressed: () => Get.back()),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Container(
                      //  height: 120,
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        textField(0),
                        SizedBox(
                          height: 20,
                        ),
                        textField(1),
                        SizedBox(
                          height: 80,
                        ),
                        Text(
                          "Thank you so much for submitting a resource. We will do our best to get the resource up on float as quickly as possible. Thanks again",
                          style: GoogleFonts.lato(
                            color: const Color(0xffb0b2be),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            if (controllers[0].text.isNotEmpty &&
                                controllers[1].text.isNotEmpty) {
                              submitResource();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: controllers[0].text.isEmpty ||
                                      controllers[1].text.isEmpty
                                  ? Color(0xfff0eaea)
                                  : Color(0xff3d97eb),
                              borderRadius: BorderRadius.circular(31.5),
                            ),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Center(
                              child: Text(
                                "Submit",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    color: controllers[0].text.isEmpty ||
                                            controllers[1].text.isEmpty
                                        ? Color(0xffc3c3c3)
                                        : Colors.white,
                                    fontSize: 22,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(int conNum) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.transparent));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        onChanged: (val) {
          if (controllers[0].text.isNotEmpty &&
              controllers[1].text.isNotEmpty) {
            setState(() {
              enableSubmit = true;
            });
          } else {
            setState(() {
              enableSubmit = false;
            });
          }
        },
        controller: controllers[conNum],
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: new BorderSide(color: Color(0xffd0d0d0), width: 0.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Color(0xffd0d0d0), width: 0.7),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Color(0xffd0d0d0), width: 0.7),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Color(0xffd0d0d0), width: 0.7),
            //   borderRadius: new BorderRadius.circular(25.7),
          ),
          hintText: conNum == 0 ? 'Subject' : 'Title of resource',
          hintStyle: GoogleFonts.lato(
            textStyle: GoogleFonts.lato(
                color: Color(0xff8c8c8c),
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400),
          ),
        ),
        style: GoogleFonts.lato(
            color: Color(0xff4a4a4a),
            fontSize: 20,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
