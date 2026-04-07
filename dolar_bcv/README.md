# dolar_bcv

A new Flutter project.

## Stack Tecnológico

El stack de trabajo y las tecnologías que estamos empleando en este desarrollo son las siguientes:

1. Lenguaje de Programación 
- Dart: Es el lenguaje principal utilizado, aprovechando las capacidades del SDK 3.x para un tipado fuerte y alto rendimiento.

2. Framework Principal
- Flutter: Estamos desarrollando una aplicación multiplataforma (enfocada actualmente en Web y Móvil) que permite una interfaz de usuario fluida y reactiva.

3. Stack Tecnológico (Librerías Clave)
- Gestión de Estado: provider (para manejar la lógica de negocio y actualizar la UI de forma eficiente).
- Persistencia de Datos:
    - sqflite: Base de datos local para el historial de cálculos.
- shared_preferences: Para guardar configuraciones como el modo oscuro/claro.
- Comunicación en Red: http (para consultar las tasas del dólar en tiempo real).
- Diseño y UI:
    - flutter_screenutil: Para asegurar que la interfaz sea totalmente responsiva en diferentes tamaños de pantalla.
    - google_fonts: Para una tipografía moderna y premium.
    - cupertino_icons y Material Design: Para una estética visual consistente.
- Utilidades:
    - intl: Para el formato de moneda y fechas.
    - flutter_dotenv: Para el manejo seguro de variables de entorno (como APIs).

En Resumen: Es una arquitectura moderna de Flutter orientada a la eficiencia y a ofrecer una experiencia de usuario premium, con una separación clara entre la lógica de datos y la interfaz visual.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
