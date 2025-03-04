import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formulario_opret/screens/forgotPassword_screen.dart';

class ResertpasswordScreen extends StatefulWidget {
  final TextEditingController filtrarUsuarioController;
  final TextEditingController filtrarEmailController;
  final TextEditingController filtrarId;

  const ResertpasswordScreen({
    super.key,
    required this.filtrarUsuarioController,
    required this.filtrarEmailController,
    required this.filtrarId,
  });

  @override
  State<ResertpasswordScreen> createState() => _ResertpasswordScreenState();
}

class _ResertpasswordScreenState extends State<ResertpasswordScreen> {
  final _formkey = GlobalKey<FormBuilderState>();
  bool _obscureText = true;

  bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTabletWidth = size.width > 600;
    final isTabletHeight = size.height > 800;
    return isTabletWidth && isTabletHeight;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTabletDevice = isTablet(context);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF159957),
                Color(0xFF155799),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(5, 20),
              ),
            ],
          ),
          child: Stack(
            // alignment: AlignmentDirectional.topStart,
            children: [
              Padding( // Padding para el contenedor principal
                padding: isTabletDevice ? const EdgeInsets.all(50.0) : const EdgeInsets.all(30.0),
                // padding: const EdgeInsets.all(40.0),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      Container( // Contenedor del logo
                        margin: const EdgeInsets.only(top: 50),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle, // El logo estará dentro de un contenedor circular
                          color: Color.fromRGBO(255, 254, 254, 1),
                        ),
                        child: Padding(
                          padding: isTabletDevice ? const EdgeInsets.all(50.0) : const EdgeInsets.all(30.0), // Margen dentro del logo
                          // padding: EdgeInsets.all(20.0),
                          child: const Icon(
                            Icons.lock_reset_outlined, // Icono de un candado
                            size: 100, // Tamaño del icono
                            color: Color.fromARGB(255, 12, 0, 0), // Color del icono
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "Recupera tu cuenta", // Título de la pantalla
                        style: TextStyle(
                          fontSize: 40, // Tamaño de la fuente
                          fontWeight: FontWeight.bold, // Peso de la fuente
                          color: Color.fromARGB(255, 255, 255, 255), // Color de la fuente
                        ),
                      ),
                      const SizedBox(height: 20),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Container( //Para el cuadro blanco
                            padding: const EdgeInsets.all(80),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 252, 252),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(5, 20),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [                      
                                const Text(
                                  "Paso 2: Crea una nueva contraseña", // Título de la pantalla
                                  style: TextStyle(
                                    fontSize: 40, // Tamaño de la fuente
                                    fontWeight: FontWeight.bold, // Peso de la fuente
                                    color: Color.fromARGB(255, 12, 0, 0), // Color de la fuente
                                  ),
                                ),
                                const SizedBox(height: 80),
                                  
                                FormBuilder(
                                  key: _formkey,
                                  child: Column(
                                    children: [
                                      FormBuilderTextField(
                                        name: 'token',
                                        decoration: InputDecoration(
                                          labelText: 'Código de verificación',
                                          labelStyle: TextStyle(fontSize: isTabletDevice ? 15.sp : 13.sp),
                                          hintText: 'Ingresa el código de verificación',
                                          hintStyle: TextStyle(fontSize: isTabletDevice ? 10.sp : 10.sp, color: const Color.fromARGB(255, 138, 138, 138)),
                                          prefixIcon: Icon(Icons.vpn_key_outlined, size: isTabletDevice ? 15.sp : 15.sp),
                                          border: const OutlineInputBorder(),
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromARGB(255, 39, 99, 41)),
                                          ),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(255, 12, 0, 0), // Color del borde
                                            ),
                                          ),
                                          errorStyle: TextStyle(fontSize: isTabletDevice ? 10.sp : 10.sp,),
                                        ),
                                        style: TextStyle(fontSize: isTabletDevice ? 10.sp : 10.sp, color: const Color.fromARGB(255, 1, 1, 1)),
                                        keyboardType: TextInputType.text,// Tipo de teclado
                                        validator: FormBuilderValidators.required(errorText: 'Este campo es requerido'),
                                      ),                              
                                      const SizedBox(height: 30), // Separación entre el campo de texto y el botón
                                                  
                                      FormBuilderTextField(
                                        name: 'password',
                                        decoration: InputDecoration(
                                          labelText: 'Nueva contraseña',
                                          labelStyle: TextStyle(fontSize: isTabletDevice ? 15.sp : 13.sp),
                                          hintText: 'Ingresa tu nueva contraseña',
                                          hintStyle: TextStyle(fontSize: isTabletDevice ? 10.sp : 10.sp, color: const Color.fromARGB(255, 138, 138, 138)),
                                          prefixIcon: Icon(Icons.lock_outline_rounded, size: isTabletDevice ? 15.sp : 15.sp),
                                          border: const OutlineInputBorder(),
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromARGB(255, 39, 99, 41)),
                                          ),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(255, 12, 0, 0), // Color del borde
                                            ),
                                          ),
                                          errorStyle: TextStyle(fontSize: isTabletDevice ? 10.sp : 10.sp,),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureText ? Icons.visibility_off : Icons.visibility,
                                              color: const Color.fromARGB(255, 138, 138, 138),
                                              size: isTabletDevice ? 15.sp : 15.sp,
                                            ),
                                            onPressed: _togglePasswordVisibility,
                                          ),
                                        ),
                                        style: TextStyle(fontSize: isTabletDevice ? 10.sp : 10.sp, color: const Color.fromARGB(255, 1, 1, 1)),
                                        keyboardType: TextInputType.text,// Tipo de teclado
                                        validator: FormBuilderValidators.required(errorText: 'Este campo es requerido'),
                                      ),

                                      const SizedBox(height: 30),

                                      FormBuilderTextField(
                                        name: 'password-confirm',
                                        decoration: InputDecoration(
                                          labelText: 'Confirmar contraseña',
                                          labelStyle: TextStyle(fontSize: isTabletDevice ? 15.sp : 13.sp),
                                          hintText: 'Confirma tu nueva contraseña',
                                          hintStyle: TextStyle(fontSize: isTabletDevice ? 10.sp : 10.sp, color: const Color.fromARGB(255, 138, 138, 138)),
                                          prefixIcon: Icon(Icons.lock_outline_rounded, size: isTabletDevice ? 15.sp : 15.sp),
                                          border: const OutlineInputBorder(),
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromARGB(255, 39, 99, 41)),
                                          ),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(255, 12, 0, 0), // Color del borde
                                            ),
                                          ),
                                          errorStyle: TextStyle(fontSize: isTabletDevice ? 10.sp : 10.sp,),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureText ? Icons.visibility_off : Icons.visibility,
                                              color: const Color.fromARGB(255, 138, 138, 138),
                                              size: isTabletDevice ? 15.sp : 15.sp,
                                            ),
                                            onPressed: _togglePasswordVisibility,
                                          ),
                                        ),
                                        style: TextStyle(fontSize: isTabletDevice ? 10.sp : 10.sp, color: const Color.fromARGB(255, 1, 1, 1)),
                                        keyboardType: TextInputType.text,// Tipo de teclado
                                        validator: FormBuilderValidators.required(errorText: 'Este campo es requerido'),
                                      ),
                                                              
                                      Container(
                                        padding: isTabletDevice ?  EdgeInsets.symmetric(horizontal: 33.h, vertical: 10.w) : EdgeInsets.symmetric(horizontal: 5.h, vertical: 10.w),
                                        // padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                        margin: const EdgeInsets.only(top: 100),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 16, 110, 63),
                                              Color(0xFF155799),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(100),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10,
                                              offset: Offset(5, 20),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent, // Fondo transparente para mostrar el degradado
                                            shadowColor: Colors.transparent, // Evitar sombras que cubran el degradado
                                            foregroundColor: const Color.fromARGB(255, 254, 255, 255),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(100)), // Borde redondeado
                                            ),
                                          ),
                                          child: Text(
                                            'Restablecer contraseña',
                                            style: TextStyle(
                                              fontSize: isTabletDevice ? 15.5.sp : 17.sp,
                                              fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                                              
                                      Container(
                                        // padding: isTabletDevice ?  EdgeInsets.symmetric(horizontal: 60.h, vertical: 10.w) : EdgeInsets.symmetric(horizontal: 37.h, vertical: 15.w),
                                        padding: isTabletDevice ?  EdgeInsets.symmetric(horizontal: 33.h, vertical: 10.w) : EdgeInsets.symmetric(horizontal: 5.h, vertical: 10.w),
                                        margin: const EdgeInsets.only(top: 30),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF155799),
                                              Color.fromARGB(255, 16, 110, 63),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(100),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: isTabletDevice ? 17.sp : 17.sp,
                                              offset: const Offset(5, 20),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ForgotpasswordScreen(
                                                filtrarUsuarioController: widget.filtrarUsuarioController,
                                                filtrarEmailController: widget.filtrarEmailController,
                                                filtrarId: widget.filtrarId,
                                              ))
                                            );
                                          }, 
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent, // Fondo transparente para mostrar el degradado
                                            shadowColor: Colors.transparent, // Evitar sombras que cubran el degradado
                                            foregroundColor: const Color.fromARGB(255, 254, 255, 255),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(100)), // Borde redondeado
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min, // Para que el Row no ocupe todo el espacio
                                            children: [
                                              const Icon(
                                                Icons.arrow_back_ios_new_rounded,
                                                //size: isTabletDevice ? 14.sp : 17.sp,
                                              ),
                                              const SizedBox(width: 5), // Espacio entre el ícono y el texto
                                              Text(
                                                'Volver al paso anterior',
                                                style: TextStyle(
                                                  //fontSize: isTabletDevice ? 17.sp : 17.sp,
                                                  fontSize: isTabletDevice ? 15.sp : 17.sp,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}