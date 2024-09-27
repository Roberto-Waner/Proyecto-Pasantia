using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace WebApi_OPRET.Repository.Models;

[Table("resp_conclusion")]
public partial class RespConclusion
{
    [Key]
    [Column("no_resp_conclusion")]
    public int NoRespConclusion { get; set; }

    [Column("id_Usuario_Empl")]
    [StringLength(100)]
    [Unicode(false)]
    public string IdUsuarioEmpl { get; set; } = null!;

    [Column("no_encuesta")]
    [StringLength(100)]
    [Unicode(false)]
    public string NoEncuesta { get; set; } = null!;

    [Column("no_conclusion")]
    public int NoConclusion { get; set; }

    [Column("comentarios")]
    [Unicode(false)]
    public string? Comentarios { get; set; }

    [Column("justificacion")]
    [Unicode(false)]
    public string? Justificacion { get; set; }

    [ForeignKey("IdUsuarioEmpl")]
    [InverseProperty("RespConclusions")]
    public virtual UsuariosEmpl IdUsuarioEmplNavigation { get; set; } = null!;

    [ForeignKey("NoConclusion")]
    [InverseProperty("RespConclusions")]
    public virtual Conclusion NoConclusionNavigation { get; set; } = null!;
}
