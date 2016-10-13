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
    hidden: false
    
  - dimension: last_name
    type: string
    sql: ${TABLE}.last_name
    hidden: true

  - dimension: full_name
    type: string
    sql: CONCAT(first_name,' ',last_name)
    hidden: true

  - dimension: access
    type: number
    sql: |
        CASE WHEN {{ _access_filters["users.access"] }} = '1' THEN '1'
        WHEN {{ _access_filters["users.access"] }} = '2' THEN '2'
        ELSE '3'
        END
  
  - dimension: name
    label: Name
    type: string
    sql: |
      CASE WHEN ${access} = '1' THEN ${full_name}
      WHEN ${access} = '2' THEN MD5(${full_name})
      ELSE 'You do not have access to view this content'
      END
 
#   - dimension: name
#     label: Name
#     type: string
#     sql: |
#       CASE WHEN {{ _access_filters["users.name"] }} = '1' THEN ${full_name}
#       WHEN {{ _access_filters["users.name"] }} = '2' THEN MD5(${full_name})
#       ELSE 'You do not have access to view this content'
#       END
      
  - measure: name_list
    type: list
    list_field: name
  
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

