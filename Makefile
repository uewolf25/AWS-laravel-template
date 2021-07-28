MYSQL_USER		= "user"
MYSQL_PASSWORD	= "pass"
MYSQL_DATABASE	= "database"

up:
	docker-compose up -d
build:
	docker-compose build --no-cache --force-rm
laravel-install:
	docker-compose exec web composer create-project --prefer-dist laravel/laravel .
laravel-install-git-bash:
	winpty docker-compose exec web composer create-project --prefer-dist laravel/laravel .
create-project:
	@make build
	@make up
	@make laravel-install
	docker-compose exec web php artisan key:generate
	docker-compose exec web php artisan storage:link
	@make fresh
create-project-git-bash:
	@make build
	@make up
	@make laravel-install-git-bash
	winpty docker-compose exec web php artisan key:generate
	winpty docker-compose exec web php artisan storage:link
	@make fresh-git-bash
init:
	docker-compose up -d --build
	docker-compose exec web composer install
	docker-compose exec web cp .env.example .env
	docker-compose exec web php artisan key:generate
	docker-compose exec web php artisan storage:link
	@make fresh
remake:
	@make destroy
	@make init
stop:
	docker-compose stop
down:
	docker-compose down
restart:
	@make down
	@make up
destroy:
	docker-compose down --rmi all --volumes --remove-orphans
destroy-volumes:
	docker-compose down --volumes --remove-orphans
ps:
	docker-compose ps
logs:
	docker-compose logs
web:
	docker-compose exec web bash
migrate:
	docker-compose exec web php artisan migrate
fresh:
	docker-compose exec web php artisan migrate:fresh --seed
fresh-git-bash:
	winptydocker-compose exec web php artisan migrate:fresh --seed
seed:
	docker-compose exec web php artisan db:seed
rollback-test:
	docker-compose exec web php artisan migrate:fresh
	docker-compose exec web php artisan migrate:refresh
test:
	docker-compose exec web php artisan test
optimize:
	docker-compose exec web php artisan optimize
optimize-clear:
	docker-compose exec web php artisan optimize:clear
cache:
	docker-compose exec web composer dump-autoload -o
	@make optimize
	docker-compose exec web php artisan event:cache
	docker-compose exec web php artisan view:cache
cache-clear:
	docker-compose exec web composer clear-cache
	@make optimize-clear
	docker-compose exec web php artisan event:clear
npm:
	@make npm-install
npm-install:
	docker-compose exec web npm install
npm-dev:
	docker-compose exec web npm run dev
npm-watch:
	docker-compose exec web npm run watch
yarn:
	docker-compose exec web yarn
yarn-install:
	@make yarn
yarn-dev:
	docker-compose exec web yarn dev
yarn-watch:
	docker-compose exec web yarn watch
db:
	docker-compose exec db bash
sql:
	docker-compose exec db bash -c 'mysql -u $(MYSQL_USER) -p $(MYSQL_PASSWORD) $(MYSQL_DATABASE)'
redis:
	docker-compose exec redis redis-cli
