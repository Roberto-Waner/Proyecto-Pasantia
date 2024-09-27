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
    public class RespConclusionsController : ControllerBase
    {
        private readonly FormEncuestaDbContext _context;

        public RespConclusionsController(FormEncuestaDbContext context)
        {
            _context = context;
        }

        // GET: api/RespConclusions
        [HttpGet]
        public async Task<ActionResult<IEnumerable<RespConclusion>>> GetRespConclusions()
        {
            return await _context.RespConclusions.ToListAsync();
        }

        // GET: api/RespConclusions/5
        [HttpGet("{id}")]
        public async Task<ActionResult<RespConclusion>> GetRespConclusion(int id)
        {
            var respConclusion = await _context.RespConclusions.FindAsync(id);

            if (respConclusion == null)
            {
                return NotFound();
            }

            return respConclusion;
        }

        // PUT: api/RespConclusions/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutRespConclusion(int id, RespConclusion respConclusion)
        {
            if (id != respConclusion.NoRespConclusion)
            {
                return BadRequest();
            }

            _context.Entry(respConclusion).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RespConclusionExists(id))
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

        // POST: api/RespConclusions
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<RespConclusion>> PostRespConclusion(RespConclusion respConclusion)
        {
            _context.RespConclusions.Add(respConclusion);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (RespConclusionExists(respConclusion.NoRespConclusion))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetRespConclusion", new { id = respConclusion.NoRespConclusion }, respConclusion);
        }

        // DELETE: api/RespConclusions/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRespConclusion(int id)
        {
            var respConclusion = await _context.RespConclusions.FindAsync(id);
            if (respConclusion == null)
            {
                return NotFound();
            }

            _context.RespConclusions.Remove(respConclusion);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool RespConclusionExists(int id)
        {
            return _context.RespConclusions.Any(e => e.NoRespConclusion == id);
        }
    }
}
