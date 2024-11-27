using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis.Operations;
using Microsoft.DotNet.Scaffolding.Shared.Messaging;
using Microsoft.EntityFrameworkCore;
using WebApiForm.Capa_de_Servicio;
using WebApiForm.Repository;
using WebApiForm.Repository.Models;
using WebApiForm.Services.DTO__Data_Transfer_Object_;

namespace WebApiForm.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RegistroUsuariosController : ControllerBase
    {
        private readonly FormEncuestaDbContext _context;
        private readonly EmpleadoService _empleadoService;

        public RegistroUsuariosController(FormEncuestaDbContext context, EmpleadoService empleadoService)
        {
            _context = context;
            _empleadoService = empleadoService;
        }

        // GET: api/RegistroUsuarios
        [HttpGet]
        public async Task<ActionResult<IEnumerable<RegistroUsuario>>> GetRegistroUsuarios()
        {
            return await _context.RegistroUsuarios.ToListAsync();
        }

        // GET: api/RegistroUsuarios/5
        [HttpGet("{id}")]
        public async Task<ActionResult<RegistroUsuario>> GetRegistroUsuario(string id)
        {
            var registroUsuario = await _context.RegistroUsuarios.FindAsync(id);

            if (registroUsuario == null)
            {
                return NotFound();
            }

            return registroUsuario;
        }

        // PUT: api/RegistroUsuarios/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutRegistroUsuario(string id, RegistroUsuario registroUsuario)
        {
            if (id != registroUsuario.IdUsuarios)
            {
                return BadRequest();
            }

            _context.Entry(registroUsuario).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RegistroUsuarioExists(id))
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

        // POST: api/RegistroUsuarios
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<RegistroUsuario>> PostRegistroUsuario(RegistroUsuario registroUsuario)
        {
            //esto se hace cuando la tabla en la cual se le quiera adaptar un trigger tenga un id de tipo varchar/String

            try
            {
                // Asignar un valor temporal a IdUsuarios
                registroUsuario.IdUsuarios = "TEMP_" + Guid.NewGuid().ToString();

                // Deshabilitar el seguimiento de cambios para permitir que el trigger maneje la clave primaria
                _context.ChangeTracker.AutoDetectChangesEnabled = false;

                _context.RegistroUsuarios.Add(registroUsuario);
                await _context.SaveChangesAsync();

                // Rehabilitar el seguimiento de cambios
                _context.ChangeTracker.AutoDetectChangesEnabled = true;

                // Recuperar el valor generado por el trigger
                var generatedIdUsuario = await _context.RegistroUsuarios
                    .Where(r => r.Cedula == registroUsuario.Cedula)
                    .Select(r => r.IdUsuarios)
                    .FirstOrDefaultAsync();

                // Actualizar el objeto con el valor generado por el trigger
                registroUsuario.IdUsuarios = generatedIdUsuario;

                return CreatedAtAction("GetRegistroUsuario", new { id = registroUsuario.IdUsuarios }, registroUsuario);
            }
            catch (DbUpdateException Db_ex)
            {
                // Capturar errores de restricciones UNIQUE
                if (Db_ex.InnerException != null && Db_ex.InnerException.Message.Contains("UNIQUE KEY constraint"))
                {
                    // Extraer información del mensaje del error
                    string details = Db_ex.InnerException.Message;

                    if (details.Contains("UQ__Registro__415B7BE502A28CF1")) //para la cedula
                    {
                        return BadRequest(new { message = "La cédula ya esta en uso." });
                    }
                    else if (details.Contains("UQ__Registro__9AFF8FC6E637B81B")) //para el usuario
                    {
                        return BadRequest(new { message = "El nombre del Usuario que haz ingresado, no se puede usar porque ya esta en uso." });
                    }
                    else if (details.Contains("UQ__Registro__AB6E61647DF25020")) //para el correo
                    {
                        return BadRequest(new { message = "El correo electrónico ya esta en uso." });
                    }

                    return BadRequest(new { message = "Valor único!!!, ya está registrado exitozamente.", details });
                }

                // Capturar otros errores de base de datos
                return BadRequest(new { message = "Error al registrar el usuario", details = Db_ex.InnerException?.Message ?? Db_ex.Message });
            }
            catch (Exception ex)
            {
                //var innerException = ex.InnerException != null ? ex.InnerException.Message : ex.Message;

                // Capturar errores generales
                return StatusCode(500, new { message = "Ocurrió un error inesperado", details = ex.Message });
            }

            /*
            _context.RegistroUsuarios.Add(registroUsuario);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (RegistroUsuarioExists(registroUsuario.IdUsuarios))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetRegistroUsuario", new { id = registroUsuario.IdUsuarios }, registroUsuario);
            */
        }

        // DELETE: api/RegistroUsuarios/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRegistroUsuario(string id)
        {
            var registroUsuario = await _context.RegistroUsuarios.FindAsync(id);
            if (registroUsuario == null)
            {
                return NotFound();
            }

            _context.RegistroUsuarios.Remove(registroUsuario);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool RegistroUsuarioExists(string id)
        {
            return _context.RegistroUsuarios.Any(e => e.IdUsuarios == id);
        }

        [HttpGet("ObtenerEmpl")]
        public async Task<ActionResult<List<ObtenerEmpleados>>> getObtenerEmpleados()
        {
            var empleados = await _empleadoService._ObtenerEmpleadosAsync();
            return Ok(empleados);
        }
    }
}
