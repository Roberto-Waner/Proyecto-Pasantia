using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace WebApi_OPRET.Repository.Models;

[Table("registroForm")]
public partial class RegistroForm
{
    [Key]
    [Column("identifacador_form")]
    public int IdentifacadorForm { get; set; }

    [Column("no_encuesta")]
    [StringLength(100)]
    [Unicode(false)]
    public string NoEncuesta { get; set; } = null!;

    [Column("id_Usuario_Empl")]
    [StringLength(100)]
    [Unicode(false)]
    public string IdUsuarioEmpl { get; set; } = null!;

    [Column("cedl_Empleado")]
    [StringLength(100)]
    [Unicode(false)]
    public string CedlEmpleado { get; set; } = null!;

    [Column("fecha_encuesta")]
    [StringLength(100)]
    [Unicode(false)]
    public string? FechaEncuesta { get; set; }

    [Column("hora")]
    [StringLength(100)]
    [Unicode(false)]
    public string? Hora { get; set; }

    [Column("estacion")]
    [StringLength(200)]
    [Unicode(false)]
    public string? Estacion { get; set; }

    [Column("linea")]
    [StringLength(11)]
    [Unicode(false)]
    public string? Linea { get; set; }

    [ForeignKey("IdUsuarioEmpl")]
    [InverseProperty("RegistroForms")]
    public virtual UsuariosEmpl? IdUsuarioEmplNavigation { get; set; } = null!;
}
