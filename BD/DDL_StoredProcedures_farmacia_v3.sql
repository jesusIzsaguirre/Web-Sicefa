-- -----------------------------------------------------
-- Artifact:    DDL_StoredProcedures_farmacia_v3.sql
-- Version:     3.0
-- Date:        2023-05-02 12:50:00
-- Author:      Miguel Angel Gil Rios
-- Email:       mgil@utleon.edu.mx
--              angel.grios@gmail.com
-- Comments:    Se agregaron procedimientos almacenados
--              para insertar sucursales y empleados.
-- -----------------------------------------------------
USE sicefa;


-- EMPLEADO //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Procedimiento Almacenado para generar el codigo de un nuevo empleado.
DROP PROCEDURE IF EXISTS generarCodigoEmpleado;
DELIMITER $$
CREATE PROCEDURE generarCodigoEmpleado(OUT codigo VARCHAR(8))
	BEGIN
		DECLARE anio INT;
		DECLARE mes VARCHAR(2);
		DECLARE num VARCHAR(4);
		SET anio  = RIGHT(year(now()),2);
		SET mes   = LPAD(RIGHT(month(now()),2), 2, '0');
		SET num   = (SELECT LPAD(MAX(idUsuario) + 1, 4, '0') FROM usuario);
		SET codigo= CONCAT(anio,mes,num);
	END
$$
DELIMITER ;

-- Procedimiento almacenado para insertar un nuevo Empleado.
DROP PROCEDURE IF EXISTS insertarEmpleado;
DELIMITER $$
CREATE PROCEDURE insertarEmpleado(/* Datos Personales */
                                    IN	var_nombre          VARCHAR(64),    --  1
                                    IN	var_apellidoPaterno VARCHAR(64),    --  2
                                    IN	var_apellidoMaterno VARCHAR(64),    --  3
                                    IN  var_genero          VARCHAR(2),     --  4
                                    IN  var_fechaNacimiento VARCHAR(11),    --  5
                                    IN  var_rfc             VARCHAR(14),    --  6
                                    IN  var_curp            VARCHAR(19),    --  7
                                    IN	var_domicilio       VARCHAR(129),   --  8
                                    IN  var_cp              VARCHAR(11),    --  9
                                    IN  var_ciudad          VARCHAR(46),    -- 10
                                    IN  var_estado          VARCHAR(40),    -- 11
                                    IN	var_telefono        VARCHAR(20),    -- 12
                                    IN	var_foto            LONGTEXT,       -- 13
                                    
                                  /* Datos del la Sucursal */
                                    IN  var_idSucursal      INT,            -- 14
                                    
                                  /* Datos del Usuario    */
                                    IN  var_rol             VARCHAR(10),    -- 15
                                    
                                  /* Datos del Empleado */
                                    IN  var_email           VARCHAR(65),    -- 16
                                    IN  var_puesto          VARCHAR(25),    -- 17
                                    IN  var_salarioBruto    FLOAT,          -- 18
                                  
                                  /* Parametros de Salida */
                                    OUT var_idPersona       INT,            -- 19
                                    OUT var_idUsuario       INT,            -- 20
                                    OUT var_idEmpleado      INT,            -- 21
                                    OUT var_codigoEmpleado  VARCHAR(9)      -- 22
                                 )
    BEGIN
        -- Comenzamos insertando los datos de la Persona:
        INSERT INTO persona (nombre, apellidoPaterno, apellidoMaterno, genero,
                             fechaNacimiento, rfc, curp, domicilio, codigoPostal, 
                             ciudad, estado, telefono, foto)
                    VALUES( var_nombre, var_apellidoPaterno, var_apellidoMaterno, 
                            var_genero, STR_TO_DATE(var_fechaNacimiento, '%d/%m/%Y'),
                            var_rfc, var_curp, var_domicilio, var_cp,
                            var_ciudad, var_estado, var_telefono, var_foto);
        
        -- Obtenemos el ID de Persona que se genero:
        SET var_idPersona = LAST_INSERT_ID(); 
        
        -- Generamos el Codigo del Empleado porque lo necesitamos
        -- para generar el usuario:
        CALL generarCodigoEmpleado(var_codigoEmpleado);
        
        -- Insertamos los datos del Usuario que tendra el Empleado:
        INSERT INTO usuario (nombreUsuario, contrasenia, rol)
                    VALUES (var_codigoEmpleado, var_codigoEmpleado, var_rol);
        -- Recuperamos el ID de Usuario generado:
        SET var_idUsuario = LAST_INSERT_ID(); 
        
        -- Insertamos los datos del Empleado:
        INSERT INTO empleado(email, codigo, fechaIngreso, puesto, salarioBruto, activo,
                             idPersona, idUsuario, idSucursal)
                    VALUES(var_email, var_codigoEmpleado, NOW(), var_puesto, var_salarioBruto,
                           1, var_idPersona, var_idUsuario, var_idSucursal);
                           SET var_idEmpleado=LAST_INSERT_ID();
    END
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS eliminarEmpleado;
DELIMITER $$

CREATE PROCEDURE eliminarEmpleado(
    IN var_idEmpleado INT  -- ID del Cliente a eliminar
)
BEGIN
    DECLARE var_empleadoActivo INT;

    -- Verificamos si el cliente está activo
    SELECT activo INTO var_empleadoActivo
    FROM empleado
    WHERE idEmpleado = var_idEmpleado;

    -- Si el cliente está activo (estatus = 1), procedemos a desactivarlo (estatus = 0)
    IF var_empleadoActivo = 1 THEN
        UPDATE empleado
        SET activo = 0
        WHERE idEmpleado = var_idEmpleado;

    END IF;
END $$

DELIMITER ;

use sicefa;

DROP PROCEDURE IF EXISTS modificarEmpleado;
DELIMITER $$

CREATE PROCEDURE modificarEmpleado(
    IN var_idEmpleado INT,
    IN var_nombre VARCHAR(64),
    IN var_apellidoPaterno VARCHAR(64),
    IN var_apellidoMaterno VARCHAR(64),
    IN var_genero VARCHAR(2),
    IN var_fechaNacimiento VARCHAR(11),
    IN var_rfc VARCHAR(14),
    IN var_curp VARCHAR(19),
    IN var_domicilio VARCHAR(129),
    IN var_cp VARCHAR(11),
    IN var_ciudad VARCHAR(46),
    IN var_estado VARCHAR(40),
    IN var_telefono VARCHAR(20),
    IN var_foto LONGTEXT,
    IN var_email VARCHAR(65),
    IN var_puesto VARCHAR(25),
    IN var_salarioBruto FLOAT,
    IN var_rol VARCHAR(10)
    
)
BEGIN
    -- Actualizar datos personales
    UPDATE persona
    SET
        nombre = var_nombre,
        apellidoPaterno = var_apellidoPaterno,
        apellidoMaterno = var_apellidoMaterno,
        genero = var_genero,
        fechaNacimiento = STR_TO_DATE(var_fechaNacimiento, '%d/%m/%Y'),
        rfc = var_rfc,
        curp = var_curp,
        domicilio = var_domicilio,
        codigoPostal = var_cp,
        ciudad = var_ciudad,
        estado = var_estado,
        telefono = var_telefono,
        foto = var_foto
    WHERE idPersona = (SELECT idPersona FROM empleado WHERE idEmpleado = var_idEmpleado);

    -- Actualizar datos del usuario
    UPDATE usuario
    
    SET rol = var_rol
    WHERE idUsuario = (SELECT idUsuario FROM empleado WHERE idEmpleado = var_idEmpleado);

    -- Actualizar datos del empleado
    UPDATE empleado
    SET
        email = var_email,
        puesto = var_puesto,
        salarioBruto = var_salarioBruto
    WHERE idEmpleado = var_idEmpleado;
END $$

DELIMITER ;

-- SUCURSAL /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- Procedimiento almacenado para insertar una nueva sucursal.
--      Esta operacion implica que, al agregar una nueva sucursal,
--      de forma automatica se agregara un usuario administrador,
--      lo cual implica, la insercion de un empleado y una persona.
DROP PROCEDURE IF EXISTS insertarSucursal;
DELIMITER $$
CREATE PROCEDURE insertarSucursal(/* Datos Sucursal */
                                    IN	var_nombre          VARCHAR(49),    --  1
                                    IN	var_titular         VARCHAR(49),    --  2
                                    IN  var_rfc             VARCHAR(15),    --  3                                    
                                    IN	var_domicilio       VARCHAR(129),   --  4
                                    IN  var_colonia         VARCHAR(65),    --  5
                                    IN  var_codigoPostal    VARCHAR(11),    --  6
                                    IN  var_ciudad          VARCHAR(65),    --  7
                                    IN  var_estado          VARCHAR(49),    --  8                                    
                                    IN	var_telefono        VARCHAR(20),    --  9
                                    IN	var_latitud         VARCHAR(65),    -- 10
                                    IN	var_longitud        VARCHAR(65),    -- 11
                                    IN  var_estatus         INT,            -- 12
                                    
                                  /* Parametros de Salida */
                                    OUT  var_idSucursal     INT            -- 13
                                 )
    BEGIN
        -- Comenzamos insertando los datos de la Sucursal:
        INSERT INTO sucursal(nombre, titular, rfc, domicilio, colonia, codigoPostal,
                             ciudad, estado, telefono, latitud, longitud, estatus)
                    VALUES(var_nombre, var_titular, var_rfc, var_domicilio, var_colonia, var_codigoPostal,
                           var_ciudad, var_estado, var_telefono, var_latitud, var_longitud, var_estatus);
        
        -- Recuperamos el ID de la Sucursal que se genero:
        SET var_idSucursal = LAST_INSERT_ID();
    END
$$
DELIMITER ;

-- Procedimiento para modificar sucursal

DROP PROCEDURE IF EXISTS modificarSucursal;
DELIMITER $$
CREATE PROCEDURE modificarSucursal(
	IN var_idSucursal		 INT,			-- 1
    IN  var_nombre           VARCHAR(49),   -- 2
    IN  var_titular          VARCHAR(49),   -- 3
    IN  var_rfc              VARCHAR(15),   -- 4                                    
    IN  var_domicilio        VARCHAR(129),  -- 5
    IN  var_colonia          VARCHAR(65),   -- 6
    IN  var_codigoPostal     VARCHAR(11),   -- 7
    IN  var_ciudad           VARCHAR(65),   -- 8
    IN  var_estado           VARCHAR(49),   -- 9                               
    IN  var_telefono         VARCHAR(20),   -- 10
    IN  var_latitud          VARCHAR(65),   -- 11
    IN  var_longitud         VARCHAR(65),   -- 12
    IN  var_estatus          INT            -- 13
)
BEGIN
    -- Modificamos los datos de la Sucursal:
    UPDATE sucursal
    SET nombre = var_nombre,
        titular = var_titular,
        rfc = var_rfc,
        domicilio = var_domicilio,
        colonia = var_colonia,
        codigoPostal = var_codigoPostal,
        ciudad = var_ciudad,
        estado = var_estado,
        telefono = var_telefono,
        latitud = var_latitud,
        longitud = var_longitud,
        estatus = var_estatus
    WHERE idSucursal = var_idSucursal;
END
$$
DELIMITER ;

    
DROP PROCEDURE IF EXISTS eliminarSucursal;
DELIMITER $$

CREATE PROCEDURE eliminarSucursal(
    IN var_idSucursal INT  -- ID de la Sucursal a eliminar
)
BEGIN
    DECLARE var_sucursalActiva INT;

    -- Verificamos si la sucursal está activa
    SELECT estatus INTO var_sucursalActiva
    FROM sucursal
    WHERE idSucursal = var_idSucursal;

    -- Si la sucursal está activa (estatus = 1), procedemos a desactivarlo (estatus = 0)
    IF var_sucursalActiva = 1 THEN
        UPDATE sucursal
        SET estatus = 0
        WHERE idSucursal = var_idSucursal;

    END IF;
END $$

DELIMITER ;
    

-- PRODUCTO ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Procedimiento almacenado de productos
DROP PROCEDURE IF EXISTS insertarProducto;
DELIMITER $$
CREATE PROCEDURE insertarProducto(
								  IN var_nombreProducto	VARCHAR(180), 		-- 1
								  IN var_nombreGenerico	VARCHAR(200),		-- 2
								  IN var_formaFarmaceutica VARCHAR(100),	-- 3
								  IN var_unid2adMedida VARCHAR(25),			-- 4
								  IN var_presentacion VARCHAR(200),			-- 5
								  IN var_principalIndicacion VARCHAR(255),	-- 6
								  IN var_contraindicaciones VARCHAR(255),	-- 7
								  IN var_concentracion VARCHAR(255),		-- 8
								  IN var_unidadesEnvase INT,				-- 9
								  IN var_precioCompra FLOAT,				-- 10
								  IN var_precioVenta FLOAT,					-- 11
								  IN var_foto LONGTEXT,						-- 12
								  IN var_rutaFoto VARCHAR(254),				-- 13
								  IN var_codigoBarras VARCHAR(65),			-- 14
								  IN var_estatus INT,						-- 15
                                  OUT var_idProducto INT					-- 16
                                 )
    BEGIN
        -- Insertamos los datos de Productos:
      INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, 
      formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, 
      contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus)
      VALUES(var_idProducto, var_nombreProducto, var_nombreGenerico, 
      var_formaFarmaceutica, var_unid2adMedida, var_presentacion, var_principalIndicacion, 
      var_contraindicaciones, var_concentracion, var_unidadesEnvase, var_precioCompra, var_precioVenta, var_foto, var_rutaFoto, var_codigoBarras, var_estatus);
      SET var_idProducto=LAST_INSERT_ID();

    END
$$
DELIMITER ;

-- Procedimiento modificar producto
DROP PROCEDURE IF EXISTS modificarProducto;
DELIMITER $$
CREATE PROCEDURE modificarProducto(IN var_idProducto INT,
								   IN var_nombreProducto	VARCHAR(180), 	-- 1
								  IN var_nombreGenerico	VARCHAR(200),		-- 2
								  IN var_formaFarmaceutica VARCHAR(100),	-- 3
								  IN var_unid2adMedida VARCHAR(25),			-- 4
								  IN var_presentacion VARCHAR(200),			-- 5
								  IN var_principalIndicacion VARCHAR(255),	-- 6
								  IN var_contraindicaciones VARCHAR(255),	-- 7
								  IN var_concentracion VARCHAR(255),		-- 8
								  IN var_unidadesEnvase INT,				-- 9
								  IN var_precioCompra FLOAT,				-- 10
								  IN var_precioVenta FLOAT,					-- 11
								  IN var_foto LONGTEXT,						-- 12
								  IN var_rutaFoto VARCHAR(254),				-- 13
								  IN var_codigoBarras VARCHAR(65),			-- 14
								  IN var_estatus INT						-- 15
)
BEGIN
    -- Modificamos los datos del Producto:
    UPDATE producto
				SET nombreProducto=var_nombreProducto,	
					nombreGenerico=var_nombreGenerico,	
					formaFarmaceutica=var_formaFarmaceutica,
					unidadMedida=var_unid2adMedida,
					presentacion=var_presentacion, 
					principalIndicacion=var_principalIndicacion, 
					contraindicaciones=var_contraindicaciones,
					concentracion=var_concentracion, 
					unidadesEnvase=var_unidadesEnvase,
					precioCompra=var_precioCompra, 
					precioVenta=var_precioVenta,
					foto=var_foto, 
					rutaFoto=var_rutaFoto, 
					codigoBarras=var_codigoBarras, 
					estatus=var_estatus
    WHERE idProducto = var_idProducto;
END
$$
DELIMITER ;

-- Procedimiento para eliminar producto
DROP PROCEDURE IF EXISTS eliminarProducto;
DELIMITER $$

CREATE PROCEDURE eliminarProducto(
    IN var_idProducto INT  -- ID de la Sucursal a eliminar
)
BEGIN
    DECLARE var_productoActivo INT;

    SELECT estatus INTO var_productoActivo
    FROM producto
    WHERE idProducto = var_idProducto;
    IF var_productoActivo = 1 THEN
        UPDATE producto
        SET estatus = 0
        WHERE idProducto = var_idProducto;

    END IF;
END $$

DELIMITER ;


-- CLIENTE //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


DROP PROCEDURE IF EXISTS insertarCliente;
DELIMITER $$
CREATE PROCEDURE insertarCliente(/* Datos Personales */
                                    IN	var_nombre          VARCHAR(64),    --  1
                                    IN	var_apellidoPaterno VARCHAR(64),    --  2
                                    IN	var_apellidoMaterno VARCHAR(64),    --  3
                                    IN  var_genero          VARCHAR(2),     --  4
                                    IN  var_fechaNacimiento VARCHAR(11),    --  5
                                    IN  var_rfc             VARCHAR(14),    --  6
                                    IN  var_curp            VARCHAR(19),    --  7
                                    IN	var_domicilio       VARCHAR(129),   --  8
                                    IN  var_cp              VARCHAR(11),    --  9
                                    IN  var_ciudad          VARCHAR(46),    -- 10
                                    IN  var_estado          VARCHAR(40),    -- 11
                                    IN	var_telefono        VARCHAR(20),    -- 12
                                    IN	var_foto            LONGTEXT,       -- 13
                                    
                                  
                                    
                                  /* Datos del Cliente */
                                    IN  var_email           VARCHAR(65),    -- 14
                                    IN  var_fechaRegistro   VARCHAR(11),    -- 15
                                    IN  var_estatus    		int,          -- 16
                                  
                                  /* Parametros de Salida */
                                    OUT var_idPersona       INT,            -- 17
                                    OUT var_idCliente      INT            -- 18

                                 )
    BEGIN
        -- Comenzamos insertando los datos de la Persona:
        INSERT INTO persona (nombre, apellidoPaterno, apellidoMaterno, genero,
                             fechaNacimiento, rfc, curp, domicilio, codigoPostal, 
                             ciudad, estado, telefono, foto)
                    VALUES( var_nombre, var_apellidoPaterno, var_apellidoMaterno, 
                            var_genero, STR_TO_DATE(var_fechaNacimiento, '%d/%m/%Y'),
                            var_rfc, var_curp, var_domicilio, var_cp,
                            var_ciudad, var_estado, var_telefono, var_foto);
        
        -- Obtenemos el ID de Persona que se genero:
        SET var_idPersona = LAST_INSERT_ID(); 
        

        -- Insertamos los datos del Cliente
        INSERT INTO cliente(email, fechaRegistro, estatus, idPersona)
                    VALUES(var_email,STR_TO_DATE(var_fechaRegistro,'%d/%m/%Y') , 1, var_idPersona);
		SET var_idCliente = LAST_INSERT_ID();
    END
$$
DELIMITER ;

-- Modificaciones
DROP PROCEDURE IF EXISTS modificarCliente;
DELIMITER $$

CREATE PROCEDURE modificarCliente(
    /* Datos Personales */
    IN  var_idCliente       INT,            -- ID del Cliente a modificar
    IN  var_nombre          VARCHAR(64),    --  1
    IN  var_apellidoPaterno VARCHAR(64),    --  2
    IN  var_apellidoMaterno VARCHAR(64),    --  3
    IN  var_genero          VARCHAR(2),     --  4
    IN  var_fechaNacimiento VARCHAR(11),    --  5
    IN  var_rfc             VARCHAR(14),    --  6
    IN  var_curp            VARCHAR(19),    --  7
    IN  var_domicilio       VARCHAR(129),   --  8
    IN  var_cp              VARCHAR(11),    --  9
    IN  var_ciudad          VARCHAR(46),    -- 10
    IN  var_estado          VARCHAR(40),    -- 11
    IN  var_telefono        VARCHAR(20),    -- 12
    IN  var_foto            LONGTEXT,       -- 13
    
    /* Datos del Cliente */
    IN  var_email           VARCHAR(65),    -- 14
    IN  var_fechaRegistro   VARCHAR(11),    -- 15
    IN  var_estatus         INT             -- 16
)
BEGIN
    -- Modificamos los datos de la Persona asociada al Cliente:
    UPDATE persona
    SET nombre = var_nombre,
        apellidoPaterno = var_apellidoPaterno,
        apellidoMaterno = var_apellidoMaterno,
        genero = var_genero,
        fechaNacimiento = STR_TO_DATE(var_fechaNacimiento, '%d/%m/%Y'),
        rfc = var_rfc,
        curp = var_curp,
        domicilio = var_domicilio,
        codigoPostal = var_cp,
        ciudad = var_ciudad,
        estado = var_estado,
        telefono = var_telefono,
        foto = var_foto
    WHERE idPersona = (
        SELECT idPersona
        FROM cliente
        WHERE idCliente = var_idCliente
    );

    -- Modificamos los datos del Cliente sin modificar el idCliente:
    UPDATE cliente
    SET email = var_email,
        fechaRegistro = STR_TO_DATE(var_fechaRegistro, '%d/%m/%Y'),
        estatus = var_estatus
    WHERE idCliente = var_idCliente;
END
$$

DELIMITER ;


DROP PROCEDURE IF EXISTS eliminarCliente;
DELIMITER $$

CREATE PROCEDURE eliminarCliente(
    IN var_idCliente INT  -- ID del Cliente a eliminar
)
BEGIN
    DECLARE var_clienteActivo INT;

    -- Verificamos si el cliente está activo
    SELECT estatus INTO var_clienteActivo
    FROM cliente
    WHERE idCliente = var_idCliente;

    -- Si el cliente está activo (estatus = 1), procedemos a desactivarlo (estatus = 0)
    IF var_clienteActivo = 1 THEN
        UPDATE cliente
        SET estatus = 0
        WHERE idCliente = var_idCliente;

    END IF;
END $$

DELIMITER ;

-- PROVEDOR /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


DROP PROCEDURE IF EXISTS insertarProvedor;
DELIMITER $$
CREATE PROCEDURE insertarProvedor(/* Datos Personales */
                                    IN	var_nombre          VARCHAR(64),    --  1
                                    IN	var_apellidoPaterno VARCHAR(64),    --  2
                                    IN	var_apellidoMaterno VARCHAR(64),    --  3
                                    IN  var_genero          VARCHAR(2),     --  4
                                    IN  var_fechaNacimiento VARCHAR(11),    --  5
                                    IN  var_rfc             VARCHAR(14),    --  6
                                    IN  var_curp            VARCHAR(19),    --  7
                                    IN	var_domicilio       VARCHAR(129),   --  8
                                    IN  var_cp              VARCHAR(11),    --  9
                                    IN  var_ciudad          VARCHAR(46),    -- 10
                                    IN  var_estado          VARCHAR(40),    -- 11
                                    IN	var_telefono        VARCHAR(20),    -- 12
                                    IN	var_foto            LONGTEXT,       -- 13
                                    
                                  
                                    
                                  /* Datos del Cliente */
                                    IN  var_email           VARCHAR(65),    -- 14
                                    IN  var_fechaRegistro   VARCHAR(11),    -- 15
                                    IN  var_estatus    		int,          -- 16
                                  
                                  /* Parametros de Salida */
                                    OUT var_idPersona       INT,            -- 17
                                    OUT var_idProvedor      INT            -- 18

                                 )
    BEGIN
        -- Comenzamos insertando los datos de la Persona:
        INSERT INTO persona (nombre, apellidoPaterno, apellidoMaterno, genero,
                             fechaNacimiento, rfc, curp, domicilio, codigoPostal, 
                             ciudad, estado, telefono, foto)
                    VALUES( var_nombre, var_apellidoPaterno, var_apellidoMaterno, 
                            var_genero, STR_TO_DATE(var_fechaNacimiento, '%d/%m/%Y'),
                            var_rfc, var_curp, var_domicilio, var_cp,
                            var_ciudad, var_estado, var_telefono, var_foto);
        
        -- Obtenemos el ID de Persona que se genero:
        SET var_idPersona = LAST_INSERT_ID(); 
        

        -- Insertamos los datos del Cliente
        INSERT INTO provedor(email, fechaRegistro, estatus, idPersona)
                    VALUES(var_email,STR_TO_DATE(var_fechaRegistro,'%d/%m/%Y') , 1, var_idPersona);
		SET var_idProvedor = LAST_INSERT_ID();
    END
$$
DELIMITER ;

-- Modificaciones
DROP PROCEDURE IF EXISTS modificarProvedor;
DELIMITER $$
CREATE PROCEDURE modificarProvedor(
    /* Datos Personales */
    IN  var_idProvedor       INT,            -- ID del Provedor a modificar
    IN  var_nombre          VARCHAR(64),    --  1
    IN  var_apellidoPaterno VARCHAR(64),    --  2
    IN  var_apellidoMaterno VARCHAR(64),    --  3
    IN  var_genero          VARCHAR(2),     --  4
    IN  var_fechaNacimiento VARCHAR(11),    --  5
    IN  var_rfc             VARCHAR(14),    --  6
    IN  var_curp            VARCHAR(19),    --  7
    IN  var_domicilio       VARCHAR(129),   --  8
    IN  var_cp              VARCHAR(11),    --  9
    IN  var_ciudad          VARCHAR(46),    -- 10
    IN  var_estado          VARCHAR(40),    -- 11
    IN  var_telefono        VARCHAR(20),    -- 12
    IN  var_foto            LONGTEXT,       -- 13
    
    /* Datos del Provedor */
    IN  var_email           VARCHAR(65),    -- 14
    IN  var_fechaRegistro   VARCHAR(11),    -- 15
    IN  var_estatus         INT             -- 16
)
BEGIN
    -- Modificamos los datos de la Persona asociada al Provedor:
    UPDATE persona
    SET nombre = var_nombre,
        apellidoPaterno = var_apellidoPaterno,
        apellidoMaterno = var_apellidoMaterno,
        genero = var_genero,
        fechaNacimiento = STR_TO_DATE(var_fechaNacimiento, '%d/%m/%Y'),
        rfc = var_rfc,
        curp = var_curp,
        domicilio = var_domicilio,
        codigoPostal = var_cp,
        ciudad = var_ciudad,
        estado = var_estado,
        telefono = var_telefono,
        foto = var_foto
    WHERE idPersona = (
        SELECT idPersona
        FROM provedor
        WHERE idProvedor = var_idProvedor
    );

    -- Modificamos los datos del Provedor:
    UPDATE provedor
    SET email = var_email,
        fechaRegistro = STR_TO_DATE(var_fechaRegistro, '%d/%m/%Y'),
        estatus = var_estatus
    WHERE idProvedor = var_idProvedor;
END
$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE eliminarProvedor(
    IN var_idProvedor INT  -- ID del Cliente a eliminar
)
BEGIN
    DECLARE var_provedorActivo INT;

    -- Verificamos si el cliente está activo
    SELECT estatus INTO var_provedorActivo
    FROM provedor
    WHERE idProvedor = var_idProvedor;

    -- Si el cliente está activo (estatus = 1), procedemos a desactivarlo (estatus = 0)
    IF var_provedorActivo = 1 THEN
        UPDATE provedor
        SET estatus = 0
        WHERE idProvedor = var_idProvedor;

    END IF;
END $$

DELIMITER ;

