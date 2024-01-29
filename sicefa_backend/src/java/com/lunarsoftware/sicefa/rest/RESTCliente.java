package com.lunarsoftware.sicefa.rest;

import com.google.gson.Gson;
import com.lunarsoftware.sicefa.core.ControllerCliente;
import com.lunarsoftware.sicefa.model.Cliente;
import jakarta.ws.rs.DefaultValue;
import jakarta.ws.rs.FormParam;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Path("cliente")
public class RESTCliente {
    
    @Path("save")
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public Response save(@FormParam("datosCliente") @DefaultValue("") String datosCliente) {
        ControllerCliente cc = new ControllerCliente();
        String out = null;
        Gson gson = new Gson();

        try {
            Cliente cli = gson.fromJson(datosCliente, Cliente.class);

            if (cli == null) {
                throw new IllegalArgumentException("Invalid data for Cliente");
            }

            if (cli.getId()< 1) {
                cc.insert(cli);
            } else {
                cc.update(cli);
            }

            out = "{\"result\":\"Datos de Cliente guardados correctamente.\"}";
        } catch (Exception ex) {
            ex.printStackTrace();
            out = "{\"error\":\"" + ex.toString().replaceAll("\"", "") + "\"}";
        }

        return Response.ok(out).build();
    }
    
    @Path("getAll")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAll(){
        ControllerCliente ca = new ControllerCliente();
        List<Cliente> clientes = null;
        String out = null;
        Gson gson = new Gson();
        try{
            clientes = ca.getAll("");
            out = gson.toJson(clientes);
        }catch(Exception e){
            e.printStackTrace();
            out = "{\"exception\":" + e.toString().replaceAll("\"", "") + "\"}";
        }
        
        
        return Response.ok(out).build();
    }
    
    @Path("delete")
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public Response delete(@FormParam("idCliente") @DefaultValue("0") int idCliente) {
        ControllerCliente cc = new ControllerCliente();
        String out = null;

        try {
            // Llamamos al método delete del controlador para eliminar/desactivar el cliente
            cc.delete(idCliente);

            out = "{\"result\":\"Cliente eliminado correctamente.\"}";
        } catch (Exception ex) {
            ex.printStackTrace();
            out = "{\"error\":\"" + ex.toString().replaceAll("\"", "") + "\"}";
        }

        return Response.ok(out).build();
    }
    
}
