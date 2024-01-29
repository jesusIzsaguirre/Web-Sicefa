package com.lunarsoftware.sicefa.rest;

import com.google.gson.Gson;
import com.lunarsoftware.sicefa.core.ControllerEmpleado;
import com.lunarsoftware.sicefa.model.Empleado;
import jakarta.ws.rs.DefaultValue;
import jakarta.ws.rs.FormParam;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

@Path("empleado")
public class RESTEmpleado {
@Path("save")
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public Response save(@FormParam("datosEmpleado") @DefaultValue("") String datosEmpleado) {
        ControllerEmpleado ce = new ControllerEmpleado();
        String out = null;
        Gson gson = new Gson();

        try {
            Empleado emp = gson.fromJson(datosEmpleado, Empleado.class);

            if (emp == null) {
                throw new IllegalArgumentException("Invalid data for Empleado");
            }

            if (emp.getIdEmpleado()< 1) {
                ce.insert(emp);
            } else {
                ce.update(emp);
            }

            out = "{\"result\":\"Datos de empleado guardados correctamente.\"}";
        } catch (Exception ex) {
            ex.printStackTrace();
            out = "{\"error\":\"" + ex.toString().replaceAll("\"", "") + "\"}";
        }

        return Response.ok(out).build();
    }

    @Path("getAll")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAll() {
        ControllerEmpleado ce = new ControllerEmpleado();
        String out = null;
        Gson gson = new Gson();

        try {
            List<Empleado> empleados = ce.getAll("");
            out = gson.toJson(empleados);
        } catch (Exception e) {
            e.printStackTrace();
            out = "{\"exception\":\"" + e.toString().replaceAll("\"", "") + "\"}";
        }

        return Response.ok(out).build();
    }
    
    @Path("delete")
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public Response delete(@FormParam("idEmpleado") @DefaultValue("0") int idEmpleado) {
        ControllerEmpleado ce = new ControllerEmpleado();
        String out = null;

        try {
            // Llamamos al método delete del controlador para eliminar/desactivar el cliente
            ce.delete(idEmpleado);

            out = "{\"result\":\"Empleado eliminado correctamente.\"}";
        } catch (Exception ex) {
            ex.printStackTrace();
            out = "{\"error\":\"" + ex.toString().replaceAll("\"", "") + "\"}";
        }

        return Response.ok(out).build();
    }
}
