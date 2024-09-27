using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using WebApi_OPRET.Repository;
using WebApi_OPRET.Repository.Models;

namespace WebApi_OPRET.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuariosAdminsController : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly FormEncuestaDbContext _context;

        public UsuariosAdminsController(FormEncuestaDbContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        // GET: api/UsuariosAdmins
        
        [HttpGet]
        public async Task<ActionResult<IEnumerable<UsuariosAdmin>>> GetUsuariosAdmins()
        {
            return await _context.UsuariosAdmins.ToListAsync();
        }

        // GET: api/UsuariosAdmins/5
        
        [HttpGet("{id}")]
        public async Task<ActionResult<UsuariosAdmin>> GetUsuariosAdmin(string id)
        {
            var usuariosAdmin = await _context.UsuariosAdmins.FindAsync(id);

            if (usuariosAdmin == null)
            {
                return NotFound();
            }

            return usuariosAdmin;
        }

        // PUT: api/UsuariosAdmins/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUsuariosAdmin(string id, UsuariosAdmin usuariosAdmin)
        {
            if (id != usuariosAdmin.IdUsuarioAdmin)
            {
                return BadRequest();
            }

            _context.Entry(usuariosAdmin).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UsuariosAdminExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/UsuariosAdmins
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        
        [HttpPost]
        public async Task<ActionResult<UsuariosAdmin>> PostUsuariosAdmin(UsuariosAdmin usuariosAdmin)
        {
            _context.UsuariosAdmins.Add(usuariosAdmin);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (UsuariosAdminExists(usuariosAdmin.IdUsuarioAdmin))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetUsuariosAdmin", new { id = usuariosAdmin.IdUsuarioAdmin }, usuariosAdmin);
        }

        // DELETE: api/UsuariosAdmins/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUsuariosAdmin(string id)
        {
            var usuariosAdmin = await _context.UsuariosAdmins.FindAsync(id);
            if (usuariosAdmin == null)
            {
                return NotFound();
            }

            _context.UsuariosAdmins.Remove(usuariosAdmin);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool UsuariosAdminExists(string id)
        {
            return _context.UsuariosAdmins.Any(e => e.IdUsuarioAdmin == id);
        }

        //-------------------------------Login Administrador--------------------------

        [HttpPost]
        [Route("login")]
        public async Task<IActionResult> IniciarSesion([FromBody] LoginAdminModel loginData)
        {

            string user = loginData.NombreUsuarioAdmin;
            string password = loginData.PasswordsAdmin;

            // Buscar al administrador en la base de datos usando el contexto
            UsuariosAdmin usuarioAdmin = await _context.UsuariosAdmins.FirstOrDefaultAsync(x => x.NombreUsuarioAdmin == user && x.PasswordsAdmin == password);


            if (usuarioAdmin == null)
            {
                return Unauthorized(new
                {
                    success = false,
                    message = "Credenciales incorrectas",
                    result = ""
                });
            }

            // Obtén la configuración del JWT desde el archivo de configuración
            var jwtConfig = _config.GetSection("Jwt").Get<Model_Jwt>();

            // Crear los claims del token
            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, jwtConfig.Subject),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
                new Claim("id", usuarioAdmin.IdUsuarioAdmin),
                new Claim("usuario", usuarioAdmin.NombreUsuarioAdmin),
                new Claim("rol", usuarioAdmin.Rol)
            };

            // Crear la clave de seguridad usando la clave desde la configuración
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtConfig.Key));
            var signIn = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            // Generar el token JWT
            var token = new JwtSecurityToken(
                issuer: jwtConfig.Issuer,
                audience: jwtConfig.Audience,
                claims: claims,
                expires: DateTime.Now.AddMinutes(60), //1 hora, tiempo de expiracion del token, en coso de no desea que se expire simplemente no poner fecha de expiracion
                signingCredentials: signIn
            );

            var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

            return Ok(new
            {
                success = true,
                message = "Inicio de sesión exitoso",
                result = tokenString
            });
        }
    }
}
