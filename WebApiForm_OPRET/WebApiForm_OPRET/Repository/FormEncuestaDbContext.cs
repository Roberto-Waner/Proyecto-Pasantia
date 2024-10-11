using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using WebApiForm_OPRET.Repository.Models;

namespace WebApiForm_OPRET.Repository;

public partial class FormEncuestaDbContext : DbContext
{
    public FormEncuestaDbContext()
    {
    }

    public FormEncuestaDbContext(DbContextOptions<FormEncuestaDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Formulario> Formularios { get; set; }

    public virtual DbSet<Pregunta> Preguntas { get; set; }

    public virtual DbSet<RangosRespuesta> RangosRespuestas { get; set; }

    public virtual DbSet<Respuesta> Respuestas { get; set; }

    public virtual DbSet<SubPregunta> SubPreguntas { get; set; }

    public virtual DbSet<Usuario> Usuarios { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseSqlServer("Name=DBConnection");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Formulario>(entity =>
        {
            entity.HasKey(e => e.IdentifacadorForm).HasName("PK__Formular__6CDA1CA2C6A14AE9");

            entity.HasOne(d => d.IdUsuariosNavigation).WithMany(p => p.Formularios)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_User_Form");
        });

        modelBuilder.Entity<Pregunta>(entity =>
        {
            entity.HasKey(e => e.NoPregunta).HasName("PK__Pregunta__5DA6AFEA0903F1C5");

            entity.Property(e => e.NoPregunta).ValueGeneratedNever();

            entity.HasOne(d => d.IdRangoNavigation).WithMany(p => p.Preguntas).HasConstraintName("fk_Preguntas_TipRespuesta");

            entity.HasOne(d => d.IdSubPreguntaNavigation).WithMany(p => p.Preguntas).HasConstraintName("fk_Preguntas_SubPreguntas");
        });

        modelBuilder.Entity<RangosRespuesta>(entity =>
        {
            entity.HasKey(e => e.IdRango).HasName("PK__RangosRe__A071F9CF3B29A326");
        });

        modelBuilder.Entity<Respuesta>(entity =>
        {
            entity.HasKey(e => e.IdRespuestas).HasName("PK__Respuest__D875135C32001BC1");

            entity.HasOne(d => d.IdUsuariosNavigation).WithMany(p => p.Respuestas)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_Respuestas_User");

            entity.HasOne(d => d.NoPreguntaNavigation).WithMany(p => p.Respuestas)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_Respuestas_Preguntas");
        });

        modelBuilder.Entity<SubPregunta>(entity =>
        {
            entity.HasKey(e => e.IdSubPregunta).HasName("PK__Sub_Preg__FF8AC1E937642627");
        });

        modelBuilder.Entity<Usuario>(entity =>
        {
            entity.HasKey(e => e.IdUsuarios).HasName("PK__Usuarios__854B73B310AFCBDC");

            entity.Property(e => e.Estado).HasDefaultValue(true);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
