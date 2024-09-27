using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace WebApi_OPRET.Repository.Models;

[Table("Usuarios_Admin")]
public partial class UsuariosAdmin
{
    [Key]
    [Column("id_Usuario_Admin")]
    [StringLength(100)]
    [Unicode(false)]
    public string IdUsuarioAdmin { get; set; } = null!;

    [Column("cedl_Administrador")]
    [StringLength(100)]
    [Unicode(false)]
    public string CedlAdministrador { get; set; } = null!;

    [Column("nombre_Administrador")]
    [StringLength(200)]
    [Unicode(false)]
    public string NombreAdministrador { get; set; } = null!;

    [Column("nombre_UsuarioAdmin")]
    [StringLength(50)]
    [Unicode(false)]
    public string NombreUsuarioAdmin { get; set; } = null!;

    [Column("email_Admin")]
    [StringLength(100)]
    [Unicode(false)]
    public string EmailAdmin { get; set; } = null!;

    [Column("passwords_Admin")]
    [StringLength(255)]
    [Unicode(false)]
    public string PasswordsAdmin { get; set; } = null!;

    [Column("respt_Passwords_Admin")]
    [StringLength(255)]
    [Unicode(false)]
    public string ResptPasswordsAdmin { get; set; } = null!;

    [Column("foto_Admin")]
    public byte[]? FotoAdmin { get; set; }

    [Column("rol")]
    [StringLength(20)]
    [Unicode(false)]
    public string Rol { get; set; } = null!;
}
