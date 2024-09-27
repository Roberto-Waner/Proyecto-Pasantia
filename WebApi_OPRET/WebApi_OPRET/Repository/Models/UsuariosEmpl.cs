using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace WebApi_OPRET.Repository.Models;

[Table("Usuarios_Empl")]
public partial class UsuariosEmpl
{
    [Key]
    [Column("id_Usuario_Empl")]
    [StringLength(100)]
    [Unicode(false)]
    public string IdUsuarioEmpl { get; set; } = null!;

    [Column("cedl_Empleado")]
    [StringLength(100)]
    [Unicode(false)]
    public string CedlEmpleado { get; set; } = null!;

    [Column("nombre_Empleado")]
    [StringLength(200)]
    [Unicode(false)]
    public string NombreEmpleado { get; set; } = null!;

    [Column("nombre_UsuarioEmpl")]
    [StringLength(50)]
    [Unicode(false)]
    public string NombreUsuarioEmpl { get; set; } = null!;

    [Column("email_Empl")]
    [StringLength(100)]
    [Unicode(false)]
    public string EmailEmpl { get; set; } = null!;

    [Column("passwords_Empl")]
    [StringLength(255)]
    [Unicode(false)]
    public string PasswordsEmpl { get; set; } = null!;

    [Column("respt_Passwords_Empl")]
    [StringLength(255)]
    [Unicode(false)]
    public string ResptPasswordsEmpl { get; set; } = null!;

    [Column("foto_Empl")]
    public byte[]? FotoEmpl { get; set; }

    [Column("rol")]
    [StringLength(20)]
    [Unicode(false)]
    public string Rol { get; set; } = null!;

    [InverseProperty("IdUsuarioEmplNavigation")]
    public virtual ICollection<RegistroForm> RegistroForms { get; set; } = new List<RegistroForm>();

    [InverseProperty("IdUsuarioEmplNavigation")]
    public virtual ICollection<RespConclusion> RespConclusions { get; set; } = new List<RespConclusion>();

    [InverseProperty("IdUsuarioEmplNavigation")]
    public virtual ICollection<RespuestaGeneral> RespuestaGenerals { get; set; } = new List<RespuestaGeneral>();

    [InverseProperty("IdUsuarioEmplNavigation")]
    public virtual ICollection<Respuesta> Respuestas { get; set; } = new List<Respuesta>();
}
