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
    public class RegistroFormsController : ControllerBase
    {
        private readonly FormEncuestaDbContext _context;

        public RegistroFormsController(FormEncuestaDbContext context)
        {
            _context = context;
        }

        // GET: api/RegistroForms
        [HttpGet]
        public async Task<ActionResult<IEnumerable<RegistroForm>>> GetRegistroForms()
        {
            return await _context.RegistroForms.ToListAsync();
        }

        // GET: api/RegistroForms/5
        [HttpGet("{id}")]
        public async Task<ActionResult<RegistroForm>> GetRegistroForm(string id)
        {
            var registroForm = await _context.RegistroForms.FindAsync(id);

            if (registroForm == null)
            {
                return NotFound();
            }

            return registroForm;
        }

        // PUT: api/RegistroForms/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutRegistroForm(string id, RegistroForm registroForm)
        {
            if (id != registroForm.NoEncuesta)
            {
                return BadRequest();
            }

            _context.Entry(registroForm).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RegistroFormExists(id))
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

        // POST: api/RegistroForms
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<RegistroForm>> PostRegistroForm(RegistroForm registroForm)
        {
            _context.RegistroForms.Add(registroForm);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (RegistroFormExists(registroForm.NoEncuesta))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetRegistroForm", new { id = registroForm.NoEncuesta }, registroForm);
        }

        // DELETE: api/RegistroForms/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRegistroForm(string id)
        {
            var registroForm = await _context.RegistroForms.FindAsync(id);
            if (registroForm == null)
            {
                return NotFound();
            }

            _context.RegistroForms.Remove(registroForm);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool RegistroFormExists(string id)
        {
            return _context.RegistroForms.Any(e => e.NoEncuesta == id);
        }
    }
}
