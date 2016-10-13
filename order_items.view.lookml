- view: order_items
  sql_table_name: demo_db.order_items
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
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.returned_at

  - dimension: days_returned
    type: number
    sql: TIMESTAMPDIFF(day, ${orders.created_raw}, ${returned_raw})*1.0
    
  - dimension: sale_price
    type: number
    sql: ${TABLE}.sale_price
    
  - dimension: gross_margin
    type: number
    sql: ${sale_price} - ${inventory_items.cost}
    value_format_name: usd
    
######## Measures ######## 

  - measure: count
    type: count
    drill_fields: [id, orders.id, inventory_items.id, sale price]

  - measure: total_sale_price
    type: sum
    sql: ${sale_price}
    drill_fields: [id, sale_price]

  - measure: smallest_order_items
    type: min
    sql: ${sale_price}
    value_format_name: usd
  
  - measure: largest_order_items
    type: max
    sql: ${sale_price}
    value_format_name: usd
  
  - measure: cumulative_total_revenue
    type: running_total
    sql: ${total_sale_price}
    value_format_name: usd
    
  - measure: average_sale_price
    type: average
    sql: ${sale_price}
    drill_fields: [id, sale_price]
  
  - measure: average_spend_per_customer
    type: number
    value_format_name: usd
    sql: 1.0 * ${total_sale_price}/NULLIF(${users.count}, 0)
    drill_fields: detail*

  - measure: total_gross_margin
    type: sum
    sql: ${gross_margin}
    
  - measure: percent_of_total_gross_margin
    type: percent_of_total
    sql: ${total_gross_margin}

  - measure: average_days_returned
    type: average
    sql: ${days_returned}
    drill_fields: [id, orders.created, returned, days_returned, sale_price]
    html: |
          <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>

  - measure: returned_order_items
    type: count
    hidden: true
    filters: 
      returned_time: '-NULL' 

  - dimension_group: date
    type: time
    timeframes: [raw, date, week, month]
    sql: NOW()
    
  - measure: percent_order_items_returned
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${returned_order_items}/NULLIF(${count},0)
    html: |
      {{ rendered_value }} || {{ count._rendered_value }} total orders
  
  - measure: average_percent_returned
    type: average
    value_format_name: percent_2
    sql: ${percent_order_items_returned}
    
  # ----- Sets of fields for drilling ------
  sets:
    detail:
    - id
    - events.count
    - orders.count
    - user_data.count
    - returned_order_items
    
 
  
