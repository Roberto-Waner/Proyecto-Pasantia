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
    public class PreguntaGeneralsController : ControllerBase
    {
        private readonly FormEncuestaDbContext _context;

        public PreguntaGeneralsController(FormEncuestaDbContext context)
        {
            _context = context;
        }

        // GET: api/PreguntaGenerals
        [HttpGet]
        public async Task<ActionResult<IEnumerable<PreguntaGeneral>>> GetPreguntaGenerals()
        {
            return await _context.PreguntaGenerals.ToListAsync();
        }

        // GET: api/PreguntaGenerals/5
        [HttpGet("{id}")]
        public async Task<ActionResult<PreguntaGeneral>> GetPreguntaGeneral(int id)
        {
            var preguntaGeneral = await _context.PreguntaGenerals.FindAsync(id);

            if (preguntaGeneral == null)
            {
                return NotFound();
            }

            return preguntaGeneral;
        }

        // PUT: api/PreguntaGenerals/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPreguntaGeneral(int id, PreguntaGeneral preguntaGeneral)
        {
            if (id != preguntaGeneral.IdPregGeneral)
            {
                return BadRequest();
            }

            _context.Entry(preguntaGeneral).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PreguntaGeneralExists(id))
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

        // POST: api/PreguntaGenerals
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<PreguntaGeneral>> PostPreguntaGeneral(PreguntaGeneral preguntaGeneral)
        {
            _context.PreguntaGenerals.Add(preguntaGeneral);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (PreguntaGeneralExists(preguntaGeneral.IdPregGeneral))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetPreguntaGeneral", new { id = preguntaGeneral.IdPregGeneral }, preguntaGeneral);
        }

        // DELETE: api/PreguntaGenerals/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePreguntaGeneral(int id)
        {
            var preguntaGeneral = await _context.PreguntaGenerals.FindAsync(id);
            if (preguntaGeneral == null)
            {
                return NotFound();
            }

            _context.PreguntaGenerals.Remove(preguntaGeneral);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool PreguntaGeneralExists(int id)
        {
            return _context.PreguntaGenerals.Any(e => e.IdPregGeneral == id);
        }
    }
}
