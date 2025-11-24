# Blueprint: Calendario Laboral App

## Visión General

Esta aplicación es un "Calendario Laboral" dinámico y reutilizable, diseñado para que los empleados puedan registrar y hacer un seguimiento de sus jornadas laborales a lo largo de **múltiples años**. Permite a los usuarios marcar días específicos como festivos, vacaciones o de jornada intensiva, y proporciona un resumen automático de las horas trabajadas, las horas restantes según un objetivo anual y el total de días laborables para el año seleccionado.

La aplicación es altamente configurable, permitiendo a los usuarios ajustar las horas de cada tipo de jornada, el objetivo de horas anuales, los colores del tema y el período exacto de la jornada intensiva para una experiencia personalizada.

## Características Implementadas

- **Soporte Multi-Anual Dinámico:**
    - **Selector de Año:** La pantalla del calendario incluye un menú desplegable que permite al usuario cambiar fácilmente el año que desea visualizar y gestionar (e.g., 2024, 2025, 2026...).
    - **Datos Independientes por Año:** Las marcas en el calendario (festivos, vacaciones, etc.) se guardan de forma separada para cada año. Los datos de 2025 no interfieren con los de 2026.
    - **Cálculos y Vistas Adaptativos:** Toda la aplicación, incluyendo el calendario, la pantalla de resumen y los selectores de fecha en los ajustes, reacciona al año seleccionado, mostrando siempre la información pertinente.

- **Navegación por Pestañas:** Una barra de navegación inferior (`BottomNavigationBar`) permite cambiar fácilmente entre las tres secciones principales: Calendario, Resumen y Ajustes.

- **Calendario Interactivo:**
    - Visualización del calendario completo del **año seleccionado**.
    - Los usuarios pueden seleccionar un día o un rango de días.
    - Menú contextual para marcar los días seleccionados como:
        - **Festivo (`Holiday`):** No se trabaja.
        - **Vacaciones (`Vacation`):** No se trabaja.
        - **Jornada Intensiva (`Intensive Workday`):** Día con horario reducido.
    - Opción para limpiar la marca de un día.

- **Resumen de Horas (por Año):**
    - **Total de Horas Trabajadas:** Cálculo dinámico de todas las horas trabajadas en el año seleccionado.
    - **Horas Anuales de Convenio:** Objetivo total de horas a trabajar, configurable por el usuario.
    - **Horas Restantes:** Diferencia entre el objetivo anual y las horas ya trabajadas.
    - **Total de Días Trabajados:** Conteo de los días laborables del año seleccionado, excluyendo fines de semana, festivos y vacaciones.
    - **Conversión a Días:** Cuando las horas restantes son negativas (hay horas extra), la aplicación las convierte a **días de trabajo equivalentes** para una mejor visualización.

- **Cálculo de Horas Inteligente:**
    - Los días marcados como **Vacaciones** o **Festivo** se excluyen del cómputo de horas trabajadas.
    - Los días se consideran de **jornada intensiva** por defecto si caen dentro del rango configurado por el usuario, aunque no los marque manualmente en el calendario.

- **Pantalla de Ajustes Avanzada:**
    - **Tema:**
        - Interruptor para activar/desactivar el **Modo Oscuro**.
        - Selector de color para personalizar los marcadores de **Festivo**, **Vacaciones** y **Jornada Intensiva**.
    - **Configuración de Jornada:**
        - Campos de texto para definir las horas de la **jornada normal** e **intensiva**.
        - Campo de texto para establecer el **objetivo de horas anuales**.
    - **Período de Jornada Intensiva:**
        - Selectores de fecha que se adaptan al año seleccionado para definir un **rango de inicio y fin** para el período de jornada intensiva.

- **Persistencia de Datos:**
    - Todas las configuraciones y las marcas del calendario para cada año se guardan localmente en el dispositivo usando `shared_preferences`, por lo que los datos persisten entre sesiones.

- **Localización (i18n):**
    - La interfaz está disponible en **Inglés** y **Español**.

## Arquitectura

- **Gestión de Estado:** La aplicación utiliza el paquete `provider` para una gestión de estado reactiva y desacoplada.
    - `SettingsProvider`: Gestiona todas las configuraciones del usuario, incluyendo el **año seleccionado**.
    - `CalendarProvider`: Gestiona el estado del calendario y realiza todos los cálculos para la pantalla de resumen, reaccionando a los cambios en el `SettingsProvider` (como el cambio de año).
    - `ThemeProvider` y `ColorProvider`: Gestionan el tema y los colores.
- **Persistencia:** `shared_preferences` para el almacenamiento de datos del usuario, usando claves dinámicas para separar los datos por año (ej: `calendar_data_2026`).

## Plan Actual

La última gran actualización fue la refactorización completa de la aplicación para que dejara de estar limitada al año 2025. Se ha introducido un selector de año y se ha modificado toda la lógica de la aplicación para que sea dinámica y reutilizable año tras año, guardando los datos de cada período de forma independiente.
