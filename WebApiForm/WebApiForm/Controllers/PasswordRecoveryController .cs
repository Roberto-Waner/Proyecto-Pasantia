using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.Blazor;
using WebApiForm.Capa_de_Servicio;
using WebApiForm.DTO__Data_Transfer_Object_;

namespace WebApiForm.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PasswordRecoveryController : ControllerBase
    {
        private readonly PasswordRecoveryService _passService;

        public PasswordRecoveryController(PasswordRecoveryService passService)
        {
            _passService = passService;
        }

        [HttpPost("request")]
        public async Task<IActionResult> RequestPasswordRecovery([FromBody] ForgotPasswordDto forgotEmail)
        {
            try
            {
                await _passService.CrearTokenRecuperacionAsync(forgotEmail.Email);
                return Ok("Correo de recuperación enviado.");
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = "Error al recuperar el correo", details = ex.Message });
            }
        }

        [HttpPost("reset")]
        public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordDto model)
        {
            try
            {
                var result = await _passService.VerificarTokenAsync(model.Token, model.NewPassword);
                if (result)
                {
                    return Ok("Contraseña restablecida correctamente.");
                }
                return BadRequest("Token inválido o expirado.");
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = "Error al restablecer la contraseña", details = ex.Message });
            }
        }
    }
}
