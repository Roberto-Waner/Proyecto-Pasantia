﻿using System.Security.Claims;

namespace WebApi_OPRET.Repository.Models
{
    public class Model_Jwt
    {
        public string Key { get; set; }
        public string Issuer { get; set; }
        public string Audience { get; set; }
        public string Subject { get; set; }
    }
}
//public static dynamic validarToken(ClaimsIdentity identity)
//{
//    try
//    {
//        if (identity.Claims.Count() == 0)
//        {
//            return new
//            {
//                success = false,
//                Message = "Verificar si estas enviando un token valido",
//                result = ""
//            };
//        }

//        var id = identity.Claims.FirstOrDefault(x => x.Type == "id").Value;

//        UsuariosAdmin usurioAdmin = UsuariosAdmin.FirstOrDefault(x => x.IdUsuarioAdmin == id);

//        return new
//        {
//            success = true,
//            message = "Exito",
//            result = usurioAdmin
//        };
//    }
//    catch (Exception ex)
//    {
//        return new
//        {
//            success = false,
//            message = "Catch: " + ex.Message,
//            result = ""
//        };
//    }
//}