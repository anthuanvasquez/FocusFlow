## 🎯 Objetivo del MVP

Crear una app funcional que permita:

- Elegir una actividad o tarea
- Iniciar una sesión Pomodoro
- Reproducir sonidos de fondo
- Ver un historial básico de sesiones
- Personalizar duración y sonidos
- Medir el streak diario

---

## 🧭 Pantallas del MVP

### 1. 🏠 **HomeView (Pantalla principal)**

**Propósito:** punto de partida para elegir actividad/tarea y comenzar sesión.

**Componentes:**

- Lista de `Activity` o `Task`
- Botón “Iniciar sesión”
- Acceso a configuración y estadísticas

**Conexiones:**

- ViewModel: `HomeViewModel`
- Datos: `Activity`, `Task`, `UserSettings`

---

### 2. ⏱️ **TimerView (Sesión activa)**

**Propósito:** muestra el temporizador en marcha, los sonidos activos y controles básicos.

**Componentes:**

- Temporizador circular con cuenta regresiva
- Nombre de la actividad/tarea
- Botón de pausa/cancelar
- Iconos de sonido activo
- Animaciones suaves o fondo dinámico (opcional)

**Conexiones:**

- ViewModel: `TimerViewModel`
- Servicios: `TimerService`, `SoundService`
- Datos: `Session`, `Sound`, `SessionConfiguration`

---

### 3. 🎵 **SoundSettingsView (Elegir sonidos)**

**Propósito:** permite al usuario seleccionar los sonidos para la sesión.

**Componentes:**

- Lista de sonidos disponibles
- Player de previsualización
- Checkbox de selección múltiple
- Indicador de sonido premium (bloqueado si no es usuario premium)

**Conexiones:**

- ViewModel: `SoundSettingsViewModel`
- Datos: `Sound`, `UserSettings`

---

### 4. 📊 **StatsView (Historial básico)**

**Propósito:** ver un historial reciente y el progreso (streak).

**Componentes:**

- Lista de sesiones pasadas con actividad/tarea, duración y fecha
- Gráfico de sesiones por día (barras)
- Streak actual y mejor streak

**Conexiones:**

- ViewModel: `StatsViewModel`
- Datos: `Session`, `Streak`

---

### 5. ⚙️ **SettingsView (Configuración de sesión)**

**Propósito:** ajustar duración del Pomodoro, descansos y sonidos por defecto.

**Componentes:**

- Sliders para duración de sesión, descanso corto/largo
- Campo para ciclos antes del descanso largo
- Volumen de sonidos
- Botón para restaurar configuración por defecto

**Conexiones:**

- ViewModel: `SettingsViewModel`
- Datos: `UserSettings`, `SessionConfiguration`

---

## 🔄 Navegación básica

```
HomeView
 ├──> TimerView
 ├──> SoundSettingsView
 ├──> StatsView
 └──> SettingsView

```

---

## 🧠 ViewModels del MVP

| Pantalla | ViewModel | Rol principal |
| --- | --- | --- |
| HomeView | `HomeViewModel` | Carga actividades/tareas, permite seleccionar |
| TimerView | `TimerViewModel` | Controla temporizador, sonidos, guarda sesión |
| SoundSettingsView | `SoundSettingsViewModel` | Muestra sonidos y maneja selección |
| StatsView | `StatsViewModel` | Calcula historial y streak |
| SettingsView | `SettingsViewModel` | Maneja configuración del usuario y sincroniza cambios |
