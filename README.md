
# Symfony-CRUD-Docker

A basic Symfony CRUD demo with Docker implementation.


- Clone the repository.

- In terminal, go inside the cloned repo directory:
  - create and pull required docker images:
```bash
  docker pull mysql
  docker pull phpmyadmin
  docker build -t symfony-app:1.2 .
```
  - Run the compose file:
```bash
  docker-compose -f docker-compose.yml up
```
  - Migrate the database migrations:
```bash
  docker ps
  docker exec -it PID_symfonyapp sh
  (EX: docker exec -it 6e93c93fe32b sh)
  php bin/console doctrine:migrations:migrate
```
  - Open browser: 
    - Run project: [http://0.0.0.0:8083/post/](http://0.0.0.0:8083/post/)
    - Run phpmyadmin: [http://0.0.0.0:8082/index.php?route=/&route=%2F&db=dockerDemoDB&table=post](http://0.0.0.0:8082/index.php?route=/&route=%2F&db=dockerDemoDB&table=post)
    - Login with: ` docker/password `

