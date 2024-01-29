-- -----------------------------------------------------
-- Artifact:    DML_farmacia_v3.sql
-- Version:     3.0
-- Date:        2023-05-03 09:00:00
-- Author:      Miguel Angel Gil Rios
-- Email:       mgil@utleon.edu.mx
--              angel.grios@gmail.com
-- Comments:    Se definieron los registros
--              que de manera predeterminada
--              debe tener la base de datos para que
--              el sistema funcione correctamente 
--              cuando no hay informacion ya que,
--              por lo menos, debe haber un usuario
--              administrador del sistema central.
--
--              Adicionalmente, se genero un catalogo
--              inicial de productos.                
-- -----------------------------------------------------

USE sicefa;

/* Agregamos la Sucursal Central */
INSERT INTO sucursal (idSucursal, nombre, titular, rfc, domicilio, colonia, codigoPostal,
                      ciudad, estado, telefono, latitud, longitud, estatus)
            VALUES (1, 'Sucursal Central', 'Medicamos tu Vida', '', 'Blvd. Universidad Tecnológica #225', 'San Carlos', '37670',
                    'Leon', 'Guanajuato', '477 710 00 20', '21.06353483110673', '-101.57969394332699', 1);
                    
INSERT INTO usuario (idUsuario, nombreUsuario, contrasenia, rol) VALUES(1, 'Administrador', 'Administrador', 'ADMC');

INSERT INTO persona (idPersona, nombre, apellidoPaterno, apellidoMaterno, genero, 
                     fechaNacimiento, rfc, curp, domicilio, codigoPostal, ciudad, estado, telefono, foto)
            VALUES  (1, 'Administrador', '', '', 'O', STR_TO_DATE('01/01/1901', '%d/%m/%Y'), '', '', '', '', '', '', '', '');
            

INSERT INTO empleado (idEmpleado, email, codigo, fechaIngreso, puesto, salarioBruto, activo, 
                      idPersona, idUsuario, idSucursal)
            VALUES   (1, '', '00000000', STR_TO_DATE('01/01/1901', '%d/%m/%Y'), 'Administrador', 0.0, 1,
                      1, 1, 1);
                      
-- CLIENTE ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

INSERT INTO persona (idPersona, nombre, apellidoPaterno, apellidoMaterno, genero, 
                     fechaNacimiento, rfc, curp, domicilio, codigoPostal, ciudad, estado, telefono, foto)
            VALUES  (3, 'Antonio de Jesus', 'Cruz', 'Acosta', 'H', STR_TO_DATE('13/06/2003', '%d/%m/%Y'), 'AJCA13062003', 'CAAJ23MDJSD231S', 'Av.Oaxaca', '37266', 'Oaxaca', 'Oaxaquiña', '4772349845', 'www.google.com');

INSERT INTO persona (idPersona, nombre, apellidoPaterno, apellidoMaterno, genero, 
                     fechaNacimiento, rfc, curp, domicilio, codigoPostal, ciudad, estado, telefono, foto)
            VALUES  (4, 'Henry', 'La Bomba', 'Martin', 'H', STR_TO_DATE('12/08/2001', '%d/%m/%Y'), 'AJDD3062003', 'CAAJAASSDJSD231S', 'Av.Ulises', '37266', 'Sinaloa', 'Colindres', '4772349845', 'www.google.com');
            
            
INSERT INTO cliente (idCliente, email, fechaRegistro, estatus, idPersona)
			VALUES (1,'cruzito@gmail.com',STR_TO_DATE('13/11/2023', '%d/%m/%Y'), 1, 3);

INSERT INTO cliente (idCliente, email, fechaRegistro, estatus, idPersona)
			VALUES (2,'Labomba@gmail.com',STR_TO_DATE('13/11/2023', '%d/%m/%Y'), 1, 4);
            
            select * from persona;
            
-- PROVEDOR ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


INSERT INTO persona (idPersona, nombre, apellidoPaterno, apellidoMaterno, genero, 
                     fechaNacimiento, rfc, curp, domicilio, codigoPostal, ciudad, estado, telefono, foto)
            VALUES  (5, 'Leonardo Fabian', 'Anaya', 'Reyes', 'H', STR_TO_DATE('18/04/2002', '%d/%m/%Y'), 'LFAR18042003', 'LFAR1804', 'Manantiales', '37219', 'León', 'Guanajuato', '4771234567', 'www.google.com');

INSERT INTO provedor (idProvedor, email, fechaRegistro, estatus, idPersona)
			VALUES (1,'fabianin@gmail.com',STR_TO_DATE('12/11/2023', '%d/%m/%Y'), 1, 5);           
            
            
SELECT * FROM Persona;
             


/******************* Catalogo Inicial de Medicamentos *****************************/
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(1, 'Donepecilo', 'Donepecilo, Clorhidrato de', 'tableta', 'Tableta', 'Envase con 14 tabletas.', 'Enfermedad de Alzheimer.', 'Hipersensibilidad al fármaco o a los derivados de piperidina.', '10 mg', 14, 466.9, 547, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(2, 'Etambutol', 'Etambutol, Clorhidrato de', 'tableta', 'Tableta', 'Envase con 50 tabletas.', 'Tuberculosis.', 'Hipersensibilidad al fármaco, neuritis óptica y en menores de 12 años.', '400 mg', 50, 65.71, 210, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(3, 'Efavirenz', 'Efavirenz', 'comprimido recubierto', 'Comprimido', 'Envase con 30 comprimidos recubiertos.', 'Infección por Virus de Inmunodeficiencia Humana (VIH), en combinación con otros antirretrovirales.', 'Hipersensibilidad al fármaco.', '600 mg', 30, 134.19, 254, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(4, 'Ciprofibrato', 'Ciprofibrato', 'cápsula o tableta', 'Cápsula', 'Envase con 30 cápsulas o tabletas.', 'Hiperlipidemias tipo IIb y IV.', 'Hipersensibilidad al fármaco. Insuficiencia hepática o renal. Embarazo y lactancia.', '100 mg', 30, 551.32, 665, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(5, 'Lidocaína', 'Lidocaína, Clorhidrato de', 'gel', 'Mililitro', 'Envase con 20 ml.', '1. Anestesia local.', 'Hipersensibilidad conocida a anestésicos locales de tipo amida o a los otros componentes de la fórmula.', '20 mg / ml', 20, 28.86, 306, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(6, 'Ambroxol', 'Ambroxol, Clorhidrato de', 'solución', 'Mililitro', 'Envase con 120 ml y dosificador.', 'Bronquitis', 'Hipersensibilidad al fármaco.', '300 mg/100 ml', 120, 215.79, 277, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(7, 'Metronidazol', 'Metronidazol', 'óvulo o tableta vaginal', 'Óvulo', 'Envase con 10 óvulos o tabletas.', '1. Tricomoniasis vaginal', 'Hipersensibilidad al fármaco.', '500 mg', 10, 616.72, 973, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(8, 'Nitrofural', 'Nitrofural', 'óvulo', 'Óvulo', 'Envase con 6 óvulos.', '1. Vaginitis bacteriana', 'Hipersensibilidad al fármaco.', '6 mg', 6, 117.98, 213, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(9, 'Ibuprofeno', 'Ibuprofeno', 'cápsula', 'Miligramo', 'Envase con 30 cápsulas', '1. Dolor de leve a moderado.', 'NINGUNA', '400 mg', 30, 29.3, 537, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(10, 'Montelukast', 'Montelukast sódico', 'comprimido recubierto', 'Comprimido', 'Envase con 30 comprimidos.', '1. Asma bronquial', 'Hipersensibilidad al fármaco. No es de primera elección en el ataque agudo de asma, No se recomienda en menores de 6 años, ni durante la lactancia.', '10 mg', 30, 592.51, 686, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(11, 'Ibuprofeno', 'Ibuprofeno', 'tableta', 'Miligramo', 'Envase con 12 tabletas.', '1. Dolor de leve a moderado.', 'NINGUNA', '400 mg', 12, 250.52, 570, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(12, 'Clorodiazepóxido', 'Clorodiazepóxido, Clorhidrato de', 'solución inyectable', 'Ampolleta', 'Envase con una ampolleta.', 'Ansiedad.', 'Hipersensibilidad al fármaco, menores de 12 años, enfermedades psiquiátricas, enfermedad hepática o renal', '100 mg', 1, 14.08, 73, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(13, 'Brimonidina', 'Brimonidina, Tartrato de', 'solución oftálmica', 'Mililitro', 'Envase con gotero integral con 5 ml.', '1. Glaucoma.', 'Hipersensibilidad al fármaco, tratamiento con inhibidores de la monoaminooxidasa.', '2 mg/ml', 5, 638.45, 1128, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(14, 'Metamizol', 'Metamizol sódico', 'comprimido', 'Comprimido', 'Envase con 10 comprimidos.', '1. Fiebre', 'Hipersensibilidad al fármaco y a pirazolonas. Insuficiencia renal o hepática, discrasias sanguíneas, úlcera duodenal.', '500 mg', 10, 394.47, 472, '', '', '', 1);
INSERT INTO producto(idProducto, nombreProducto, nombreGenerico, formaFarmaceutica, unidadMedida, presentacion, principalIndicacion, contraindicaciones, concentracion, unidadesEnvase, precioCompra, precioVenta, foto, rutaFoto, codigoBarras, estatus) VALUES(15, 'Insulina detemir', 'Insulina Detemir (ADN recombinante)', 'solución inyectable', 'Pluma', 'Envase con 1 pluma prellenada con 3 ml (100 U/ml).', 'Diabetes mellitus.', 'Pacientes con hipoglucemia, antecedentes de hipersensibilidad a los componentes de la fórmula.', '100 U (14.20 mg / ml)', 1, 865.92, 1147, '', '', '', 1);

SELECT * FROM Producto;