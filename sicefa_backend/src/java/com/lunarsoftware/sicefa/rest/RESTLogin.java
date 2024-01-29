package com.lunarsoftware.sicefa.rest;

import com.google.gson.Gson;
import com.lunarsoftware.sicefa.core.ControllerLogin;
import com.lunarsoftware.sicefa.model.Empleado;
import jakarta.ws.rs.DefaultValue;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("login")
public class RESTLogin 
{
    @Path("login")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response login(
            @QueryParam("usuario") @DefaultValue("") String usuario,
            @QueryParam("password") @DefaultValue("") String password) 
    {
        String out = null;
        ControllerLogin cl = new ControllerLogin();
        Gson gson = new Gson();
        Empleado emp = null;
        try
        {
            emp = cl.login(usuario, password);
            if (emp != null)
                out = gson.toJson(emp);
            else
                out = "{\"error\":\"Datos de acceso incorrectos.\"}";
        }
        catch(Exception e)
        {
            e.printStackTrace();
            out = "{\"exception\":\"" + e.toString().replaceAll("\"","") + "\"}";
        }
        return Response.ok(out).build();
    }
}