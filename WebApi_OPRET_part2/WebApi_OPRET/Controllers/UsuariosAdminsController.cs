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
    public class UsuariosAdminsController : ControllerBase
    {
        private readonly FormEncuestaDbContext _context;

        public UsuariosAdminsController(FormEncuestaDbContext context)
        {
            _context = context;
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
    }
}
