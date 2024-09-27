using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using WebApi_OPRET.Repository;
using WebApi_OPRET.Repository.Models;

namespace WebApi_OPRET.Services
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly FormEncuestaDbContext _context;

        public LoginController (IConfiguration config, FormEncuestaDbContext context)
        {
            _config = config;
            _context = context;
        }

        //[HttpPost]
        //[Route("LoginAdmin")]
        //public async Task<IActionResult> IniciarSesion([FromBody] LoginAdminModel loginData)
        //{
        //    string user = loginData.NombreUsuarioAdmin;
        //    string password = loginData.PasswordsAdmin;

        //    // Buscar al administrador en la base de datos usando el contexto
        //    UsuariosAdmin admin = await _context.UsuariosAdmins.FirstOrDefaultAsync(x => x.NombreUsuarioAdmin == user && x.PasswordsAdmin == password);

        //    if (admin == null)
        //    {
        //        return Unauthorized(new
        //        {
        //            success = false,
        //            message = "Credenciales incorrectas",
        //            result = ""
        //        });
        //    }

        //    // Obtén la configuración del JWT desde el archivo de configuración
        //    var jwtConfig = _config.GetSection("Jwt").Get<Model_Jwt>();

        //    // Crear los claims del token
        //    var claims = new[]
        //    {
        //        new Claim(JwtRegisteredClaimNames.Sub, jwtConfig.Subject),
        //        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
        //        new Claim(JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
        //        new Claim("id", admin.IdUsuarioAdmin),
        //        new Claim("usuario", admin.NombreUsuarioAdmin),
        //        new Claim("rol", admin.Rol)
        //    };

        //    // Crear la clave de seguridad usando la clave desde la configuración
        //    var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtConfig.Key));
        //    var signIn = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        //    // Generar el token JWT
        //    var token = new JwtSecurityToken(
        //        issuer: jwtConfig.Issuer,
        //        audience: jwtConfig.Audience,
        //        claims: claims,
        //        expires: DateTime.Now.AddMinutes(60), //1 hora, tiempo de expiracion del token, en coso de no desea que se expire simplemente no poner fecha de expiracion
        //        signingCredentials: signIn
        //    );

        //    var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

        //    return Ok(new
        //    {
        //        success = true,
        //        message = "!!!Inicio de sesion exitoso!!!",
        //        result = tokenString
        //    });
        //}

        [HttpPost]
        [Route("LoginEmpl")]
        public async Task<IActionResult> IniciarSesionEmpl([FromBody] LoginEmpleadoModel loginEmplData)
        {
            string userEmpl = loginEmplData.NombreUsuarioEmpl;
            string passwordEmpl = loginEmplData.PasswordsEmpl;

            UsuariosEmpl usuariosEmplModel = await _context.UsuariosEmpls.FirstOrDefaultAsync(x => x.NombreUsuarioEmpl == userEmpl && x.PasswordsEmpl == passwordEmpl);

            if (usuariosEmplModel == null)
            {
                return Unauthorized(new
                {
                    success = false,
                    message = "Credenciales incorrectas",
                    result = ""
                });
            }

            var jwtConfig = _config.GetSection("Jwt").Get<Model_Jwt>();

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, jwtConfig.Subject),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
                new Claim("id", usuariosEmplModel.IdUsuarioEmpl),
                new Claim("usuario", usuariosEmplModel.NombreUsuarioEmpl),
                new Claim("cedula", usuariosEmplModel.CedlEmpleado),
                new Claim("email", usuariosEmplModel.EmailEmpl),
                new Claim("rol", usuariosEmplModel.Rol)
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtConfig.Key));
            var signIn = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken
            (
                issuer: jwtConfig.Issuer,
                audience: jwtConfig.Audience,
                claims: claims,
                //expires: DateTime.Now.AddMinutes(60),
                signingCredentials: signIn
            );

            var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

            return Ok(new
            {
                success = true,
                message = "!!!Inicio de sesion exitoso!!!",
                result = tokenString,
            });
        }
    }
}
