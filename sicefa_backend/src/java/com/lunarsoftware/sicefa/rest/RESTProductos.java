
package com.lunarsoftware.sicefa.rest;

import com.google.gson.Gson;
import com.lunarsoftware.sicefa.core.ControllerProductos;
import com.lunarsoftware.sicefa.model.Productos_Sicefa_Central;
import jakarta.ws.rs.DefaultValue;
import jakarta.ws.rs.FormParam;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Path("productos")
public class RESTProductos {
    @Path("getAll")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAll(String filtro) {
        ControllerProductos cs = new ControllerProductos();
        List<Productos_Sicefa_Central> productos = null;
        String out = null;
        Gson gson = new Gson();

        try {
            productos = cs.getAll(filtro);
            out = gson.toJson(productos);
            return Response.ok(out).build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                           .entity("{\"error\":\"" + e.getMessage().replaceAll("\"", "") + "\"}")
                           .build();
        }
    }
    
    @Path("insertEjemplo")
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public Response insertEjemplo(@FormParam("datosEjemplo") @DefaultValue("") String datos){
        String out = "";
        Gson gson = null;
        ControllerProductos cp = new ControllerProductos();
        Productos_Sicefa_Central e = null;
        
        try {
            gson = new Gson();
            e = gson.fromJson(datos, Productos_Sicefa_Central.class);
            cp.insertProductos(e);
            out = """
                  {"response" : "Registro insertado"}
                  """;
        } catch (Exception ex) {
            out = """
                  {"response" : "Error al insertar"}
                  """;
            ex.getStackTrace();
            ex.printStackTrace();
        }
        
        return Response.ok(out).build();
    }
    
    
    //Api de awos
    @Path("save")
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public Response save(@FormParam("datosProductos") @DefaultValue("") String datosProductos) {
        ControllerProductos cp = new ControllerProductos();
        String out = null;
        Gson gson = new Gson();

        try {
            Productos_Sicefa_Central pro = gson.fromJson(datosProductos, Productos_Sicefa_Central.class);

            if (pro == null) {
                throw new IllegalArgumentException("Invalid data for productos");
            }

            if (pro.getIdProducto()< 1) {
                cp.insertar(pro);
            } else {
                cp.update(pro);
            }

            out = "{\"result\":\"Datos de Productos guardados correctamente.\"}";
        } catch (Exception ex) {
            ex.printStackTrace();
            out = "{\"error\":\"" + ex.toString().replaceAll("\"", "") + "\"}";
        }

        return Response.ok(out).build();
    }
    
    @Path("delete")
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public Response delete(@FormParam("idProducto") @DefaultValue("0") int idProducto) {
        ControllerProductos cp = new ControllerProductos();
        String out = null;

        try {
            // Llamamos al método delete del controlador para eliminar/desactivar la sucursal
            cp.delete(idProducto);

            out = "{\"result\":\"Producto eliminada correctamente.\"}";
        } catch (Exception ex) {
            ex.printStackTrace();
            out = "{\"error\":\"" + ex.toString().replaceAll("\"", "") + "\"}";
        }

        return Response.ok(out).build();
    }
    
}
