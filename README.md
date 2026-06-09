# Declaraciones Juradas de Bienes — Intendentes y Concejales de Paraguay (1996–2026)

Base de datos tabular de las Declaraciones Juradas de Bienes (DJB) de intendentes y
concejales electos en Paraguay durante el período democrático, desde las elecciones
municipales de 1996 hasta 2021.

**Fuente:** [Portal DJB — Contraloría General de la República](https://portaldjbr.contraloria.gov.py/portaldjbr/)

---

## Estructura del repositorio

```
.
├── datos/                         ← Datos finales limpios, organizados por distrito
│   ├── central/
│   │   ├── capiata/
│   │   │   ├── intendentes/       ← Archivos: 1996_entrada.xlsx, 2001_salida.xlsx, etc.
│   │   │   └── concejales/
│   │   └── [resto de distritos de Central]
│   ├── asuncion/
│   │   └── asuncion/
│   └── cordillera/
│       ├── altos/
│       └── sanbernardino/
│
├── manual/
│   └── manual_estudiantes.Rmd     ← Manual completo del proyecto (compilar a HTML)
│
├── muestra/                       ← Templates Excel y documentos de referencia
│   ├── plantilla1_UNO.xlsx
│   ├── plantilla2_DOS.xlsx
│   ├── plantilla3_TRES.xlsx
│   └── Guidelines template *.docx
│
├── registro_progreso/
│   └── progreso.xlsx              ← Hoja de seguimiento del estado por distrito/año/cargo
│
├── manuales_e_infos_criticas/
│   └── nombres_estandarizados_distritos_PRY.xlsx
│
└── 00_datos/
    └── full_intendentes_margen_2001_2021.RData
```

> **Nota:** Los PDFs originales y los archivos de trabajo en progreso **no** se almacenan
> en este repositorio. Están en el Google Drive compartido del equipo.

---

## Convención de nombres

### Archivos en `datos/`

```
[año]_[tipo].xlsx
```

| Tipo | Significado |
|---|---|
| `entrada` | DJB al asumir el cargo |
| `salida` | DJB al dejar el cargo |
| `actualizacion` | DJB intermedia durante el mandato |
| `otros` | DJB de un cargo distinto al municipal |
| `sin_clasificar` | Tipo indeterminado — pendiente de revisión |

**Ejemplos:** `2015_entrada.xlsx`, `2021_salida.xlsx`, `2018_actualizacion.xlsx`

---

## Elecciones municipales cubiertas

| Año | Período de mandato |
|---|---|
| 1996 | 1996–2001 |
| 2001 | 2001–2006 |
| 2006 | 2006–2010 |
| 2010 | 2010–2015 |
| 2015 | 2015–2021 |
| 2021 | 2021–2026 |

Además de estas elecciones ordinarias, existen elecciones **complementarias** en años
irregulares (ej. 1998, 2002) correspondientes a municipios de nueva creación.

---

## Equipo

| Rol | Nombre | Distritos |
|---|---|---|
| Investigador principal | Camilo | San Bernardino, Altos |
| Estudiante | Alejandra | Capiatá, Areguá, Villeta, Fernando de la Mora |
| Estudiante | Samuel | San Lorenzo, Luque, Ypané, Guarambaré |
| Estudiante | Isabel | Mariano Roque Alonso, Asunción, Limpio, José Augusto Saldívar |
| Estudiante | Joel | Lambáre, Villa Elisa, San Antonio, Ñemby |
| Estudiante | Daniel | Itá, Ypacaraí, Itauguá, Nueva Italia |
| Asistente | Leti | Validación y revisión cruzada |
| Asistente | Fabri | Validación y revisión cruzada |

---

## Cómo contribuir

1. Cloná el repositorio (una sola vez):
   ```bash
   git clone https://github.com/camiloabbate/concejales_intendentes_djb_py_1996_2026.git
   ```

2. Antes de empezar a trabajar cada día:
   ```bash
   git pull
   ```

3. Cuando terminás un Excel, copialo a la carpeta correspondiente en `datos/` y:
   ```bash
   git add datos/central/capiata/intendentes/2015_entrada.xlsx
   git commit -m "agrego DJB 2015 entrada intendente Capiata"
   git push
   ```

Para el flujo de trabajo completo, las instrucciones de llenado y los casos especiales,
consultá el **[manual del proyecto](manual/manual_estudiantes.Rmd)** (compilar con RStudio
o `rmarkdown::render("manual/manual_estudiantes.Rmd")`).

---

## Estado del proyecto

Ver [`registro_progreso/progreso.xlsx`](registro_progreso/progreso.xlsx) para el estado
actualizado por distrito, año y cargo.

---

*Proyecto de investigación — uso interno del equipo.*
