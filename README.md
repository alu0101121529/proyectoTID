* Instalación de git-lfs

Solo hay que usar el comando ``sudo apt-get install git-lfs``

Luego ya te debería de dejar usar la configuración del repo

Una vez hayan hecho el clone, se les descargarán los ficheros como punteros de git-lfs
para solucionar esto, usaremos los siguientes comandos

```bash
git lfs checkout
git lfs fetch
```

Y se les deberá descargar los ficheros bien, comprueben sus tamaños
