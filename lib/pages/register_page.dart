import 'package:chat_app/widgets/boton_azul.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/custom_input.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Logo(titulo: 'Registro',),
                _Form(),
                Labels(
                  ruta: 'login', 
                  titulo: '¿Ya tienes cuenta?', 
                  subTitulo: 'Inicia sesión ahora!',
                ),
                Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200))
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.person,
            placeHolder: 'Nombre',
            textController: nameController,
          ),

          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),

          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Contraseña',
            textController: passController,
            isPassword: true,
          ),
          // CustomInput(),

          BotonAzul(
            texto: 'Registrarse',
            onPressed: (){
              print(emailController.text);
              print(passController.text);
            },
          ),

        ],
      ),
    );
  }
}

