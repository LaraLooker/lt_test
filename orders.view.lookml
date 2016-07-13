- view: orders
  sql_table_name: demo_db.orders
  fields:

######## Dimensions ######## 

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.created_at

  - dimension: status
    type: string
    sql: ${TABLE}.status

  - dimension: user_id
    type: number
    # hidden: true
    sql: ${TABLE}.user_id
    
  - dimension: time_pending
    type: number
    sql: CASE WHEN ${status} = 'pending' THEN TIMESTAMPDIFF(day, ${created_raw}, NOW())*1.0 ELSE 0 END
    
######## Measures ######## 

  - measure: count
    type: count
    drill_fields: detail*
    
  - measure: cancelled_orders
    type: count
    filters:
      status: 'cancelled'
    drill_fields: detail*
      
  - measure: percent_orders_cancelled
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${cancelled_orders}/NULLIF(${count},0)
    drill_fields: detail*
  
  - measure: pending_orders
    type: count
    filters:
      status: 'pending'
    drill_fields: detail*


  # ----- Sets of fields for drilling ------
  sets:
    detail:
    - id
    - users.last_name
    - users.first_name
    - users.id
    - order_items.count
    - t1.count

