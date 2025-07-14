
import 'dart:io';
import 'package:failedtoconnect/driver-side_app/pages/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../methods/firstmethod.dart';
import '../mywidgets/loadingbar.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController CarModelTextEditingContoller = TextEditingController();
  TextEditingController CityTextEditingContoller = TextEditingController();
  XFile? ImageFile;
  String urlofuploadedimage = "";

  bool _passwordVisible = false;
  Methods_for_IntConnection cmethods = Methods_for_IntConnection();

  NetworkAvailabilty() {
    cmethods.checkConnectivity(context);
    if(ImageFile != null){
      SignUpFormValidation();
    }
    else{
      cmethods.showToastMessage("upload Image", context);
    }
  }

  SignUpFormValidation(){
    if(nameTextEditingController.text.trim().length<4 || !RegExp(r'^[a-z A-Z ]+$').hasMatch(nameTextEditingController.text.trim())){
      cmethods.showToastMessage("name must be above 4 characters or valid",context);
    }
    else if(phoneTextEditingController.text.trim().length<9 || !RegExp(r'^\d+$').hasMatch(phoneTextEditingController.text.trim())){
      cmethods.showToastMessage("Number Must be Valid or above 9 characters",context);
    }
    else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailTextEditingController.text)){
      cmethods.showToastMessage("Enter valid Email",context);
    }
    else if(passwordTextEditingController.text.trim().length<4){
      cmethods.showToastMessage("Enter Strong password", context);
    }else if (CarModelTextEditingContoller.text.trim().isEmpty || !RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(CarModelTextEditingContoller.text.trim())) {
      cmethods.showToastMessage("Enter valid car model", context);
    } else if (CityTextEditingContoller.text.trim().isEmpty || !RegExp(r'^[a-zA-Z ]+$').hasMatch(CityTextEditingContoller.text.trim())) {
      cmethods.showToastMessage("Enter valid city name", context);
    }
    else{
      uploadimagetofirebase();
    }
  }

  uploadimagetofirebase() async{
    String ImageIDName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceImage = FirebaseStorage.instance.ref().child("Images").child(ImageIDName);
    UploadTask uploadTask = referenceImage.putFile(File(ImageFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    urlofuploadedimage = await snapshot.ref.getDownloadURL();

    setState(() {
      urlofuploadedimage;
    });
    RegisterDrivers();
  }

  RegisterDrivers() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)=> Loadingbar(msg: "Please wait for registeration"),
    );

    final User? userfirebase = (
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim()
        ).catchError((ErrorMsg){
          cmethods.showToastMessage(ErrorMsg.toString(),context);
        }
        )
    ).user;
    if(!context.mounted)return;
    Navigator.pop(context);

    DatabaseReference UsersRef = FirebaseDatabase.instance.ref().child("Drivers").child(userfirebase!.uid);

    Map Driverdata =
    {
      "Name" : nameTextEditingController.text.trim(),
      "Email": emailTextEditingController.text.trim(),
      "Phoneno": phoneTextEditingController.text.trim(),
      "Picture":urlofuploadedimage,
      "City" : CityTextEditingContoller.text.trim(),
      "Car Model": CarModelTextEditingContoller.text.trim(),
      "id" : userfirebase.uid,
      "AccountStatus": "No",
    };

    UsersRef.set(Driverdata);

    Navigator.push(context, MaterialPageRoute(builder: (c)=>dashboard()));
  }

  ChooseImageFromGallery() async{

    final pickedfile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(pickedfile!=null){
      setState(() {
        ImageFile=pickedfile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),

                ImageFile == null?
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.pink,
                ) : Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: FileImage(
                            File(
                              ImageFile!.path,
                            ),
                          )
                      )
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                GestureDetector(
                  onTap: (){
                    ChooseImageFromGallery();
                  },
                  child: const Text(
                    "Choose Image",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF093E67), // Changed color to dark blue
                    ),
                  ),
                ),

                // Text Field (Allows user to enter text)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Driver's Name",
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7A7777), // Changed color to dark blue
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF152A8C), // Changed color to dark blue
                        ),
                      ),

                      SizedBox(height: 5,),

                      TextField(
                        controller: phoneTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7A7777), // Changed color to dark blue
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF152A8C), // Changed color to dark blue
                        ),
                      ),

                      SizedBox(height: 5,),

                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7A7777), // Changed color to dark blue
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF152A8C), // Changed color to dark blue
                        ),
                      ),

                      SizedBox(height: 5,),

                      TextField(
                        controller: passwordTextEditingController,
                        obscureText: !_passwordVisible,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7A7777), // Changed color to dark blue
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Color(0xFF152A8C), // Changed color to dark blue
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF152A8C), // Changed color to dark blue
                        ),
                      ),

                      SizedBox(height: 5),

                      TextField(
                        controller: CarModelTextEditingContoller,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Car Model",
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7A7777), // Changed color to dark blue
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF152A8C), // Changed color to dark blue
                        ),
                      ),

                      SizedBox(height: 5),

                      TextField(
                        controller: CityTextEditingContoller,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "City",
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7A7777), // Changed color to dark blue
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF152A8C), // Changed color to dark blue
                        ),
                      ),

                      ElevatedButton(
                        onPressed: (){
                          NetworkAvailabilty();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF06295E), // Changed color to dark blue
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // TextButton
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                  },
                  child: Text(
                    "Already have an account? Login here",
                    style: TextStyle(
                      color: Color(0xFF061450), // Changed color to dark blue
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}





