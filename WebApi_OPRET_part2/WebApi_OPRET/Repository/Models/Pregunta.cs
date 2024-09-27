using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace WebApi_OPRET.Repository.Models;

[Table("preguntas")]
public partial class Pregunta
{
    [Key]
    [Column("id_preguntas")]
    public int IdPreguntas { get; set; }

    [Column("preguntas")]
    [StringLength(255)]
    [Unicode(false)]
    public string? Preguntas { get; set; }

    [InverseProperty("IdPreguntasNavigation")]
    public virtual ICollection<Respuesta> Respuestas { get; set; } = new List<Respuesta>();
}
