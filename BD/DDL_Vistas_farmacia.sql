USE sicefa;

-- EMPLEADO ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

DROP VIEW IF EXISTS v_empleado;
CREATE VIEW v_empleado AS
    SELECT  
            E.idEmpleado,
			E.codigo,
            DATE_FORMAT(E.fechaIngreso, '%Y-%m-%d') AS fechaIngreso,
            E.puesto,
            E.email,
            E.salarioBruto,
            E.activo,
            P.idPersona,
            P.nombre,
            P.apellidoPaterno,
            P.apellidoMaterno,
            P.genero,
            P.fechaNacimiento,
            P.rfc,
            P.curp,
            P.domicilio,
            P.codigoPostal,
            P.ciudad,
            P.estado,
            P.telefono,
            P.foto,
            U.idUsuario,
            U.nombreUsuario,
            U.contrasenia,
            U.rol,
            S.idSucursal,
            S.nombre AS nombre_sucursal,
            S.titular,
            S.rfc AS rfc_sucursal,
            S.domicilio AS domicilio_sucursal,
            S.colonia AS colonia_sucursal,
            S.codigoPostal AS cp_sucursal,
            S.ciudad AS ciudad_sucursal,
            S.estado AS estado_sucursal,
            S.telefono AS telefono_sucursal,
            S.latitud,
            S.longitud,
            S.estatus AS estatus_sucursal
    FROM    empleado E
            INNER JOIN  persona  P ON P.idPersona = E.idPersona 
            INNER JOIN  usuario  U ON U.idUsuario = E.idUsuario
            INNER JOIN  sucursal S ON S.idSucursal = E.idSucursal;
            
SELECT * FROM v_empleado;

-- PRODUCTO ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
CREATE VIEW v_producto AS
			SELECT
				P.idProducto, 
				P.nombreProducto AS nombreProducto, 
				P.nombreGenerico, 
				P.formaFarmaceutica, 
				P.unidadMedida, 
				P.presentacion, 
				P.principalIndicacion, 
				P.contraindicaciones, 
				P.concentracion, 
				P.unidadesEnvase, 
				P.precioCompra, 
				P.precioVenta, 
				P.foto, 
				P.rutaFoto, 
				P.codigoBarras, 
				P.estatus
            FROM producto P;
            
SELECT * FROM v_producto;

-- SUCURSAL /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

DROP VIEW IF EXISTS v_sucursal;
CREATE VIEW v_sucursal AS
    SELECT
        S.idSucursal,
        S.nombre AS nombre_sucursal,
        S.titular,
        S.rfc AS rfc_sucursal,
        S.domicilio AS domicilio_sucursal,
        S.colonia AS colonia_sucursal,
        S.codigoPostal AS cp_sucursal,
        S.ciudad AS ciudad_sucursal,
        S.estado AS estado_sucursal,
        S.telefono AS telefono_sucursal,
        S.latitud,
        S.longitud,
        S.estatus AS estatus_sucursal
    FROM sucursal S;

SELECT * FROM v_sucursal;



-- CLIENTE //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DROP VIEW IF EXISTS v_cliente;
CREATE VIEW v_cliente AS
    SELECT  
            C.idCliente,
            C.email,
            DATE_FORMAT(C.fechaRegistro, '%Y-%m-%d') AS fechaRegistro,
            C.estatus,
            P.*
    FROM    cliente C
            INNER JOIN  persona  P ON P.idPersona = C.idPersona;
	
            SELECT * FROM v_cliente;
            
            
-- PROVEDOR //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DROP VIEW IF EXISTS v_provedor;
            
CREATE VIEW v_provedor AS
    SELECT  
            PR.idProvedor,
            PR.email,
            DATE_FORMAT(PR.fechaRegistro, '%Y-%m-%d') AS fechaRegistro,
            PR.estatus,
            P.*
    FROM    provedor PR
            INNER JOIN  persona  P ON P.idPersona = PR.idPersona;
            
            DROP PROCEDURE IF EXISTS eliminarCliente;
DELIMITER $$

SELECT * FROM v_provedor;            
            