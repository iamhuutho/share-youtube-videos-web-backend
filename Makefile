build:
	docker-compose build

up:
	docker-compose up

down:
	docker-compose down

bash:
	docker-compose exec web bash

migrate:
	docker-compose exec web rails db:migrate

seed:
	docker-compose exec web rails db:seed

logs:
	docker-compose logs -f

ps:
	docker-compose ps

clean:
	docker-compose down --volumes --remove-orphans
	docker system prune -f
