import org.jpl7.Query;
import org.jpl7.Term;
import org.jpl7.Variable;
import org.jpl7.JPL;
import com.formdev.flatlaf.FlatDarkLaf; // <-- NUEVA LIBRERÍA DE DISEÑO

import javax.swing.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class TechAdvisor {

    public static void main(String[] args) {
        // Inicializar el diseño moderno FlatLaf
        try {
            FlatDarkLaf.setup();
        } catch (Exception ex) {
            System.err.println("Falló la inicialización de FlatLaf");
        }

        JPL.init();
        
        // 1. Cargar la base de conocimiento
        Query consulta = new Query("consult", new Term[]{ new org.jpl7.Atom("../prolog/base_conocimiento.pl") });
        if (!consulta.hasSolution()) {
            JOptionPane.showMessageDialog(null, "Error: No se encontró base_conocimiento.pl", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }

        JOptionPane.showMessageDialog(null, "Bienvenido al Asesor de Tech Stack.\nResponderemos unas preguntas para darte la mejor recomendación.", "Sistema Experto", JOptionPane.INFORMATION_MESSAGE);

        List<String> respuestasUsuario = new ArrayList<>();
        String nodoActual = "p_area";

        // 2. Navegar por el árbol de preguntas
        while (!nodoActual.equals("fin")) {
            Query qPregunta = new Query("pregunta", new Term[]{ new org.jpl7.Atom(nodoActual), new Variable("Texto") });
            Map<String, Term> resPregunta = qPregunta.oneSolution();
            String textoPregunta = resPregunta.get("Texto").name();

            Query qOpciones = new Query("opcion", new Term[]{ new org.jpl7.Atom(nodoActual), new Variable("Opcion"), new Variable("Siguiente") });
            Map<String, Term>[] soluciones = qOpciones.allSolutions();
            
            String[] opcionesTexto = new String[soluciones.length];
            String[] siguientesNodos = new String[soluciones.length];

            for (int i = 0; i < soluciones.length; i++) {
                opcionesTexto[i] = soluciones[i].get("Opcion").name();
                siguientesNodos[i] = soluciones[i].get("Siguiente").name();
            }

            String seleccion = (String) JOptionPane.showInputDialog(
                    null,
                    textoPregunta,
                    "Pregunta",
                    JOptionPane.QUESTION_MESSAGE,
                    null,
                    opcionesTexto,
                    opcionesTexto[0]
            );

            if (seleccion == null) System.exit(0);

            respuestasUsuario.add(seleccion);
            for (int i = 0; i < opcionesTexto.length; i++) {
                if (opcionesTexto[i].equals(seleccion)) {
                    nodoActual = siguientesNodos[i];
                    break;
                }
            }
        }

        // 3. Hacer la recomendación final
        String respuestasFormateadas = String.join(",", respuestasUsuario);
        String queryString = String.format("recomendar_desde([%s], P, L, R)", respuestasFormateadas);
        
        Query qRecomendar = new Query(queryString);
        Map<String, Term>[] recomendaciones = qRecomendar.allSolutions();

        if (recomendaciones != null && recomendaciones.length > 0) {
            Map<String, Term> mejorOpcion = recomendaciones[0];
            
            String lenguaje = mejorOpcion.get("L").name().toUpperCase();
            String puntaje = mejorOpcion.get("P").toString();
            
            // Volvemos a usar toTermArray(). Ignora la advertencia amarilla, es la forma correcta.
            Term[] razonesTerm = mejorOpcion.get("R").toTermArray();
            
            StringBuilder mensajeFinal = new StringBuilder();
            mensajeFinal.append("¡Recomendación Exitosa!\n\n");
            mensajeFinal.append("El lenguaje ideal para ti es: ").append(lenguaje).append("\n");
            mensajeFinal.append("Nivel de compatibilidad: ").append(puntaje).append(" puntos\n\n");
            mensajeFinal.append("¿Por qué te lo recomendamos?\n");
            
            for (Term razon : razonesTerm) {
                mensajeFinal.append(" • ").append(razon.name()).append("\n");
            }

            JOptionPane.showMessageDialog(null, mensajeFinal.toString(), "Resultado del Sistema Experto", JOptionPane.INFORMATION_MESSAGE);
            
        } else {
            JOptionPane.showMessageDialog(null, "No se encontró un lenguaje que cumpla con todos tus requisitos.", "Sin resultados", JOptionPane.WARNING_MESSAGE);
        }
    }
}