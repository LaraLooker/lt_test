- view: t1
  sql_table_name: demo_db.T1
  fields:

######## Dimensions ######## 

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension: inventory_item_id
    type: number
    # hidden: true
    sql: ${TABLE}.inventory_item_id

  - dimension: order_id
    type: number
    # hidden: true
    sql: ${TABLE}.order_id

  - dimension_group: returned
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.returned_at

  - dimension: sale_price
    type: number
    sql: ${TABLE}.sale_price

######## Measures ######## 

  - measure: count
    type: count
    drill_fields: [id, orders.id, inventory_items.id]

