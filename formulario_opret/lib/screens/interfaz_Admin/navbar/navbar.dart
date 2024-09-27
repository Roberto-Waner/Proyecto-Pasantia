import 'package:flutter/material.dart';
import 'package:formulario_opret/screens/interfaz_Admin/administrador_screen.dart';
// import 'package:formulario_opret/screens/navbar/editar_screen.dart';
import 'package:formulario_opret/screens/interfaz_Admin/navbar/pregunta_screen_navBar.dart';
import 'package:formulario_opret/screens/interfaz_Admin/navbar/registro_Empldo.dart';
// import 'package:formulario_opret/services/admin_services.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});
  // final String nombreUsuario;
  // final String email;

  // const Navbar({super.key, required this.nombreUsuario, required this.email});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  // late List<UsuarioAdministrador> data = [];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Creación del menú desplegable
      child: ListView(
        padding: EdgeInsets.zero, 
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text(/*widget.nombreUsuario*/ 'data'),
            accountEmail: const Text(/*widget.email*/'data'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/figuras/agregarfotos.png'),
              ),
            ),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(1, 135, 77, 0.344),
              image: DecorationImage(
                  image: AssetImage('assets/Fondo/metro2.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Color.fromRGBO(1, 135, 77, 0.344), BlendMode.srcATop)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_work_outlined, size: 30.0),
            title: const Text(
              'Home',
              style: TextStyle(fontSize: 20.0), // Aquí se cambia el tamaño del texto
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdministradorScreen())
              );
              // Navigator.of(context).pop();
            }
          ),
          ListTile(
            leading: const Icon(Icons.app_registration, size: 30.0),
            title: const Text(
              'Registro de Empleados',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistroEmpl())
              );
              // Navigator.of(context).pop();
            }
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings_outlined, size: 30.0),
            title: const Text(
              'Administradores',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () => print('Cargando la lista de Administradores ...'),
          ),
          ListTile(
            leading: const Icon(Icons.poll_outlined, size: 30.0),
            title: const Text(
              'Encuesta',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PreguntaScreenNavbar()),
              );
              // Navigator.of(context).pop();
            }
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined, size: 30.0),
            title: const Text(
              'Perfile',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => PagEdit(/*idAdmin: data*/))
              // );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, size: 30.0),
            title: const Text(
              'Cerrar Sesion',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () => print('Cerrando la Seccion del Usuario Administrador ...'),
          ),
      ]),
    );
  }
}