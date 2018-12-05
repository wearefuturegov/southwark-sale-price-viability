# Southwark Sale Price Viability

A microservice that attempts to tell if a developer's sales value for a
proposed development is realistic.

[![CircleCI](https://circleci.com/gh/wearefuturegov/southwark-sale-price-viability.svg?style=svg)](https://circleci.com/gh/wearefuturegov/southwark-sale-price-viability)

## Installing

Clone the repo:

```
git clone https://github.com/wearefuturegov/southwark-sale-price-viability.git
```

Install the dependencies:

```
bundle install
```

Import the data:

```
bundle exec rake properties:import
```

(This may take 10 minutes or so)

Spin up the server:

```
bundle exec rails s
```

## Using the API

There is a single endpoint, that responds to a GET request:

```
http://localhost:3000/expected_range?lat={latitude_of_development}&lng={longitude_of_development}&sale_price={expected_sale_price}&size={size_in_square_metres}
```

This then returns JSON in the format:

```JSON
{ "expected": true }
```

or

```JSON
{ "expected": false }
```

See an example of the API in use at [https://southwark-sale-price-demo.herokuapp.com/](https://southwark-sale-price-demo.herokuapp.com/)
