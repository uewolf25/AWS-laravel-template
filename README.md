# AWS-laravel-template
Create Laravel project template using Docker, Apache and MySQL

## Docker Images
- php
- mysql

## run
### your project clone
```bash
cd <template repository>
git clone <https://github.com/your/project.git> backend/
```

### if your project already exists ...
```bash
cd backend/
cp <your_project_env_file> .env
docker-compose exec web composer install
docker-compose exec web php artisan key:generate
docker-compose exec web php artisan storage:link
docker-compose exec web php artisan migrate:fresh --seed
```






