# Contenedor Oracle SQL

Este repositorio tiene fines educacionales.
A continuacion revisaremos como correr el contenedor en nuestros computadores, y como correr el script `sesion1.sql` el cual se encuentra disponible en el directorio.

## Verificando funcionamiento de Docker

```
docker --version
docker-compose --version
```
Con esto deberiamos obtener como output la version de docker y la version de docker-compose respectivamente.

Si es que no tenemos docker instalado, primero debemos procurar instalarlo desde su pagina oficial -> https://www.docker.com/products/docker-desktop/

### Cuenta en Oracle Container Registry

Para poder descargar la imagen de Oracle, debemos estar logeados con nuestra cuenta de Oracle, asi que debemos:

1. Ir a [https://container-registry.oracle.com/](https://container-registry.oracle.com/).
2. Crea una cuenta gratuita o iniciar sesión si ya tienes una.
3. Una vez creada la cuenta nos logeamos desde nuestra linea de comandos.
4. Ingresar en la linea de comandos `docker login container-registry.oracle.com`
5. Si el login es exitoso veras: *Login Succeeded*

### Construir y levantar el Contenedor

Desde la carpeta raiz, ejecutar:

`docker-compose up --build`

Esto construye el contenedor y lo ejecuta.

*La primera vez que ejecutes este comando, Docker descargará la imagen de Oracle Database (container-registry.oracle.com/database/express:21.3.0-xe), que es grande (varios GB). Esto puede tomar varios minutos dependiendo de tu conexión a internet.
Una vez que la imagen se descargue, el contenedor se iniciará. Verás logs en la terminal. Espera hasta que veas un mensaje como
`DATABASE IS READY TO USE!`*


### Conéctate a la Base de Datos

Abre una nueva terminal (no cierres la terminal donde ejecutaste docker-compose up).
Accede al contenedor:
`docker-compose exec oracle-db bash`

*El nombre del container (oracle-db) deberia coincidir con el nombre del servicio en ocker-compose.yml. Si nombraste el servicio con otro nombre, debe modificar este comando.*

Una vez dentro deberiamos ver: `bash-4.2$ ` junto con el cursor para poder ingresar comandos al servidor Oracle.

Ahora, conectemonos a la base de datos usando `sqlplus`

`sqlplus sys/oracle@//localhost:1521/XE as sysdba`

Aqui utilizamos:
* Username: `sys`
* Password: `oracle` (o lo que hayamos configurado en la variable de entorno `ORACLE_PWD` de docker-compose.yml)
* SID: `XE`

Si la conexion es exitosa, veremos el prompt de SQL:

`SQL> `

Intenta correr una query simple para testear:

`SELECT * FROM DUAL;`

### Ejecutemos el archivo SQL de la sesion 1.

Estando en la carpeta raiz, primero copiemos el archivo en el contenedor `docker cp sesion1.sql oracle_db_course:/tmp/sesion1.sql`

Accedemos al contenedor tal como hicimos anteriormente:

`docker-compose exec oracle-db bash`

Nos conectamos a la base de datos:

`sqlplus sys/oracle@//localhost:1521/XE as sysdba`

Y ejecutamos el script desde la carpeta `tmp` ejecutando:

`@/tmp/sesion1.sql`

Con esto, hemos ejecutado el punto 1 de la actividad practica de la sesion 1.1 (Diapositiva 21).

**Termine la actividad practica de la sesion 1.1 y la sesion 2.**



