import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:chat_app_firebase/widgets/user_image_picker.dart';

const chatIcon = "assets/images/chat.png";
final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  var _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  var _userEmail = "";
  var _userName = "";
  var _password = "";
  File? _selectedImage;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid && _selectedImage != null) {
      _formKey.currentState?.save();
      try {
        setState(() {
          _isLoading = true;
        });

        if (_isLogin) {
          final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _userEmail,
            password: _password,
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Authentication Success.'),
              ),
            );
          }
        } else {
          if (_selectedImage == null) {
            return;
          }

          final userCredentials =
              await _firebase.createUserWithEmailAndPassword(
            email: _userEmail,
            password: _password,
          );

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child('${userCredentials.user!.uid}.jpg');

          await storageRef.putFile(_selectedImage!);
          final imageUrl = await storageRef.getDownloadURL();

          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredentials.user!.uid)
              .set({
            'userName': _userName,
            'email': _userEmail,
            'imageUrl': imageUrl,
          });
        }
      } on FirebaseAuthException catch (error) {
        setState(() {
          _isLoading = false;
        });
        if (
            // error.code == 'email-already-in-use' &&
            context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error.message ?? 'Authentication failed. User already present.',
              ),
            ),
          );
        }
      }
    }
  }

  void _onSelectImage(File imageFile) {
    _selectedImage = imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                padding: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                child: Image.asset(chatIcon),
              ),
              if (!_isLogin) UserImagePicker(onImageSelected: _onSelectImage),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Email Address"),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }

                            return null;
                          },
                          onSaved: (newValue) {
                            _userEmail = newValue!.trim();
                          },
                        ),
                        if (!_isLogin)
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text("User Name"),
                            ),
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.trim().length < 4) {
                                return 'Please enter a valid user name';
                              }

                              return null;
                            },
                            onSaved: (newValue) {
                              _userName = newValue!.trim();
                            },
                          ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Password"),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be at least 6 characters';
                            }

                            return null;
                          },
                          onSaved: (newValue) {
                            _password = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (_isLoading)
                          const CircularProgressIndicator()
                        else ...[
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Text(
                              _isLogin ? 'Sign In' : 'Sign Up',
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? 'Create an Account'
                                  : 'I already have an account',
                            ),
                          )
                        ],
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
