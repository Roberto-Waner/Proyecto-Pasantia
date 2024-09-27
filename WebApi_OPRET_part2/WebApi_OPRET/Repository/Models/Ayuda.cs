using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace WebApi_OPRET.Repository.Models;

[Table("ayuda")]
public partial class Ayuda
{
    [Key]
    [Column("id_ayuda")]
    public int IdAyuda { get; set; }

    [Column("descripcion")]
    [StringLength(200)]
    [Unicode(false)]
    public string? Descripcion { get; set; }
}
