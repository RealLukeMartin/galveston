## Using this Image

To run

```
docker run --name galveston -P --link your-postgres:postgres -d reallukemartin/galveston
```

##### _or_

```
docker run --name galveston -P --link your-mysql:mysql -d reallukemartin/galveston
```


The only difference between the 2 commands is the database you choose. To build the database image that you want to  link to:

### PostgreSQL
`docker run --name your-postgres -P -e POSTGRES_PASSWORD=password -d postgres`

### MySQL
`docker run --name your-mysql -P -e MYSQL_PASSWORD=password -d mysql`

---

### * [Houston install profile](https://github.com/poetic/houston)

### * [Galveston on Docker Hub](https://hub.docker.com/r/reallukemartin/galveston/)
