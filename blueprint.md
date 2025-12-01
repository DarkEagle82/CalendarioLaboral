# Blueprint: Calendario Laboral App

## Visión General

Esta aplicación es un "Calendario Laboral" dinámico y reutilizable, diseñado para que los empleados puedan registrar y hacer un seguimiento de sus jornadas laborales a lo largo de **múltiples años**. Permite a los usuarios marcar días específicos como festivos o vacaciones, y gestiona de forma inteligente la jornada intensiva a través de un **sistema de reglas personalizables**. Proporciona un resumen automático de las horas trabajadas, las horas restantes según un objetivo anual y el total de días laborables para el año seleccionado.

La aplicación es altamente configurable, permitiendo a los usuarios ajustar las horas de cada tipo de jornada, el objetivo de horas anuales, y los colores del tema para una experiencia personalizada.

## Características Implementadas

- **Icono de Aplicación Personalizado:**
    - Se ha añadido un icono de aplicación único y profesional, reemplazando el icono por defecto de Flutter. El icono se genera automáticamente para las densidades de pantalla de Android.

- **Soporte Multi-Anual Dinámico:**
    - **Selector de Año:** La pantalla del calendario incluye un menú desplegable que permite al usuario cambiar fácilmente el año que desea visualizar y gestionar.
    - **Datos Independientes por Año:** Las marcas en el calendario (festivos, vacaciones) se guardan de forma separada para cada año.
    - **Cálculos y Vistas Adaptativos:** Toda la aplicación reacciona al año seleccionado, mostrando siempre la información pertinente.

- **Navegación por Pestañas:** Una barra de navegación inferior permite cambiar entre las tres secciones principales: Calendario, Resumen y Ajustes.

- **Calendario Interactivo:**
    - Visualización del calendario completo del **año seleccionado**.
    - Los usuarios pueden seleccionar un día o un rango de días.
    - Menú contextual para marcar los días seleccionados como **Festivo (`Holiday`)** o **Vacaciones (`Vacation`)**.
    - Opción para limpiar la marca de un día.

- **Resumen de Horas (por Año):**
    - **Total de Horas Trabajadas:** Cálculo dinámico de todas las horas trabajadas en el año seleccionado.
    - **Horas Anuales de Convenio:** Objetivo total de horas a trabajar, configurable por el usuario.
    - **Horas Restantes:** Diferencia entre el objetivo anual y las horas ya trabajadas.
    - **Total de Días Trabajados:** Conteo de los días laborables del año seleccionado, excluyendo fines de semana, festivos y vacaciones.
    - **Conversión a Días:** Cuando las horas restantes son negativas (hay horas extra), la aplicación las convierte a **días de trabajo equivalentes**.

- **Cálculo de Horas Inteligente y Flexible:**
    - Los días marcados como **Vacaciones** o **Festivo** se excluyen del cómputo de horas trabajadas.
    - **Los días se consideran de jornada intensiva si cumplen CUALQUIERA de las reglas definidas por el usuario**, lo que permite una flexibilidad total.

- **Pantalla de Ajustes Avanzada:**
    - **Tema:**
        - Selector de color para personalizar los marcadores de **Festivo**, **Vacaciones** y **Jornada Intensiva**.
    - **Configuración de Jornada:**
        - Campos de texto para definir las horas de la **jornada normal** e **intensiva**.
        - Campo de texto para establecer el **objetivo de horas anuales**.
    - **Sistema de Reglas de Jornada Intensiva:**
        - **Lista de Reglas:** La pantalla muestra una lista clara de todas las reglas de jornada intensiva activas.
        - **Añadir Reglas:** Un botón flotante permite añadir nuevos tipos de reglas:
            - **Rango de Fechas:** Jornada intensiva durante un período continuo (ej: del 1 al 15 de agosto).
            - **Día Semanal en un Rango:** Jornada intensiva para días específicos de la semana dentro de un rango (ej: todos los viernes de junio a septiembre).
            - **Víspera de Festivo:** Marca automáticamente como intensiva la víspera de cualquier festivo (si es un día laborable).
        - **Eliminar Reglas:** Cada regla en la lista se puede eliminar de forma individual.

- **Persistencia de Datos:**
    - Todas las configuraciones y las marcas del calendario para cada año se guardan localmente en el dispositivo usando `shared_preferences`.

- **Localización (i18n):**
    - La interfaz está disponible en **Inglés** y **Español**.

## Arquitectura

- **Gestión de Estado:** La aplicación utiliza el paquete `provider` para una gestión de estado reactiva y desacoplada.
    - `SettingsProvider`: Gestiona todas las configuraciones del usuario, incluyendo el **año seleccionado** y la **lista de reglas de jornada intensiva**.
    - `CalendarProvider`: Gestiona el estado del calendario y realiza todos los cálculos para la pantalla de resumen, reaccionando a los cambios en el `SettingsProvider`.
    - `ColorProvider`: Gestiona los colores de los eventos del calendario.
- **Modelo de Datos:**
    - Se ha implementado un sistema polimórfico con una clase base `IntensiveRule` y varias subclases (`DateRangeRule`, `WeeklyOnRangeRule`, `HolidayEveRule`) para manejar la lógica de la jornada intensiva.
- **Persistencia:** `shared_preferences` para el almacenamiento de datos del usuario. Las reglas de jornada intensiva se serializan y deserializan desde y hacia JSON para su almacenamiento.

## Plan Actual

El último cambio ha sido la **implementación de un icono de aplicación personalizado**. Esto mejora la identidad visual de la aplicación y la hace fácilmente reconocible en el dispositivo del usuario.
