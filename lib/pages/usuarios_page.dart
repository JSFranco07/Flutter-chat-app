import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';

class UsuariosPage extends StatefulWidget {

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uid: '1', nombre: 'María', email: 'test1@test.com', online: true),
    Usuario(uid: '2', nombre: 'Joan', email: 'test2@test.com', online: false),
    Usuario(uid: '3', nombre: 'Karoll', email: 'test3@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre, style: TextStyle(color: Colors.black54),),
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0.0,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black54,), 
          onPressed: (){
            //TODO: Desconectar el socket server
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          }
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.check_circle, color: Colors.blue[400],),
            // child: Icon(Icons.offline_bolt, color: Colors.red,),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400],
        ),
        onRefresh: _cargarUsuarios,
        child: _listViewUsuarios(),
      )
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (context, i) => Divider(), 
      itemBuilder: (context, i) => _usuarioListTile(usuarios[i]), 
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0,2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: (usuario.online) ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  void _cargarUsuarios() async{
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

}