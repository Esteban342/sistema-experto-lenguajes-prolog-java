% ==========================================================
% SISTEMA EXPERTO: ASESOR DE TECH STACK
% ==========================================================

:- encoding(utf8).

% ---------- 1. HECHOS (Lenguajes y atributos) ----------
lenguaje(python).
lenguaje(javascript).
lenguaje(java).
lenguaje(csharp).
lenguaje(kotlin).
lenguaje(swift).
lenguaje(php).
lenguaje(cpp).
lenguaje(go).
lenguaje(rust).

% Areas en las que se utiliza cada lenguaje
uso(python, backend).
uso(python, ciencia_datos).
uso(python, inteligencia_artificial).
uso(javascript, frontend).
uso(javascript, backend).
uso(javascript, desarrollo_movil).
uso(java, backend).
uso(java, desarrollo_movil).
uso(java, software_empresarial).
uso(java, sistemas_distribuidos).
uso(csharp, backend).
uso(csharp, videojuegos).
uso(csharp, software_empresarial).
uso(kotlin, desarrollo_movil).
uso(kotlin, backend).
uso(swift, desarrollo_movil).
uso(php, backend).
uso(php, frontend).
uso(cpp, videojuegos).
uso(cpp, sistemas_embebidos).
uso(go, backend).
uso(go, sistemas_distribuidos).
uso(rust, sistemas_embebidos).
uso(rust, sistemas_distribuidos).

% Plataformas habituales
plataforma(javascript, navegador).
plataforma(javascript, nube).
plataforma(javascript, escritorio).
plataforma(java, android).
plataforma(java, nube).
plataforma(java, escritorio).
plataforma(csharp, escritorio).
plataforma(csharp, nube).
plataforma(kotlin, android).
plataforma(swift, ios).
plataforma(php, nube).
plataforma(cpp, escritorio).
plataforma(cpp, dispositivos).
plataforma(go, nube).
plataforma(rust, nube).
plataforma(rust, dispositivos).
plataforma(python, nube).
plataforma(python, escritorio).

% Tipado
tipado(python, dinamico).
tipado(javascript, dinamico).
tipado(php, dinamico).
tipado(java, estatico).
tipado(csharp, estatico).
tipado(kotlin, estatico).
tipado(swift, estatico).
tipado(go, estatico).
tipado(rust, estatico).
tipado(cpp, estatico).

% Curva de aprendizaje aproximada para principiantes
curva_aprendizaje(python, facil).
curva_aprendizaje(php, facil).
curva_aprendizaje(kotlin, media).
curva_aprendizaje(swift, media).
curva_aprendizaje(javascript, media).
curva_aprendizaje(java, media).
curva_aprendizaje(csharp, media).
curva_aprendizaje(go, media).
curva_aprendizaje(cpp, dificil).
curva_aprendizaje(rust, dificil).

% Rendimiento relativo
rendimiento(cpp, alto).
rendimiento(rust, alto).
rendimiento(go, alto).
rendimiento(java, medio).
rendimiento(csharp, medio).
rendimiento(kotlin, medio).
rendimiento(swift, medio).
rendimiento(python, bajo).
rendimiento(javascript, bajo).
rendimiento(php, bajo).

% Demanda laboral aproximada
demanda(python, alta).
demanda(javascript, alta).
demanda(java, alta).
demanda(csharp, alta).
demanda(go, alta).
demanda(php, media).
demanda(kotlin, media).
demanda(swift, media).
demanda(cpp, media).
demanda(rust, media).

% Caracteristicas que el usuario puede priorizar
seguridad_memoria(python).
seguridad_memoria(javascript).
seguridad_memoria(java).
seguridad_memoria(csharp).
seguridad_memoria(kotlin).
seguridad_memoria(swift).
seguridad_memoria(php).
seguridad_memoria(go).
seguridad_memoria(rust).

ecosistema_amplio(python).
ecosistema_amplio(javascript).
ecosistema_amplio(java).
ecosistema_amplio(csharp).
ecosistema_amplio(cpp).
ecosistema_amplio(go).

% Entornos o sectores donde se usan con frecuencia
ideal_para(python, startups).
ideal_para(javascript, startups).
ideal_para(kotlin, startups).
ideal_para(java, corporativos_grandes).
ideal_para(csharp, corporativos_grandes).
ideal_para(php, agencias_web).
ideal_para(javascript, agencias_web).
ideal_para(python, investigacion).
ideal_para(go, sistemas_distribuidos).
ideal_para(java, sistemas_distribuidos).
ideal_para(rust, sistemas_distribuidos).
ideal_para(rust, sistemas_criticos).
ideal_para(cpp, sistemas_criticos).
ideal_para(cpp, motores_graficos).
ideal_para(csharp, motores_graficos).

% ---------- 2. RESPUESTAS Y CRITERIOS ----------
criterio_de(frontend, area(frontend)).
criterio_de(backend, area(backend)).
criterio_de(movil, area(desarrollo_movil)).
criterio_de(videojuegos, area(videojuegos)).
criterio_de(ciencia_datos, area(ciencia_datos)).
criterio_de(software_empresarial, area(software_empresarial)).
criterio_de(sistemas_embebidos, area(sistemas_embebidos)).
criterio_de(sistemas_distribuidos, area(sistemas_distribuidos)).

criterio_de(navegador, plataforma(navegador)).
criterio_de(android, plataforma(android)).
criterio_de(ios, plataforma(ios)).
criterio_de(escritorio, plataforma(escritorio)).
criterio_de(nube, plataforma(nube)).
criterio_de(dispositivos, plataforma(dispositivos)).

criterio_de(empleo, demanda(alta)).
criterio_de(rendimiento, rendimiento(alto)).
criterio_de(aprendizaje_facil, prioridad(facilidad)).
criterio_de(seguridad_memoria, seguridad_memoria).
criterio_de(versatilidad, ecosistema(amplio)).

criterio_de(facil, dificultad(facil)).
criterio_de(media, dificultad(media)).
criterio_de(dificil, dificultad(dificil)).

criterio_de(dinamico, tipado(dinamico)).
criterio_de(estatico, tipado(estatico)).

criterio_de(startup, entorno(startups)).
criterio_de(empresa_grande, entorno(corporativos_grandes)).
criterio_de(agencia_web, entorno(agencias_web)).
criterio_de(investigacion, entorno(investigacion)).
criterio_de(entorno_distribuido, entorno(sistemas_distribuidos)).
criterio_de(sistemas_criticos, entorno(sistemas_criticos)).
criterio_de(motores_graficos, entorno(motores_graficos)).

perfil(Respuestas, Perfil) :-
    findall(Criterio,
        (member(Respuesta, Respuestas), criterio_de(Respuesta, Criterio)),
        Criterios),
    sort(Criterios, Perfil).

% Pesos relativos: el area es el unico requisito obligatorio.
peso(area(_), 5).
peso(plataforma(_), 3).
peso(demanda(_), 3).
peso(rendimiento(_), 3).
peso(prioridad(_), 3).
peso(seguridad_memoria, 3).
peso(dificultad(_), 2).
peso(tipado(_), 2).
peso(entorno(_), 2).
peso(ecosistema(_), 2).

% ---------- 3. REGLAS DE INFERENCIA ----------
cumple(Lenguaje, area(Area)) :- uso(Lenguaje, Area).
cumple(Lenguaje, plataforma(Plataforma)) :- plataforma(Lenguaje, Plataforma).
cumple(Lenguaje, dificultad(Nivel)) :- curva_aprendizaje(Lenguaje, Nivel).
cumple(Lenguaje, entorno(Entorno)) :- ideal_para(Lenguaje, Entorno).
cumple(Lenguaje, rendimiento(Nivel)) :- rendimiento(Lenguaje, Nivel).
cumple(Lenguaje, demanda(Nivel)) :- demanda(Lenguaje, Nivel).
cumple(Lenguaje, tipado(Tipo)) :- tipado(Lenguaje, Tipo).
cumple(Lenguaje, prioridad(facilidad)) :-
    curva_aprendizaje(Lenguaje, facil).
cumple(Lenguaje, seguridad_memoria) :- seguridad_memoria(Lenguaje).
cumple(Lenguaje, ecosistema(amplio)) :- ecosistema_amplio(Lenguaje).

nombre_area(frontend, 'desarrollo web frontend').
nombre_area(backend, 'desarrollo backend').
nombre_area(desarrollo_movil, 'desarrollo de aplicaciones moviles').
nombre_area(videojuegos, 'desarrollo de videojuegos').
nombre_area(ciencia_datos, 'ciencia de datos').
nombre_area(software_empresarial, 'software empresarial').
nombre_area(sistemas_embebidos, 'sistemas embebidos').
nombre_area(sistemas_distribuidos, 'sistemas distribuidos').

nombre_plataforma(navegador, 'el navegador web').
nombre_plataforma(android, 'Android').
nombre_plataforma(ios, 'iOS').
nombre_plataforma(escritorio, 'la computadora de escritorio').
nombre_plataforma(nube, 'la nube').
nombre_plataforma(dispositivos, 'los dispositivos electronicos').

nombre_entorno(startups, startups).
nombre_entorno(corporativos_grandes, 'empresas grandes').
nombre_entorno(agencias_web, 'agencias de desarrollo web').
nombre_entorno(investigacion, investigacion).
nombre_entorno(sistemas_distribuidos, 'sistemas distribuidos').
nombre_entorno(sistemas_criticos, 'sistemas criticos').
nombre_entorno(motores_graficos, 'motores graficos').

texto_razon(_, area(Area), Texto) :-
    nombre_area(Area, Nombre),
    format(atom(Texto), 'se utiliza en ~w', [Nombre]).
texto_razon(_, plataforma(Plataforma), Texto) :-
    nombre_plataforma(Plataforma, Nombre),
    format(atom(Texto), 'es adecuado para ~w', [Nombre]).
texto_razon(_, dificultad(facil), 'coincide con el nivel facil que prefieres').
texto_razon(_, dificultad(media), 'coincide con el nivel moderado que prefieres').
texto_razon(_, dificultad(dificil), 'coincide con el nivel exigente que prefieres').
texto_razon(_, entorno(Entorno), Texto) :-
    nombre_entorno(Entorno, Nombre),
    format(atom(Texto), 'se utiliza en ~w', [Nombre]).
texto_razon(_, rendimiento(alto), 'coincide con el alto rendimiento que buscas').
texto_razon(_, rendimiento(medio), 'coincide con el rendimiento medio que buscas').
texto_razon(_, rendimiento(bajo), 'coincide con el rendimiento bajo que buscas').
texto_razon(_, prioridad(facilidad), 'es una opcion sencilla para comenzar').
texto_razon(_, demanda(alta), 'tiene alta demanda laboral').
texto_razon(_, demanda(media), 'tiene demanda laboral media').
texto_razon(_, tipado(dinamico), 'utiliza tipado dinamico, como prefieres').
texto_razon(_, tipado(estatico), 'utiliza tipado estatico, como prefieres').
texto_razon(_, seguridad_memoria, 'ofrece seguridad de memoria por defecto').
texto_razon(_, ecosistema(amplio), 'cuenta con un ecosistema amplio').

% ---------- 4. MOTOR DE EVALUACION ----------
evaluar(Perfil, Lenguaje, Porcentaje, Razones) :-
    lenguaje(Lenguaje),
    member(area(Area), Perfil),
    uso(Lenguaje, Area),
    findall(Peso-Criterio,
        (member(Criterio, Perfil),
         cumple(Lenguaje, Criterio),
         peso(Criterio, Peso)),
        Cumplidos),
    findall(Peso, member(Peso-_, Cumplidos), Pesos),
    sum_list(Pesos, Puntos),
    findall(Peso,
        (member(Criterio, Perfil), peso(Criterio, Peso)),
        PesosPosibles),
    sum_list(PesosPosibles, Maximo),
    Maximo > 0,
    Porcentaje is round(Puntos * 100 / Maximo),
    findall(Texto,
        (member(_-Criterio, Cumplidos), texto_razon(Lenguaje, Criterio, Texto)),
        Razones).

recomendar(Perfil, Lenguaje, Porcentaje, Razones) :-
    findall(resultado(P, L, R), evaluar(Perfil, L, P, R), Candidatos),
    Candidatos \= [],
    sort(0, @>=, Candidatos, [resultado(Porcentaje, Lenguaje, Razones) | _]).

% Esta es la regla que Java llama.
recomendar_desde(Respuestas, Porcentaje, Lenguaje, Razones) :-
    perfil(Respuestas, Perfil),
    recomendar(Perfil, Lenguaje, Porcentaje, Razones).

% ---------- 5. CUESTIONARIO ----------
pregunta(p_area, '¿Qué tipo de proyecto te interesa desarrollar?').
pregunta(p_plataforma, '¿En qué plataforma te gustaría trabajar?').
pregunta(p_prioridad, '¿Qué es lo más importante para ti?').
pregunta(p_dificultad, '¿Qué nivel de dificultad estás dispuesto a aprender?').
pregunta(p_tipado, '¿Qué estilo de tipado prefieres?').
pregunta(p_entorno, '¿En qué entorno o sector te gustaría trabajar?').

opcion(p_area, frontend, 'Sitios web (frontend)', p_plataforma).
opcion(p_area, backend, 'Servicios web (backend)', p_plataforma).
opcion(p_area, movil, 'Aplicaciones móviles', p_plataforma).
opcion(p_area, videojuegos, 'Videojuegos', p_plataforma).
opcion(p_area, ciencia_datos, 'Ciencia de datos e inteligencia artificial', p_plataforma).
opcion(p_area, software_empresarial, 'Software empresarial', p_plataforma).
opcion(p_area, sistemas_embebidos, 'Sistemas embebidos y dispositivos', p_plataforma).
opcion(p_area, sistemas_distribuidos, 'Sistemas distribuidos', p_plataforma).

opcion(p_plataforma, navegador, 'Navegador web', p_prioridad).
opcion(p_plataforma, android, 'Android', p_prioridad).
opcion(p_plataforma, ios, 'iOS', p_prioridad).
opcion(p_plataforma, escritorio, 'Computadora de escritorio', p_prioridad).
opcion(p_plataforma, nube, 'Nube', p_prioridad).
opcion(p_plataforma, dispositivos, 'Dispositivos electrónicos', p_prioridad).
opcion(p_plataforma, sin_preferencia_plataforma, 'No tengo preferencia', p_prioridad).

opcion(p_prioridad, empleo, 'Oportunidades de empleo', p_dificultad).
opcion(p_prioridad, rendimiento, 'Alto rendimiento', p_dificultad).
opcion(p_prioridad, aprendizaje_facil, 'Facilidad para comenzar', p_dificultad).
opcion(p_prioridad, seguridad_memoria, 'Seguridad de memoria', p_dificultad).
opcion(p_prioridad, versatilidad, 'Versatilidad y variedad de usos', p_dificultad).

opcion(p_dificultad, facil, 'Fácil', p_tipado).
opcion(p_dificultad, media, 'Moderada', p_tipado).
opcion(p_dificultad, dificil, 'Exigente', p_tipado).

opcion(p_tipado, dinamico, 'Dinámico', p_entorno).
opcion(p_tipado, estatico, 'Estático', p_entorno).
opcion(p_tipado, sin_preferencia_tipado, 'No tengo preferencia', p_entorno).

opcion(p_entorno, startup, 'Startup', fin).
opcion(p_entorno, empresa_grande, 'Empresa grande', fin).
opcion(p_entorno, agencia_web, 'Agencia de desarrollo web', fin).
opcion(p_entorno, investigacion, 'Investigación y datos', fin).
opcion(p_entorno, entorno_distribuido, 'Sistemas distribuidos', fin).
opcion(p_entorno, sistemas_criticos, 'Sistemas críticos', fin).
opcion(p_entorno, motores_graficos, 'Motores gráficos', fin).
opcion(p_entorno, sin_preferencia_entorno, 'No tengo preferencia', fin).
