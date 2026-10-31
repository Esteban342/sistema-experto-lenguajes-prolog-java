import com.formdev.flatlaf.FlatDarkLaf;
import org.jpl7.Atom;
import org.jpl7.JPL;
import org.jpl7.Query;
import org.jpl7.Term;
import org.jpl7.Variable;

import javax.swing.JOptionPane;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class TechAdvisor {

    public static void main(String[] args) {
        try {
            FlatDarkLaf.setup();
        } catch (Exception ex) {
            System.err.println("No se pudo inicializar FlatLaf: " + ex.getMessage());
        }

        try {
            JPL.init();
            consultKnowledgeBase();
            runQuestionnaire();
        } catch (Exception ex) {
            ex.printStackTrace();
            JOptionPane.showMessageDialog(
                    null,
                    "No se pudo continuar con el sistema:\n" + ex.getMessage(),
                    "Error",
                    JOptionPane.ERROR_MESSAGE
            );
        }
    }

    private static void consultKnowledgeBase() {
        Path knowledgeBase = Paths.get("../prolog/base_conocimiento.pl").toAbsolutePath().normalize();
        if (!Files.exists(knowledgeBase)) {
            knowledgeBase = Paths.get("prolog/base_conocimiento.pl").toAbsolutePath().normalize();
        }
        if (!Files.exists(knowledgeBase)) {
            throw new IllegalStateException("No se encontró prolog/base_conocimiento.pl.");
        }

        Query query = new Query("consult", new Term[]{new Atom(knowledgeBase.toString())});
        if (!query.hasSolution()) {
            throw new IllegalStateException("No se pudo cargar la base de conocimiento.");
        }
    }

    private static void runQuestionnaire() {
        JOptionPane.showMessageDialog(
                null,
                "Bienvenido al Asesor de Tech Stack.\n"
                        + "Responderemos unas preguntas para darte la mejor recomendación.",
                "Sistema Experto",
                JOptionPane.INFORMATION_MESSAGE
        );

        List<String> answers = new ArrayList<>();
        String currentNode = "p_area";

        while (!"fin".equals(currentNode)) {
            Map<String, Term> question = findQuestion(currentNode);
            if (question == null) {
                throw new IllegalStateException("No se encontró la pregunta " + currentNode + ".");
            }

            List<Option> options = findOptions(currentNode);
            if (options.isEmpty()) {
                throw new IllegalStateException("La pregunta " + currentNode + " no tiene opciones.");
            }

            String[] labels = new String[options.size()];
            for (int i = 0; i < options.size(); i++) {
                labels[i] = options.get(i).label;
            }

            String selection = (String) JOptionPane.showInputDialog(
                    null,
                    question.get("Text").name(),
                    "Pregunta",
                    JOptionPane.QUESTION_MESSAGE,
                    null,
                    labels,
                    labels[0]
            );
            if (selection == null) {
                return;
            }

            Option selectedOption = findSelectedOption(options, selection);
            answers.add(selectedOption.value);
            currentNode = selectedOption.nextNode;
        }

        showRecommendation(answers);
    }

    private static Map<String, Term> findQuestion(String node) {
        Query query = new Query(
                "pregunta",
                new Term[]{new Atom(node), new Variable("Text")}
        );
        return query.oneSolution();
    }

    private static List<Option> findOptions(String node) {
        List<Option> options = new ArrayList<>();
        Query query = new Query(
                "opcion",
                new Term[]{
                        new Atom(node),
                        new Variable("Value"),
                        new Variable("Label"),
                        new Variable("Next")
                }
        );
        Map<String, Term>[] solutions = query.allSolutions();
        for (Map<String, Term> solution : solutions) {
            options.add(new Option(
                    solution.get("Value").name(),
                    solution.get("Label").name(),
                    solution.get("Next").name()
            ));
        }
        return options;
    }

    private static Option findSelectedOption(List<Option> options, String selectedLabel) {
        for (Option option : options) {
            if (option.label.equals(selectedLabel)) {
                return option;
            }
        }
        throw new IllegalStateException("La opción seleccionada no está disponible.");
    }

    private static void showRecommendation(List<String> answers) {
        String queryText = "recomendar_desde([" + String.join(",", answers) + "], P, L, R)";
        Query query = new Query(queryText);
        Map<String, Term>[] recommendations = query.allSolutions();

        if (recommendations.length == 0) {
            JOptionPane.showMessageDialog(
                    null,
                    "No se encontraron lenguajes asociados con el área que elegiste.",
                    "Sin resultados",
                    JOptionPane.WARNING_MESSAGE
            );
            return;
        }

        Map<String, Term> recommendation = recommendations[0];
        StringBuilder message = new StringBuilder();
        message.append("¡Recomendación exitosa!\n\n")
                .append("El lenguaje recomendado para ti es: ")
                .append(recommendation.get("L").name().toUpperCase())
                .append("\nCompatibilidad con tus respuestas: ")
                .append(recommendation.get("P"))
                .append("%\n\n")
                .append("¿Por qué te lo recomendamos?\n");

        for (Term reason : recommendation.get("R").toTermArray()) {
            message.append(" • ").append(reason.name()).append('\n');
        }

        JOptionPane.showMessageDialog(
                null,
                message.toString(),
                "Resultado del Sistema Experto",
                JOptionPane.INFORMATION_MESSAGE
        );
    }

    private static final class Option {
        private final String value;
        private final String label;
        private final String nextNode;

        private Option(String value, String label, String nextNode) {
            this.value = value;
            this.label = label;
            this.nextNode = nextNode;
        }
    }
}
