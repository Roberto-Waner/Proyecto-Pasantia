using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace WebApi_OPRET.Repository.Models;

[Table("respuesta")]
public partial class Respuesta
{
    [Key]
    [Column("id_respuesta")]
    public int IdRespuesta { get; set; }

    [Column("id_Usuario_Empl")]
    [StringLength(100)]
    [Unicode(false)]
    public string IdUsuarioEmpl { get; set; } = null!;

    [Column("no_encuesta")]
    [StringLength(100)]
    [Unicode(false)]
    public string NoEncuesta { get; set; } = null!;

    [Column("id_preguntas")]
    public int IdPreguntas { get; set; }

    [Column("respuestas")]
    [StringLength(255)]
    [Unicode(false)]
    public string? Respuestas { get; set; }

    [Column("valoracion")]
    [StringLength(50)]
    [Unicode(false)]
    public string? Valoracion { get; set; }

    [ForeignKey("IdPreguntas")]
    [InverseProperty("Respuestas")]
    public virtual Pregunta IdPreguntasNavigation { get; set; } = null!;

    [ForeignKey("IdUsuarioEmpl")]
    [InverseProperty("Respuestas")]
    public virtual UsuariosEmpl IdUsuarioEmplNavigation { get; set; } = null!;

    [ForeignKey("NoEncuesta")]
    [InverseProperty("Respuestas")]
    public virtual RegistroForm NoEncuestaNavigation { get; set; } = null!;
}
