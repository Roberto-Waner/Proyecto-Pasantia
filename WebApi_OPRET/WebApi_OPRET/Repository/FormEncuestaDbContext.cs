using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using WebApi_OPRET.Repository.Models;

namespace WebApi_OPRET.Repository;

public partial class FormEncuestaDbContext : DbContext
{
    public FormEncuestaDbContext()
    {
    }

    public FormEncuestaDbContext(DbContextOptions<FormEncuestaDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Ayuda> Ayudas { get; set; }

    public virtual DbSet<Conclusion> Conclusions { get; set; }

    public virtual DbSet<Pregunta> Preguntas { get; set; }

    public virtual DbSet<PreguntaGeneral> PreguntaGenerals { get; set; }

    public virtual DbSet<RegistroForm> RegistroForms { get; set; }

    public virtual DbSet<RespConclusion> RespConclusions { get; set; }

    public virtual DbSet<Respuesta> Respuestas { get; set; }

    public virtual DbSet<RespuestaGeneral> RespuestaGenerals { get; set; }

    public virtual DbSet<UsuariosAdmin> UsuariosAdmins { get; set; }

    public virtual DbSet<UsuariosEmpl> UsuariosEmpls { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseSqlServer("Name=DBConnection");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Ayuda>(entity =>
        {
            entity.HasKey(e => e.IdAyuda).HasName("PK__ayuda__7CD934E81ED4D4AB");

            entity.Property(e => e.IdAyuda).ValueGeneratedNever();
        });

        modelBuilder.Entity<Conclusion>(entity =>
        {
            entity.HasKey(e => e.NoConclusion).HasName("PK__conclusi__D3DC9D89CC807918");

            entity.Property(e => e.NoConclusion).ValueGeneratedNever();
        });

        modelBuilder.Entity<Pregunta>(entity =>
        {
            entity.HasKey(e => e.IdPreguntas).HasName("PK__pregunta__0F70E3587FF9B7B6");

            entity.Property(e => e.IdPreguntas).ValueGeneratedNever();
        });

        modelBuilder.Entity<PreguntaGeneral>(entity =>
        {
            entity.HasKey(e => e.IdPregGeneral).HasName("PK__pregunta__20832DA174F531B1");

            entity.Property(e => e.IdPregGeneral).ValueGeneratedNever();
        });

        modelBuilder.Entity<RegistroForm>(entity =>
        {
            entity.HasKey(e => e.NoEncuesta).HasName("PK__registro__1489DE11CB29C453");

            entity.HasOne(d => d.IdUsuarioEmplNavigation).WithMany(p => p.RegistroForms)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_UserEmpleado_Registro");
        });

        modelBuilder.Entity<RespConclusion>(entity =>
        {
            entity.HasKey(e => e.NoRespConclusion).HasName("PK__resp_con__767E926F615D3AFA");

            entity.Property(e => e.NoRespConclusion).ValueGeneratedNever();

            entity.HasOne(d => d.IdUsuarioEmplNavigation).WithMany(p => p.RespConclusions)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_AnswerConclusion_UserEmpleado");

            entity.HasOne(d => d.NoConclusionNavigation).WithMany(p => p.RespConclusions)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_AnswerConclusion_Conclusion");

            entity.HasOne(d => d.NoEncuestaNavigation).WithMany(p => p.RespConclusions)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_AnswerConclusion_Registro");
        });

        modelBuilder.Entity<Respuesta>(entity =>
        {
            entity.HasKey(e => e.IdRespuesta).HasName("PK__respuest__14E55589F9128B76");

            entity.Property(e => e.IdRespuesta).ValueGeneratedNever();

            entity.HasOne(d => d.IdPreguntasNavigation).WithMany(p => p.Respuestas)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_Respuesta_Pregunta");

            entity.HasOne(d => d.IdUsuarioEmplNavigation).WithMany(p => p.Respuestas)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_Respuesta_UserEmpleado");

            entity.HasOne(d => d.NoEncuestaNavigation).WithMany(p => p.Respuestas)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_Respuesta_Registro");
        });

        modelBuilder.Entity<RespuestaGeneral>(entity =>
        {
            entity.HasKey(e => e.IdRespGeneral).HasName("PK__respuest__AF282964C2FB3D43");

            entity.Property(e => e.IdRespGeneral).ValueGeneratedNever();

            entity.HasOne(d => d.IdPregGeneralNavigation).WithMany(p => p.RespuestaGenerals)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_respuestaGeneral_preguntaGeneral");

            entity.HasOne(d => d.IdUsuarioEmplNavigation).WithMany(p => p.RespuestaGenerals)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_respuestaGeneral_Usuarios_Empl");

            entity.HasOne(d => d.NoEncuestaNavigation).WithMany(p => p.RespuestaGenerals)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_respuestaGeneral_registroForm");
        });

        modelBuilder.Entity<UsuariosAdmin>(entity =>
        {
            entity.HasKey(e => e.IdUsuarioAdmin).HasName("PK__Usuarios__DC8F6C7E28ACE918");
        });

        modelBuilder.Entity<UsuariosEmpl>(entity =>
        {
            entity.HasKey(e => e.IdUsuarioEmpl).HasName("PK__Usuarios__135EDAF0CBBF86F0");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
