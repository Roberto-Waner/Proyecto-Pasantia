using Microsoft.AspNetCore.Mvc;
using WebApiForm.Capa_de_Servicio;
using WebApiForm.DTO__Data_Transfer_Object_;

namespace WebApiForm.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReportController : ControllerBase
    {
        private readonly RespuestaService _respuestaService;

        public ReportController(RespuestaService respuestaService)
        {
            _respuestaService = respuestaService;
        }

        [HttpGet("ExportReporte")]
        public async Task<ActionResult<IEnumerable<ReportRespuestas_Dto>>> GetReporteRespuestas()
        {
            try
            {
                var reporte = await _respuestaService.ExportReportRespuestaServices();
                if (reporte == null || reporte.Count == 0)
                {
                    return StatusCode(404, "No se encontraron reportes de Respuestas para Exportar.");
                }
                return Ok(reporte);

            }catch (Exception ex)
            {
                return StatusCode(500, "Ocurrió un error interno al procesar la solicitud. Por favor, inténtelo de nuevo más tarde.");
            }
        }
    }
}
