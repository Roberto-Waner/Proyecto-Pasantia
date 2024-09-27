using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace WebApi_OPRET.Repository.Models;

[Table("preguntaGeneral")]
public partial class PreguntaGeneral
{
    [Key]
    [Column("id_preg_general")]
    public int IdPregGeneral { get; set; }

    [Column("preguntas")]
    [StringLength(255)]
    [Unicode(false)]
    public string? Preguntas { get; set; }

    [InverseProperty("IdPregGeneralNavigation")]
    public virtual ICollection<RespuestaGeneral> RespuestaGenerals { get; set; } = new List<RespuestaGeneral>();
}
