- view: users
  view_label: Customer Information
  sql_table_name: demo_db.users
  fields:

######## Dimensions ######## 

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id
    
  - dimension: first_name
    type: string
    sql: ${TABLE}.first_name
    hidden: true

  - dimension: last_name
    type: string
    sql: ${TABLE}.last_name
    hidden: true
    
  - dimension: full_name
    label: Name
    type: string
    sql: ${first_name} || ' ' || ${last_name}
  
  - dimension: email
    type: string
    sql: ${TABLE}.email
    
  - dimension: gender
    type: string
    sql: ${TABLE}.gender

  - dimension: age
    type: number
    sql: ${TABLE}.age
    
  - dimension: age_tier
    type: tier                                   
    sql: ${age}                                 
    tiers: [0,10,20,30,40,50,60,70,80]            
    style: integer

  - dimension: city
    type: string
    sql: ${TABLE}.city

  - dimension: country
    type: string
    sql: ${TABLE}.country

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at

  - dimension: state
    type: string
    sql: ${TABLE}.state

  - dimension: zip
    type: number
    sql: ${TABLE}.zip
   
   
######## Measures ######## 

  - measure: count
    type: count
    drill_fields: detail*


  # ----- Sets of fields for drilling ------
  sets:
    detail:
    - id
    - last_name
    - first_name
    - events.count
    - orders.count
    - user_data.count

