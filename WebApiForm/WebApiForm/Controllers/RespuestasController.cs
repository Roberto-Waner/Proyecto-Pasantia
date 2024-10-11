using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApiForm.Repository;
using WebApiForm.Repository.Models;

namespace WebApiForm.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RespuestasController : ControllerBase
    {
        private readonly FormEncuestaDbContext _context;

        public RespuestasController(FormEncuestaDbContext context)
        {
            _context = context;
        }

        // GET: api/Respuestas
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Respuesta>>> GetRespuestas()
        {
            return await _context.Respuestas.ToListAsync();
        }

        // GET: api/Respuestas/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Respuesta>> GetRespuesta(int id)
        {
            var respuesta = await _context.Respuestas.FindAsync(id);

            if (respuesta == null)
            {
                return NotFound();
            }

            return respuesta;
        }

        // PUT: api/Respuestas/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutRespuesta(int id, Respuesta respuesta)
        {
            if (id != respuesta.IdRespuestas)
            {
                return BadRequest();
            }

            _context.Entry(respuesta).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RespuestaExists(id))
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

        // POST: api/Respuestas
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Respuesta>> PostRespuesta(Respuesta respuesta)
        {
            _context.Respuestas.Add(respuesta);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetRespuesta", new { id = respuesta.IdRespuestas }, respuesta);
        }

        // DELETE: api/Respuestas/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRespuesta(int id)
        {
            var respuesta = await _context.Respuestas.FindAsync(id);
            if (respuesta == null)
            {
                return NotFound();
            }

            _context.Respuestas.Remove(respuesta);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool RespuestaExists(int id)
        {
            return _context.Respuestas.Any(e => e.IdRespuestas == id);
        }
    }
}
