using Microsoft.EntityFrameworkCore;
using System.IO;
using WebApiForm.DTO__Data_Transfer_Object_;
using WebApiForm.Repository;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace WebApiForm.Capa_de_Servicio
{
    public class RespuestaService
    {
        private readonly FormEncuestaDbContext _context;

        public RespuestaService(FormEncuestaDbContext context)
        {
            _context = context;
        }

        public async Task InsertarRespuestaAsyncServices(Respuesta_Dto respuesta)
        {
            await _context.InsertarRespuestaAsync(respuesta);
        }

        public async Task<List<FiltrarRespuestas_Dto>> FiltrarRespuestaAsyncServices(FiltrarRespuestas_Dto filtrar)
        {
            var query = "EXEC sp_filtrar_Respuesta @id_usuarios = {0}, @no_encuesta = {1}, @id_sesion = {2}";
            var parameters = new List<object>
            {
                filtrar.IdUsuarios ?? (object)DBNull.Value,
                filtrar.NoEncuesta ?? (object)DBNull.Value,
                filtrar.IdSesion ?? (object)DBNull.Value
            };

            return await _context.FiltrarRespuestasDtos.FromSqlRaw(query, parameters.ToArray()).ToListAsync();
        }

    }
}
