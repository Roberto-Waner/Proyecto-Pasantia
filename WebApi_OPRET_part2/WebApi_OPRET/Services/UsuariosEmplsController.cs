//using System.IdentityModel.Tokens.Jwt;
//using System.Security.Claims;
//using System.Text;
//using Microsoft.AspNetCore.Authorization;
//using Microsoft.AspNetCore.Mvc;
//using Microsoft.EntityFrameworkCore;
//using Microsoft.IdentityModel.Tokens;
//using WebApi_OPRET.Repository;
//using WebApi_OPRET.Repository.Models;

//namespace WebApi_OPRET.Services
//{
//    [Route("api/[controller]")]
//    [ApiController]
//    public class UsuariosEmplsController : ControllerBase
//    {
//        private readonly IConfiguration _config;
//        private readonly FormEncuestaDbContext _context;

//        public UsuariosEmplsController(FormEncuestaDbContext context, IConfiguration config)
//        {
//            _context = context;
//            _config = config;
//        }

//        // GET: api/UsuariosEmpls
//        [HttpGet]
//        public async Task<ActionResult<IEnumerable<UsuariosEmpl>>> GetUsuariosEmpls()
//        {
//            return await _context.UsuariosEmpls.ToListAsync();
//        }

//        // GET: api/UsuariosEmpls/5
//        [HttpGet("{id}")]
//        public async Task<ActionResult<UsuariosEmpl>> GetUsuariosEmpl(string id)
//        {
//            var usuariosEmpl = await _context.UsuariosEmpls.FindAsync(id);

//            if (usuariosEmpl == null)
//            {
//                return NotFound();
//            }

//            return usuariosEmpl;
//        }

//        // PUT: api/UsuariosEmpls/5
//        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
//        [HttpPut("{id}")]
//        public async Task<IActionResult> PutUsuariosEmpl(string id, UsuariosEmpl usuariosEmpl)
//        {
//            if (id != usuariosEmpl.IdUsuarioEmpl)
//            {
//                return BadRequest();
//            }

//            _context.Entry(usuariosEmpl).State = EntityState.Modified;

//            try
//            {
//                await _context.SaveChangesAsync();
//            }
//            catch (DbUpdateConcurrencyException)
//            {
//                if (!UsuariosEmplExists(id))
//                {
//                    return NotFound();
//                }
//                else
//                {
//                    throw;
//                }
//            }

//            return NoContent();
//        }

//        // POST: api/UsuariosEmpls
//        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
//        [HttpPost]
//        public async Task<ActionResult<UsuariosEmpl>> PostUsuariosEmpl(UsuariosEmpl usuariosEmpl)
//        {
//            if (!ModelState.IsValid)
//            {
//                return BadRequest(ModelState);
//            }

//            _context.UsuariosEmpls.Add(usuariosEmpl);
//            try
//            {
//                await _context.SaveChangesAsync();
//            }
//            catch (DbUpdateException)
//            {
//                if (UsuariosEmplExists(usuariosEmpl.IdUsuarioEmpl))
//                {
//                    return Conflict();
//                }
//                else
//                {
//                    throw;
//                }
//            }

//            return CreatedAtAction("GetUsuariosEmpl", new { id = usuariosEmpl.IdUsuarioEmpl }, usuariosEmpl);
//        }

//        // DELETE: api/UsuariosEmpls/5
//        [HttpDelete("{id}")]
//        public async Task<IActionResult> DeleteUsuariosEmpl(string id)
//        {
//            var usuariosEmpl = await _context.UsuariosEmpls.FindAsync(id);
//            if (usuariosEmpl == null)
//            {
//                return NotFound();
//            }

//            _context.UsuariosEmpls.Remove(usuariosEmpl);
//            await _context.SaveChangesAsync();

//            return NoContent();
//        }

//        private bool UsuariosEmplExists(string id)
//        {
//            return _context.UsuariosEmpls.Any(e => e.IdUsuarioEmpl == id);
//        }

//        //-----------------------------------Login Empleados---------------------------------
//        [HttpPost]
//        [Route("login")]
//        public async Task<IActionResult> IniciarSesionEmpl([FromBody] LoginEmpleadoModel loginEmplData)
//        {
//            string userEmpl = loginEmplData.NombreUsuarioEmpl;
//            string passwordEmpl = loginEmplData.PasswordsEmpl;

//            UsuariosEmpl usuariosEmplModel =
//                await _context.UsuariosEmpls.FirstOrDefaultAsync
//                (x => x.NombreUsuarioEmpl == userEmpl && x.PasswordsEmpl == passwordEmpl);

//            if (usuariosEmplModel == null)
//            {
//                return Unauthorized(new
//                {
//                    success = false,
//                    message = "Credenciales incorrectas",
//                    result = ""
//                });
//            }

//            var jwtConfig = _config.GetSection("Jwt").Get<Model_Jwt>();

//            var claims = new[]
//            {
//                new Claim(JwtRegisteredClaimNames.Sub, jwtConfig.Subject),
//                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
//                new Claim(JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
//                new Claim("id", usuariosEmplModel.IdUsuarioEmpl),
//                new Claim("usuario", usuariosEmplModel.NombreUsuarioEmpl),
//                new Claim("cedula", usuariosEmplModel.CedlEmpleado),
//                new Claim("email", usuariosEmplModel.EmailEmpl),
//                new Claim("rol", usuariosEmplModel.Rol)
//            };

//            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtConfig.Key));
//            var signIn = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

//            var token = new JwtSecurityToken
//            (
//                issuer: jwtConfig.Issuer,
//                audience: jwtConfig.Audience,
//                claims: claims,
//                //expires: DateTime.Now.AddMinutes(60),
//                signingCredentials: signIn
//            );

//            var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

//            return Ok(new
//            {
//                success = true,
//                message = "Inicio de sesión exitoso",
//                result = tokenString,
//            });
//        }

//        //[HttpGet("getUser")]
//        //[Authorize]
//        //public async Task<IActionResult> GetUsuarioEmplDetails()
//        //{
//        //    var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

//        //    if (userId == null)
//        //    {
//        //        return Unauthorized();
//        //    }

//        //    var usuario = await _context.UsuariosEmpls.FindAsync(userId);

//        //    if (usuario == null)
//        //    {
//        //        return NotFound();
//        //    }

//        //    return Ok(usuario);
//        //}
//    }
//}
