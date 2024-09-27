using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace WebApi_OPRET.Repository.Models;

[Table("conclusion")]
public partial class Conclusion
{
    [Key]
    [Column("no_conclusion")]
    public int NoConclusion { get; set; }

    [Column("pregunta")]
    [StringLength(500)]
    [Unicode(false)]
    public string? Pregunta { get; set; }

    [InverseProperty("NoConclusionNavigation")]
    public virtual ICollection<RespConclusion> RespConclusions { get; set; } = new List<RespConclusion>();
}
