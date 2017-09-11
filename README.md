# How to to run ?

  - Install docker, docker-compose

### For first time:
  ```sh
  $ docker-compose build web
  $ docker-compose up
  ```
  
### Doc for endpoints
 * http://localhost:3000/apidoc/index.html

### Test
  ```
  $ docker-compose run --rm web bundle exec rspec
   ```
   