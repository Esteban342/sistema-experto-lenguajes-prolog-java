% ==========================================================
% SISTEMA EXPERTO: ASESOR DE TECH STACK (v2)
% ==========================================================


:- encoding(utf8).
% ---------- 1. HECHOS (Lenguajes y sus atributos) ----------
lenguaje(python). lenguaje(javascript). lenguaje(java).
lenguaje(csharp). lenguaje(kotlin). lenguaje(swift).
lenguaje(php). lenguaje(cpp). lenguaje(go). lenguaje(rust).

% Usos
uso(python, backend). uso(python, ciencia_datos). uso(python, inteligencia_artificial).
uso(javascript, frontend). uso(javascript, backend).
uso(java, backend). uso(java, desarrollo_android).
uso(csharp, desarrollo_unity).
uso(kotlin, desarrollo_android).
uso(swift, desarrollo_ios).
uso(php, backend).
uso(cpp, videojuegos). uso(cpp, sistemas_embebidos).
uso(go, backend). uso(go, sistemas_distribuidos).
uso(rust, sistemas_seguros).

% Tipado (Dinámico/Estático)
tipado(python, dinamico). tipado(javascript, dinamico). tipado(php, dinamico).
tipado(java, estatico). tipado(csharp, estatico). tipado(kotlin, estatico).
tipado(swift, estatico). tipado(go, estatico). tipado(rust, estatico). tipado(cpp, estatico).

% Curva de aprendizaje
curva_aprendizaje(python, facil). curva_aprendizaje(php, facil).
curva_aprendizaje(kotlin, media). curva_aprendizaje(swift, media).
curva_aprendizaje(javascript, media). curva_aprendizaje(java, media).
curva_aprendizaje(csharp, media). curva_aprendizaje(go, media).
curva_aprendizaje(cpp, dificil). curva_aprendizaje(rust, dificil).

% Rendimiento
rendimiento(cpp, alto). rendimiento(rust, alto). rendimiento(go, alto).
rendimiento(java, medio). rendimiento(csharp, medio). rendimiento(kotlin, medio).
rendimiento(swift, medio). rendimiento(python, bajo). rendimiento(javascript, bajo).

% Demanda y Entorno
demanda(python, alta). demanda(javascript, alta). demanda(java, alta).
demanda(csharp, alta). demanda(go, alta).
demanda(php, media). demanda(kotlin, media). demanda(swift, media).
demanda(cpp, media). demanda(rust, media).

ideal_para(python, startups). ideal_para(javascript, startups). ideal_para(kotlin, startups).
ideal_para(java, corporativos_grandes). ideal_para(csharp, corporativos_grandes).
ideal_para(php, agencias_web). ideal_para(go, sistemas_distribuidos).
ideal_para(rust, sistemas_criticos). ideal_para(cpp, motores_graficos).

% ---------- 2. CRITERIOS (Traducir respuestas a lógica) ----------
criterio_de(frontend, area(frontend)).
criterio_de(backend, area(backend)).
criterio_de(ciencia_datos, area(ciencia_datos)).
criterio_de(videojuegos, area(videojuegos)).
criterio_de(diseno_visual, entorno(agencias_web)).
criterio_de(logica_interaccion, rendimiento(alto)).
criterio_de(bases_datos, rendimiento(alto)).
criterio_de(seguridad, tipado(estatico)).
criterio_de(seguridad, sin_memoria_manual).
criterio_de(alto, rendimiento(alto)).
criterio_de(medio, rendimiento(medio)).
criterio_de(facil, dificultad(facil)).
criterio_de(media, dificultad(media)).
criterio_de(dificil, dificultad(dificil)).
criterio_de(startups, entorno(startups)).
criterio_de(corporativo, entorno(corporativos_grandes)).

perfil(Respuestas, Perfil) :-
    findall(C, (member(R, Respuestas), criterio_de(R, C)), Perfil).

% Peso de cada criterio para el puntaje final
peso(area(_), 5).
peso(rendimiento(_), 3).
peso(dificultad(_), 2).
peso(entorno(_), 2).
peso(demanda(_), 2).

% ---------- 3. REGLAS DE INFERENCIA ----------
cumple(L, area(A)) :- uso(L, A).
cumple(L, dificultad(D)) :- curva_aprendizaje(L, D).
cumple(L, entorno(E)) :- ideal_para(L, E).
cumple(L, rendimiento(R)) :- rendimiento(L, R).
cumple(L, demanda(D)) :- demanda(L, D).
cumple(L, sin_memoria_manual) :- \+ (L == cpp ; L == rust). % Negación lógica

% Descartes (Si el usuario pide "fácil", descartamos los "dificiles")
descartado(L, Perfil) :-
    member(dificultad(facil), Perfil),
    curva_aprendizaje(L, dificil).

% Explicaciones en texto
texto_razon(_, area(A), T) :- format(atom(T), 'se utiliza en ~w', [A]).
texto_razon(_, dificultad(D), T) :- format(atom(T), 'curva de aprendizaje ~w', [D]).
texto_razon(_, entorno(E), T) :- format(atom(T), 'es muy adoptado en ~w', [E]).
texto_razon(_, rendimiento(R), T) :- format(atom(T), 'rendimiento ~w', [R]).
texto_razon(_, sin_memoria_manual, 'no requiere gestión manual de memoria').

% ---------- 4. EL MOTOR DE EVALUACIÓN ----------
evaluar(Perfil, L, Puntaje, Razones) :-
    lenguaje(L),
    member(area(A), Perfil), uso(L, A),      % Requisito mínimo
    \+ descartado(L, Perfil),                % Que no esté descartado
    findall(Peso-C, (member(C, Perfil), cumple(L, C), peso(C, Peso)), Cumplidos),
    findall(P, member(P-_, Cumplidos), Pesos),
    sum_list(Pesos, Puntaje),
    findall(T, (member(_-C, Cumplidos), texto_razon(L, C, T)), Razones).

recomendar(Perfil, Lenguaje, Puntaje, Razones) :-
    findall(resultado(P, L, R), evaluar(Perfil, L, P, R), Candidatos),
    Candidatos \= [],
    sort(0, @>=, Candidatos, [resultado(Puntaje, Lenguaje, Razones) | _]).

% Esta es la regla que Java va a llamar
recomendar_desde(Respuestas, Puntaje, Lenguaje, Razones) :-
    perfil(Respuestas, Perfil),
    recomendar(Perfil, Lenguaje, Puntaje, Razones).

% ---------- 5. ÁRBOL DE PREGUNTAS (Lógica dinámica) ----------
pregunta(p_area, '¿Qué tipo de proyecto vas a desarrollar?').
pregunta(p_frontend, '¿Te interesa más el diseño visual o la lógica de interacción?').
pregunta(p_backend, '¿Qué aspecto priorizas en el backend?').
pregunta(p_rendimiento, '¿Qué tan crítico es el rendimiento?').
pregunta(p_dificultad, '¿Qué curva de aprendizaje aceptas?').
pregunta(p_entorno, '¿En qué tipo de empresa trabajarás?').

% Transiciones (Árbol)
opcion(p_area, frontend, p_frontend).
opcion(p_area, backend, p_backend).
opcion(p_area, ciencia_datos, p_dificultad).
opcion(p_area, videojuegos, p_rendimiento).

opcion(p_frontend, diseno_visual, p_dificultad).
opcion(p_frontend, logica_interaccion, p_dificultad).

opcion(p_backend, bases_datos, p_dificultad).
opcion(p_backend, seguridad, p_dificultad).

opcion(p_rendimiento, alto, p_dificultad).
opcion(p_rendimiento, medio, p_dificultad).

opcion(p_dificultad, facil, p_entorno).
opcion(p_dificultad, media, p_entorno).
opcion(p_dificultad, dificil, p_entorno).

opcion(p_entorno, startups, fin).
opcion(p_entorno, corporativo, fin).