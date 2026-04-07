# Manual de Recuperación de Emergencia - v3.0.0

Este documento contiene las instrucciones necesarias para volver a la versión estable **v3.0.0** (Dolar BCV Mobile) en caso de que cambios posteriores afecten el funcionamiento del código.

## Punto de Respaldo: v3.0.0
- **Fecha de Respaldo:** 2026-04-07
- **Tag:** `v3.0.0`
- **Versión en pubspec.yaml:** `3.0.0+1`
- **Rama original:** `feature/flutter-migration`

---

## Procedimientos de Recuperación

### 1. Recuperación Segura (Nueva Rama)
Si quieres recuperar el código de esta versión para seguir trabajando de forma independiente sin tocar tu progreso actual:
```bash
git checkout -b recuperacion-v3.0.0 v3.0.0
```

### 2. Recuperación Radical (Reset de la Rama Actual)
**¡CUIDADO!** Este comando sobrescribirá tu código actual con el de la v3.0.0. Úsalo solo si los cambios recientes no sirven:
```bash
git reset --hard v3.0.0
```

### 3. Consultar/Copiar Código Viejo (Modo Lectura)
Si solo necesitas ver cómo estaba hecho algo en la v3.0.0 sin cambiar nada en tu rama actual:
```bash
git checkout v3.0.0
```
Para volver al presente después de consultar:
```bash
git checkout feature/flutter-migration
```

---

## ¿Cómo verificar que estás en la versión correcta?
Al regresar a `v3.0.0`, el archivo `pubspec.yaml` mostrará:
`version: 3.0.0+1`

**Nota:** Este archivo fue generado automáticamente para asegurar la persistencia del conocimiento de recuperación de este proyecto móvil.
