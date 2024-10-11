using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace WebApiForm.Repository.Models;

public partial class Respuesta
{
    [Key]
    [Column("id_respuestas")]
    public int IdRespuestas { get; set; }

    [Column("id_usuarios")]
    [StringLength(100)]
    [Unicode(false)]
    public string IdUsuarios { get; set; } = null!;

    [Column("no_encuesta")]
    [StringLength(100)]
    [Unicode(false)]
    public string NoEncuesta { get; set; } = null!;

    [Column("cod_pregunta")]
    public int CodPregunta { get; set; }

    [Column("respuesta")]
    [StringLength(255)]
    [Unicode(false)]
    public string? Respuesta1 { get; set; }

    [Column("valoracion")]
    [StringLength(50)]
    [Unicode(false)]
    public string? Valoracion { get; set; }

    [Column("comentarios")]
    [Unicode(false)]
    public string? Comentarios { get; set; }

    [Column("justificacion")]
    [Unicode(false)]
    public string? Justificacion { get; set; }

    [ForeignKey("CodPregunta")]
    [InverseProperty("Respuestas")]
    public virtual Pregunta CodPreguntaNavigation { get; set; } = null!;

    [ForeignKey("IdUsuarios")]
    [InverseProperty("Respuestas")]
    public virtual RegistroUsuario IdUsuariosNavigation { get; set; } = null!;
}
