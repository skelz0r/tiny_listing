# Tiny Listing [![Build Status](https://travis-ci.org/skelz0r/tiny_listing.svg)](https://travis-ci.org/skelz0r/tiny_listing)

CRUD on ``index of /*`` with search functionnalities.

## Setup & requirements

Install ``redis``

### Postgresql and trigram

1. Install ``pg_trgm module``, on ubuntu:

```shell
[sudo] aptitude install postgresql-contrib
psql
> CREATE EXTENSION pg_trgm;
```

2. Create role and databases

```shell
psql
> CREATE ROLE tiny_listing SUPERUSER LOGIN PASSWORD 'tiny_listing';
> CREATE DATABASE tiny_listing_development with OWNER tiny_listing;
> CREATE DATABASE tiny_listing_test with OWNER tiny_listing;
```

## License

Tiny Listing is released under the [MIT
License](http://opensource.org/licenses/MIT)
