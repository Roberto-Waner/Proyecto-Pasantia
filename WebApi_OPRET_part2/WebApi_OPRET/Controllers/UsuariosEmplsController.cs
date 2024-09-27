using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApi_OPRET.Repository;
using WebApi_OPRET.Repository.Models;

namespace WebApi_OPRET.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuariosEmplsController : ControllerBase
    {
        private readonly FormEncuestaDbContext _context;

        public UsuariosEmplsController(FormEncuestaDbContext context)
        {
            _context = context;
        }

        // GET: api/UsuariosEmpls
        [HttpGet]
        public async Task<ActionResult<IEnumerable<UsuariosEmpl>>> GetUsuariosEmpls()
        {
            return await _context.UsuariosEmpls.ToListAsync();
        }

        // GET: api/UsuariosEmpls/5
        [HttpGet("{id}")]
        public async Task<ActionResult<UsuariosEmpl>> GetUsuariosEmpl(string id)
        {
            var usuariosEmpl = await _context.UsuariosEmpls.FindAsync(id);

            if (usuariosEmpl == null)
            {
                return NotFound();
            }

            return usuariosEmpl;
        }

        // PUT: api/UsuariosEmpls/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUsuariosEmpl(string id, UsuariosEmpl usuariosEmpl)
        {
            if (id != usuariosEmpl.IdUsuarioEmpl)
            {
                return BadRequest();
            }

            _context.Entry(usuariosEmpl).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UsuariosEmplExists(id))
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

        // POST: api/UsuariosEmpls
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<UsuariosEmpl>> PostUsuariosEmpl(UsuariosEmpl usuariosEmpl)
        {
            _context.UsuariosEmpls.Add(usuariosEmpl);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (UsuariosEmplExists(usuariosEmpl.IdUsuarioEmpl))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetUsuariosEmpl", new { id = usuariosEmpl.IdUsuarioEmpl }, usuariosEmpl);
        }

        // DELETE: api/UsuariosEmpls/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUsuariosEmpl(string id)
        {
            var usuariosEmpl = await _context.UsuariosEmpls.FindAsync(id);
            if (usuariosEmpl == null)
            {
                return NotFound();
            }

            _context.UsuariosEmpls.Remove(usuariosEmpl);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool UsuariosEmplExists(string id)
        {
            return _context.UsuariosEmpls.Any(e => e.IdUsuarioEmpl == id);
        }
    }
}
