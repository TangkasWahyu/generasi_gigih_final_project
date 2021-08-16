# Final Project Backend

## Problem Description

Social media application which can be used to share information with other people. This application will only be used by people that work in a certain company so we cannot use existing public social media.

## Built With
- Ruby
- Sinatra
- Mysql2

## How to Run Locally

```sh
ruby main.rb
```

### Before Run This App Locally

#### Please Install 
| Dependency | Link |
| ------ | ------ |
| Ruby | https://www.ruby-lang.org/en/downloads/ |
| Sinatra | http://sinatrarb.com/intro.html |
| Mysql2 | https://github.com/brianmario/mysql2 |

#### Create tweet_db
In mysql shell

```sh
create database tweet_db; 
use tweet_db;
source [working_directory]/tweet_db.sql
```

## How to Run Test Suite

### Before Run Test Suite

#### Please Install 
| Dependency | Link |
| ------ | ------ |
| Rspec | https://github.com/rspec/rspec |
| SimpleCov | https://github.com/simplecov-ruby/simplecov |

```sh
rspec

```

## Database schema
![gg_final_project](https://user-images.githubusercontent.com/86975716/129534967-0b7b353e-76ad-4abb-9873-124bbe405051.png)

## Postman Collection
[Postman collection with file sample](https://github.com/YudoWorks/generasi_gigih_final_project/tree/main/postman_collection_with_file_sample)

💪 Generasi Gigih Backend 2021
