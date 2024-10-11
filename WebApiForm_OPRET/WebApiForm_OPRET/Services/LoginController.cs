using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using WebApiForm_OPRET.Repository;
using WebApiForm_OPRET.Repository.Models;
using WebApiForm_OPRET.Services.Modelos_Tokens;

namespace WebApiForm_OPRET.Services
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

        [HttpPost]
        [Route("User")]
        public async Task<IActionResult> InicioSesion([FromBody] Login_Model login)
        {
            string user = login.LoginUsuario;
            string password = login.LoginPasswords;

            Usuario modelUsuario = await _context.Usuarios.FirstOrDefaultAsync(x => x.Usuario1 == user && x.Passwords == password);

            if (modelUsuario == null)
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
                new Claim("id", modelUsuario.IdUsuarios),
                new Claim("usuario", modelUsuario.Usuario1),
                new Claim("cedula", modelUsuario.Cedula),
                new Claim("email", modelUsuario.Email),
                new Claim("rol", modelUsuario.Rol),
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
