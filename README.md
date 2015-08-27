# SpiQuLe

SQLをパースして好きなように加工するためのライブラリです。

## Usage

```ruby
> parser = Spiqule::Parser.build('select')
> parser.parse('select users.id, distinct users.company_id from users where id is not null group by users.id order by users.id asc, users.age desc limit 10;')
=> 
{
  select_exprs: [
    {table_name: {identifier=>"users"}, field_name: {identifier: "id"}},
    {distinct: "distinct", table_name: {identifier: "users"}, field_name: {identifier: "company_id"}}
  ],
  table_name: {identifier: "users"},
  where_conditions: {
    lhs: {field_name: {identifier: "id"},
    op: "is not",
    rhs: {value: "null"}}
  },
  group_by: {table_name: {identifier: "users"}, field_name: {identifier: "id"}},
  order_by: [
    {table_name: {identifier: "users"}, field_name: {identifier: "id"}, direction: "asc"},
    {table_name: {identifier: "users"}, field_name: {identifier: "age"}, direction: "desc"}
  ],
  limit: {limit_count: "10"}
}
```
