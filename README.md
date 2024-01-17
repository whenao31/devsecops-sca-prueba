<div align="center">
  <h1>DevSecOps Prueba técnica</h1>
  <strong>📕 Docs</strong><br>
</div>
<br>

En el presente repositorio se encuentra:

* En la ruta '/cicd/scripts' el Script para llevar a cabo el análisis de composición del software(SCA) para ser ejecutado desde un paso del pipeline CICD.

* Un directorio con el Dockerfile que se usa para desplegar la base de datos del servicio SAC en la plataforma de gestión de vulnerabilidades.

* El resto de directorios pertenece al código base de un servicio desarrollado con el framework web Django de Python y poder desplegarlo en servicios de AWS bajo prácticas DevSecOps.

## Despliegue del Servicio SAC en la plataforma de gestión de vulnerabilidades

### 🏗 Infraestructura

Este servicio, compuesto del ambiente integrado(API Rest + UI) y una base de datos NoSql de Mongo se encuentra contenerizado y su plataforma de operación es Docker Compose.

Existe el archivo '/cicd/infraDeploy.jenkinsfile' para el pipeline desarrollado en Jenkins que despliega una instancia EC2 de AWS que va a correr el Docker Engine para albergar y servir el servicio en cuestión.

### Despliegue servicio SCA

Si desea ejecutar la aplicación **localmente** siga los siguientes pasos:

(1) Clonar el repositorio
(2) Guardar en la raiz del repositorio descargado un archivo de variables de entorno .env, con los valores requeridos tanto en la el codigo del servicio como en el archivo docker compose. Como ejemplo se ilustra el siguiente archivo:

```bash
# .env file example
MONGO_DB_HOST='mydb'
MONGO_DB_PORT=27017
MONGO_DB_USER='admin'
MONGO_DB_PWD='admin'
DB_NAME='ms_db'

MONGO_INITDB_ROOT_USERNAME='admin'
MONGO_INITDB_ROOT_PASSWORD='admin'
MONGO_INITDB_DATABASE='ms_db'
```
(3) Ejecutar el siguiente comando de bash desde la terminal desde la carpeta raíz para desplegar el servicio que recibe las notificaciones de los resultados del SCA:

```bash
# Run the composed service
$ docker-compose up --force-recreate --build
```
(4) En otro terminal abra una sesión interactiva en el contenedor del servicio averiguando de antemano el identificador que Docker le asigna con 'docker ps':

```bash
# Check running containers an
$ docker ps

# Run an interactive tty in the container
$ docker exec -it <CONTAINER_HASH_ID> bash
```
(5) En la sesión interactiva del bash del contenedor correr el comando para hacer correr la app Django:
```bash
$ python manage.py runserver
```
(6) Si advierte que hay migraciones pendientes para hacer ejecute los comandos
```bash
$ python manage.py makemigrations

$ python manage.py migrate
```
(7) Si se hizo una migración por primera vez debe crear un superusuario para Django donde la consola le pedira que ingrese un correo y la contrasena al ejecutar este comando:
```bash
$ python manage.py createsuperuser --username <admin_user>
```
(8) Con el superusuario creado, desde su navegador de internet visite el sitio 'http://localhost:8000/admin/' y haga login con las credenciales del superusuario del paso (7). Solo lleve a cabo este paso para verificar que tiene superusuario de admin de django.

(9) Vuelva a la terminal con la sesion de bash del contenedor del servicio y genere un token que va a ser necesario para poder hacer las peticiones a la API Rest y guardelo para luego:
```bash
$ python3 manage.py drf_create_token <admin_user>
```
Con los anteriores pasos ya tendra la aplicación lista para operar con los siguientes puntos de entrada:

- http://localhost:8000/admin/ -> Consola de administración de django.
- http://localhost:8000/api/results/ -> API Rest con los diferentes endpoints(CRUD inicialmente) que se encarga de las peticiones que le envie el Script de reporte de resultados que corre desde el pipeline. Provee una UI debido al uso del django-rest-framework.
- http://localhost:8000/ -> Sirve la UI de la aplicación.

Si desea ejecutar la aplicación desplegada en la instancia **AWS EC2** se hace de manera similar, pero debe poder contar con las credenciales para una conexion SSH o desde la consola de la cuenta de AWS; para luego seguir el procedimiento mencionado justo antes.

Con la aplicacion corriendo publicamente, el pipeline 'cicd/Jenkinsfile' puede llevar a cabo el paso del analisis SCA invocando al Script que reporta los resultados a la API.

## Benchmark de Herramientas SCA

El siguiente cuadro comparativo resume diferentes capacidades que poseen estas herramientas en su mayoría de licencia OSS y con indicadores de Básico(B), Medio(M) y Avanzado(A):

|  | Snyk | OSV | OSSAudit(SonaType) | Jake(SonaType) |
| --- | --- | --- | --- | --- |
| Identificacion de vulnerabilidades | M | A | B | B |
| Capacidad de Remediacion | A | M | M | B | 
| Licencia | M | A | B | B | 
| Comunidad | A | M | M | M | 

De la gran cantidad de herramientas tanto de licencias comerciales como OSS para el SCA, se destaca que herramientas como Snyk tienen una gran comunidad que la acoge. Por otro lado OSV provee gran cantidad de hallazgos en sus analisis y un modelo de datos muy completo. Y aunque Ossaudit y Jake se encuentran acogidas por el mismo conglomerago(Sonatype) a la hora de probar la herramienta con el desarrollo en cuestión, Ossaudit reportaba ligeramente un poco mas de vulnerabilidades críticas que Jake, pero siempre por debajo que las que presentaba OSV.

Con base en lo anterior se selecciona OSV, por ser un proyecto OSS que provee las vulnerabilidades casi siempre con referencias para la remediación y con un modelo de datos muy completo.

> **Otros Entregables:**
> La url publica donde se encuentra expuesta la UI: http://54.158.47.114:8000/
> La url publica de la API: http://54.158.47.114:8000/api/results
> Servidor Jenkins para verificación de pipelines: http://54.159.44.138:8080/ (Credenciales para acceso via email)
> 

#### Oportunidades de Mejora:
- Despliegue en Kubernetes
- Despliegue automatico
- Arquitectura limpia
- Seguridad de la infraestructura de red(WAF, SSL)