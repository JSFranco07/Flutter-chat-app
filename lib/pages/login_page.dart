import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/helpers/mostrar_alerta.dart';

class LoginPage extends StatelessWidget {
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
                Logo(titulo: 'Messenger',),
                _Form(),
                Labels(
                  ruta: 'register', 
                  titulo: '¿No tienes cuenta?', 
                  subTitulo: 'Crea una ahora!',
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

  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: [

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
            texto: 'Ingrese',
            onPressed: (authService.autenticando) ? null : () async {
              FocusScope.of(context).unfocus();
              final loginOk = await authService.login(emailController.text.trim(), passController.text.trim());
              if (loginOk) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                mostrarAlerta(context, 'Login incorrecto', 'Revise sus credenciales nuevamente');
              }
            },
          ),

        ],
      ),
    );
  }
}

