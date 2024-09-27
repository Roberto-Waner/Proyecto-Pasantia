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
    public class ConclusionsController : ControllerBase
    {
        private readonly FormEncuestaDbContext _context;

        public ConclusionsController(FormEncuestaDbContext context)
        {
            _context = context;
        }

        // GET: api/Conclusions
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Conclusion>>> GetConclusions()
        {
            return await _context.Conclusions.ToListAsync();
        }

        // GET: api/Conclusions/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Conclusion>> GetConclusion(int id)
        {
            var conclusion = await _context.Conclusions.FindAsync(id);

            if (conclusion == null)
            {
                return NotFound();
            }

            return conclusion;
        }

        // PUT: api/Conclusions/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutConclusion(int id, Conclusion conclusion)
        {
            if (id != conclusion.NoConclusion)
            {
                return BadRequest();
            }

            _context.Entry(conclusion).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ConclusionExists(id))
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

        // POST: api/Conclusions
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Conclusion>> PostConclusion(Conclusion conclusion)
        {
            _context.Conclusions.Add(conclusion);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (ConclusionExists(conclusion.NoConclusion))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetConclusion", new { id = conclusion.NoConclusion }, conclusion);
        }

        // DELETE: api/Conclusions/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteConclusion(int id)
        {
            var conclusion = await _context.Conclusions.FindAsync(id);
            if (conclusion == null)
            {
                return NotFound();
            }

            _context.Conclusions.Remove(conclusion);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ConclusionExists(int id)
        {
            return _context.Conclusions.Any(e => e.NoConclusion == id);
        }
    }
}
