using WebApiForm.DTO__Data_Transfer_Object_;
using WebApiForm.Repository;

namespace WebApiForm.Capa_de_Servicio
{
    public class RespuestaService
    {
        private readonly FormEncuestaDbContext _content;

        public RespuestaService(FormEncuestaDbContext content)
        {
            _content = content;
        }

        public async Task InsertarRespuestaAsyncServices(Respuesta_Dto respuesta)
        {
            await _content.InsertarRespuestaAsync(respuesta);
        }
    }
}
