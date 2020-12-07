import 'dart:io';

import 'package:chat_app/models/mensajes_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    this.chatService   = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService   = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial( this.chatService.usuarioPara.uid);

  }

  void _cargarHistorial( String usuarioID) async {

    List<Mensaje> chat = await this.chatService.getChat(usuarioID);

    final historial = chat.map((m) => ChatMessage(
      texto: m.mensaje,
      uid: m.de,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward(),
    ));

    setState(() {
      _messages.insertAll(0, historial);
    });

  }

  void _escucharMensaje( dynamic payload){
    
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300))
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();

  }

  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(usuarioPara.nombre.substring(0,2), style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3.0,),
            Text(usuarioPara.nombre, style: TextStyle(color: Colors.black87, fontSize: 12.0),)
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, i) => _messages[i],
              ),
            ),
            Divider(height: 1.0,),
            //TODO:Caja texto
            Container(
              color: Colors.white,
              child: _inputChat(),
            ),
          ],
        ),
      )
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (value){
                  setState(() {  
                    (value.trim().length > 0)
                      ? _estaEscribiendo = true
                      : _estaEscribiendo = false;
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Envar mensaje'
                ),
                focusNode: _focusNode,
              ),
            ),

            //Botón de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                ? CupertinoButton(
                  child: Text('Enviar'), 
                  onPressed: _estaEscribiendo
                    ? () => _handleSubmit(_textController.text.trim())
                    : null 
                )
                : Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconTheme(
                    data: IconThemeData(
                      color: Colors.blue[400],
                    ),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.send,) ,
                      onPressed: _estaEscribiendo
                        ? () => _handleSubmit(_textController.text.trim())
                        : null 
                    ),
                  ),
                ),
            )

          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto){

    if (texto.length==0) return;

    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(
      uid: authService.usuario.uid, 
      texto: texto,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() { _estaEscribiendo = false; });

    this.socketService.emit('mensaje-personal', {
      'de': this.authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto
    });

  }

  @override
  void dispose() {
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}