using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace WebApi_OPRET.Repository.Models;

[Table("respuestaGeneral")]
public partial class RespuestaGeneral
{
    [Key]
    [Column("id_resp_general")]
    public int IdRespGeneral { get; set; }

    [Column("id_Usuario_Empl")]
    [StringLength(100)]
    [Unicode(false)]
    public string IdUsuarioEmpl { get; set; } = null!;

    [Column("no_encuesta")]
    [StringLength(100)]
    [Unicode(false)]
    public string NoEncuesta { get; set; } = null!;

    [Column("id_preg_general")]
    public int IdPregGeneral { get; set; }

    [Column("respuestas")]
    [StringLength(255)]
    [Unicode(false)]
    public string? Respuestas { get; set; }

    [ForeignKey("IdPregGeneral")]
    [InverseProperty("RespuestaGenerals")]
    public virtual PreguntaGeneral IdPregGeneralNavigation { get; set; } = null!;

    [ForeignKey("IdUsuarioEmpl")]
    [InverseProperty("RespuestaGenerals")]
    public virtual UsuariosEmpl IdUsuarioEmplNavigation { get; set; } = null!;
}
