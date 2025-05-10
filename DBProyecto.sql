/*tabla usuario------------------------------------------------------------------*/

create table usuario
(
Cedulausuario bigint primary key,
Nombres varchar (255) not null,
Apellidos varchar(255) not null,
Genero varchar (12)
	check(Genero In('Femenino','Masculino'))not null,
Direccion varchar(255) not null,
Correo varchar(255) not null,
Nombreusuario varchar(255) not null,
Contraseñausuario varchar(255) not null,
Estadousuario varchar(12)
	check(Estadousuario in('activo','inactivo'))not null,
Tarjetaprofesional varchar (255) null,
Especialidad varchar(255) null,
Rol varchar(20)
	Check (Rol in('Administrador','Doctor','Paciente')) not null,
ocupacion varchar(255) null,
fechanacimiento date not null,
telefono bigint not null
);

/*tabla agenda------------------------------------------------------------------*/

create table agenda
(
codigoagenda tinyint primary key identity ,
ceduladoctor bigint  not null,
foreign key(ceduladoctor) references usuario(cedulausuario)
);

/*#tabla cita------------------------------------------------------------------*/

create table cita
(
id_cita tinyint primary key identity,
codigo_agenda tinyint,
cedula_doctor_atiende bigint not null,
hora_atencion time not null,
fecha_atencion date not null,
valor smallint  not null,
consultorio tinyint  not null,
motivo varchar (max) not null,
cedula_paciente bigint not null,
Cedula_Admi Bigint null,
foreign key(codigo_agenda) references agenda(codigoagenda),
foreign key(cedula_doctor_atiende) references usuario(cedulausuario),
Foreign Key(Cedula_Admi) References usuario(cedulausuario),
foreign key(cedula_paciente) references usuario(cedulausuario)
);

/*tabla historiaclinica------------------------------------------------------------------*/

create table historiaclinica
(
id_historialclinico tinyint primary key identity,
cedula bigint not null unique,
estatura float not null,
peso tinyint not null,
foreign key(cedula) references usuario(cedulausuario)
);

/*tabla enfermedadpadecida------------------------------------------------------------------*/

create table enfermedadpadecida
(
enfermedad_padecida varchar(255) not null,
id_historialclinico tinyint not null,
foreign key(id_historialclinico) references historiaclinica(id_historialclinico)
);

/*tabla alergia------------------------------------------------------------------*/

create table alergia
(
alergia varchar(255) not null,
id_historialclinico tinyint not null,
foreign key(id_historialclinico) references historiaclinica(id_historialclinico)
);

/*tabla tratamiento ------------------------------------------------------------------*/

 create table tratamiento 
(
historial_tratamiento varchar(max) not null,
id_historialclinico tinyint  not null,
foreign key(id_historialclinico) references historiaclinica(id_historialclinico)
);

/*#tabla diagnostico ------------------------------------------------------------------*/

create table diagnostico
(
id_diagnostico tinyint primary key identity,
id_historial tinyint not null,
descripcioncita varchar(max) not null,
estadodientes varchar(5000) not null,
foreign key(id_historial) references historiaclinica(id_historialclinico)
);

/*tabla rel_genera ------------------------------------------------------------------*/

create table rel_genera
(
id_cita tinyint not null identity,
id_diagnostico tinyint not null,
foreign key(id_cita) references cita(id_cita),
foreign key(id_diagnostico) references diagnostico(id_diagnostico)
);

/*procedimiento almacenado RegistrarUsuario--------------------------------------------------------*/

create procedure RegUsu
(
    @Cedulausuario BIGINT,
    @Nombres VARCHAR(255),
    @Apellidos VARCHAR(255),
    @Genero VARCHAR(12),
    @Direccion VARCHAR(255),
    @Correo VARCHAR(255),
    @Nombreusuario VARCHAR(255),
    @Contraseñausuario VARCHAR(255), -- Contraseña en texto plano, viene del usuario
    @Estadousuario VARCHAR(12),
    @Tarjetaprofesional VARCHAR(255) = NULL,
    @Especialidad VARCHAR(255) = NULL,
    @Rol VARCHAR(20),
    @Ocupacion VARCHAR(255) = NULL,
    @Fechanacimiento DATE,
    @Telefono BIGINT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si ya existe un usuario con la misma cédula o correo
    IF EXISTS (
        SELECT 1 FROM usuario
        WHERE Cedulausuario = @Cedulausuario
           OR Correo = @Correo
    )
    BEGIN
        PRINT '❌ Ya existe un usuario con esa cédula o correo electrónico.';
        RETURN;
    END;

    -- Cifrar la contraseña con SHA-256 y convertirla a texto hexadecimal
    DECLARE @HashContraseña VARCHAR(64);
    SELECT @HashContraseña = CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', @Contraseñausuario), 2);

    -- Insertar el nuevo usuario con la contraseña cifrada
    INSERT INTO usuario (
        Cedulausuario,
        Nombres,
        Apellidos,
        Genero,
        Direccion,
        Correo,
        Nombreusuario,
        Contraseñausuario,
        Estadousuario,
        Tarjetaprofesional,
        Especialidad,
        Rol,
        Ocupacion,
        Fechanacimiento,
        Telefono
    )
    VALUES (
        @Cedulausuario,
        @Nombres,
        @Apellidos,
        @Genero,
        @Direccion,
        @Correo,
        @Nombreusuario,
        @HashContraseña, -- Aquí se guarda ya cifrada
        @Estadousuario,
        @Tarjetaprofesional,
        @Especialidad,
        @Rol,
        @Ocupacion,
        @Fechanacimiento,
        @Telefono
    );

    PRINT '✅ Usuario registrado con contraseña cifrada.';
END;

/*Procedimiento de consulta de cedula---------------------------------------------------------------------------*/
create procedure ConsCedula
(
	@Cedulausuario BIGINT
)
AS
BEGIN
	SELECT Cedulausuario
	From usuario
	where Cedulausuario = @Cedulausuario;
END

/*procedimiento de AccesoUsuarios --------------------------------------------------------------------------------*/

create procedure AccesUsuario
(
	@a varchar(255),
	@b varchar(255)
)
as
begin
	select rol 
	from usuario
	where Nombreusuario = @a and Contraseñausuario = @b
end

/*Procedimiento de consulta de usuario --------------------------------------------------------------------------*/

create procedure ConsUsuarios
(
	@documento bigint
)
as
begin
	select Cedulausuario,Nombres,Apellidos,Genero,Direccion,Correo,Nombreusuario, Estadousuario, Tarjetaprofesional,Especialidad,Rol,fechanacimiento,telefono
	from usuario
	where Cedulausuario = @documento
end

/*Consutla de Rol-------------------------------------------*/

create procedure ConsultaRol
(
	@Rol varchar(50)
)
as
begin
	if @Rol not in ('Administrador','Doctor','Paciente')
	begin
		raiserror('El Rol especifico no es valido',16,1)
	return 
	end 
	select cedulausuario, nombres, apellidos, genero, direccion, correo, nombreusuario, estadousuario , tarjetaprofesional, especialidad, fechanacimiento, telefono 
	from usuario 
	where Rol = @rol
end

/*#procedimiento almacenado ConsultaHistoria--------------------------------------------------------------------------------------*/

CREATE PROCEDURE ConsHistoriaClinica

	@Doc bigint

as
begin
	SELECT hc.id_historialclinico, hc.cedula, u.nombres, u.apellidos, u.rol, 
           hc.estatura, hc.peso, ep.enfermedad_padecida, a.alergia, 
           t.historial_tratamiento
    FROM usuario u 
    INNER JOIN historiaclinica hc ON u.cedulausuario = hc.cedula 
    INNER JOIN enfermedadpadecida ep ON hc.id_historialclinico = ep.id_historialclinico 
    INNER JOIN alergia a ON ep.id_historialclinico = a.id_historialclinico 
    INNER JOIN tratamiento t ON a.id_historialclinico = t.id_historialclinico 
    WHERE @Doc = hc.Cedula;
END;
go

/*procedimiento consulta agenda -------------------------------------------------------------------------------*/
CREATE PROCEDURE ConsAgenda
	@Doc bigint
as
begin
	SELECT a.codigoagenda, a.ceduladoctor, c.id_cita, c.cedula_paciente,u.nombres, u.apellidos, c.hora_atencion, c.fecha_atencion,c.consultorio, c.motivo
	from usuario u
	INNER JOIN agenda a ON u.Cedulausuario = a.ceduladoctor
	INNER JOIN cita	c ON a.ceduladoctor = c.cedula_doctor_atiende
	where a.ceduladoctor = @Doc;
END;







