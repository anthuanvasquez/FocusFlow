## 💎 Features para el plan **Premium** (propuestas)

Te agrupo las ideas por áreas de la app:

---

### 🎵 Sonido y ambiente

| Feature | Tipo de restricción |
| --- | --- |
| Acceso a todos los sonidos (naturaleza, lo-fi, lluvia, etc.) | Sonidos extra bloqueados |
| Mezclar varios sonidos a la vez | Limitado a 1 en versión gratuita |
| Guardar presets de sonidos | Solo premium |
| Temporizador de sonido (detener antes que la sesión) | Premium |

---

### ⏱️ Personalización de sesiones

| Feature | Tipo de restricción |
| --- | --- |
| Configurar duración personalizada por actividad | Solo duraciones estándar en free |
| Pomodoro flexible (con sesiones adaptativas) | Premium |
| Establecer ciclos con descansos largos | Limitado o desactivado en versión free |

---

### 📊 Estadísticas y productividad

| Feature | Tipo de restricción |
| --- | --- |
| Historial completo de sesiones | Solo últimas 5-10 en versión free |
| Estadísticas avanzadas (tiempo por proyecto, foco, días más productivos) | Premium |
| Exportar historial a CSV o PDF | Solo premium |
| Backups automáticos en iCloud | Premium |

---

### 🧠 Foco y motivación

| Feature | Tipo de restricción |
| --- | --- |
| Modos de enfoque (Deep Work, Sprint, Zen, etc.) | Premium |
| Recordatorios inteligentes (basados en hábitos) | Premium |
| Desbloqueo de badges/logros | Solo premium |
| Desafíos de enfoque semanales | Premium |

---

### 🧩 Integraciones y extras

| Feature | Tipo de restricción |
| --- | --- |
| Integración con calendario (Apple, Google) | Solo premium |
| Sincronización entre dispositivos | Solo premium |
| Widgets para pantalla de inicio | Solo premium |
| Modo sin conexión completo | Limitado o no disponible en free |

---

### 💡 Estrategia para el MVP

Para la primera versión, podrías:

- Ofrecer solo **5 sonidos gratuitos**, el resto como premium.
- Limitar el historial a las **últimas 10 sesiones**.
- Permitir solo una configuración de sesión (25/5/25/15) en modo gratuito.
- Mostrar algunas **funcionalidades bloqueadas** para motivar la suscripción.
- Activar **streak**, pero sin estadísticas profundas (solo día actual y racha).

---

## 🔓 Desbloqueo de premium

Define una propiedad simple en el modelo de usuario:

```swift
struct User {
    let isPremium: Bool
    ...
}

```

Y luego, condicionales en cada módulo para habilitar/deshabilitar vistas o acciones según ese flag.
