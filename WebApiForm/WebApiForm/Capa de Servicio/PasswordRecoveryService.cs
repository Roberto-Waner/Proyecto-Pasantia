using Microsoft.EntityFrameworkCore;
using WebApiForm.Capa_de_Servicio.Encrypt;
using WebApiForm.Interfaces;
using WebApiForm.Repository;
using WebApiForm.Repository.Models;

namespace WebApiForm.Capa_de_Servicio
{
    public class PasswordRecoveryService
    {
        private readonly IEmailSender _emailSender;
        private readonly FormEncuestaDbContext _context;

        public PasswordRecoveryService(IEmailSender emailSender, FormEncuestaDbContext context)
        {
            _emailSender = emailSender;
            _context = context;
        }

        public string GenerarTokenRecuperacion()
        {
            return Guid.NewGuid().ToString();
        }

        public async Task CrearTokenRecuperacionAsync(string email)
        {
            var user = await _context.RegistroUsuarios.FirstOrDefaultAsync(u => u.Email == email);
            if (user == null)
            {
                throw new Exception("Usuario no encontrado");
            }
            var token = GenerarTokenRecuperacion();
            var expiration = DateTime.UtcNow.AddHours(1);

            var passwordResetToken = new PasswordResetToken
            {
                IdUsuarios = user.IdUsuarios,
                Token = token,
                Expiration = expiration
            };

            _context.PasswordResetTokens.Add(passwordResetToken);
            await _context.SaveChangesAsync();

            string body = $"Haga clic en el siguiente enlace para restablecer su contraseña: https://localhost:7190/api/PasswordRecovery/request={token}";
            await _emailSender.SendEmail(email, "Recuperación de Contraseña", body);
        }

        public async Task<bool> VerificarTokenAsync(string token, string nuevaContraseña)
        {
            var passwordResetToken = await _context.PasswordResetTokens
                .Include(t => t.IdUsuariosNavigation)
                .FirstOrDefaultAsync(t => t.Token == token && t.Expiration > DateTime.UtcNow);

            if (passwordResetToken == null)
            {
                return false;
            }
            
            var user = passwordResetToken.IdUsuariosNavigation;

            // Generar nuevo salt y hashear la nueva contraseña
            string newSalt = SaltHelper.GenerateSalt();
            user.Passwords = HashHelper.Hash(nuevaContraseña, newSalt);

            _context.PasswordResetTokens.Remove(passwordResetToken); // Elimina el token una vez usado
            await _context.SaveChangesAsync();

            return true;
        }

        public bool VerificarPassword(string enteredPass, string storedHash, string salt)
        {
            return HashHelper.Verify(enteredPass, storedHash, salt);
        }
    }
}
