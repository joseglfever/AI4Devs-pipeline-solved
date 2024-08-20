## PROMPTS

**- Prompt:** Quiero que actues como un senior developer experto en testing para crear test unitarios que garanticen que se cumplen los criterios de aceptacion. Utiliza buenas prácticas de testing en la medida de lo posible, y añade todos los casos límite que considere, para la siguiente historia de usuario:

```
Añadir Candidato al Sistema
Como reclutador,
Quiero tener la capacidad de añadir candidatos al sistema ATS,
Para que pueda gestionar sus datos y procesos de selección de manera eficiente.


Criterios de aceptacion:
- El endpoint debe recibir y validar correctamente todos los datos del formulario según las especificaciones, incluyendo múltiples CVs.
- Los datos válidos deben almacenarse correctamente en la base de datos.
- Debe retornar un mensaje de éxito o error adecuado al cliente, incluyendo detalles específicos del error si es necesario.
```

Contexto del proyecto:

- Es una aplicación Express escrita en TypeScript. En @api-spec.yaml está la documentacion para los endpoints y en @validator.ts estan todas las validaciones para los datos de entrada. En @candidateRoutes.ts puedes consultar la respuesta del servidor

Quiero que antes de empezar me preguntes todas las dudas

**-Prompt:** vamos a comenzar creando tests unitarios para el endpoint de añadir candidatos. Quiero que utilices mocks para no alterar la base de datos

**-Prompt:** podemos parametrizar todas las pruebas que siguen un patron similar pero con diferentes entradas para asi evitar duplicar código

**-Prompt:** vamos a parametriz tambien todos los tests que siguen el patron "deberian tener exito sin el campo xxx"

**-Prompt:** ahora vamos a añadir test unitarios para cubrir el endpoint /upload. Quiero mockear este test para que no cree ningun fichero en el servidor

**-Prompt:** quiero que añadas comentarios en @tests-LGP.test.ts para entender mejor qué cubre cada test

**-Prompt:** ayudame a pensar en algun caso límite para la historia de usuario

*Nota: me propone algunos casos límite, como por ejemplo "Fechas de inicio y fin de educación/experiencia laboral en el futuro o 
Fechas de inicio posteriores a las fechas de fin", pero la propia aplicacion aún no contempla esos casos como errores, por lo que no creo esos tests*

**-Prompt:** quiero que revises los test unitarios para saber si se podría hacer alguna mejora

**-Prompt:** quiero que revises los tests @tests-LGP.test.ts y que hagas las modificaciones necesarias para convertirlos en test unitarios, enfocados a cubrir los metodos de @candidateService.ts y @fileUploadService.ts 

Antes de hacer los cambios quiero que me preguntes las dudas y que me muestres cómo lo harás