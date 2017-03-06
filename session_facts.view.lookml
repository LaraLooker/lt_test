- view: session_facts
  derived_table:
    sql_trigger_value: SELECT DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', GETDATE()))
    indexes: [unique_session_id]
    sql: |
      WITH session_facts AS
          (
          SELECT
              unique_session_id
            , created_at
            , user_id
            , event_id
            , FIRST_VALUE (created_at) OVER (PARTITION BY unique_session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_start
            , LAST_VALUE (created_at) OVER (PARTITION BY unique_session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_end
          FROM 
          ${event_mapping.SQL_TABLE_NAME} AS events_with_session_info
          GROUP BY 1,2,3,4,5,6
          ORDER BY unique_session_id asc
         )
          SELECT
          session_facts.unique_session_id
          , session_facts.user_id
          , session_facts.session_start
          , session_facts.session_end
          , session_landing_page
          , session_exit_page
          , ROW_NUMBER () OVER (PARTITION BY session_facts.user_id ORDER BY MIN(session_start)) AS session_sequence_for_user
          , ROW_NUMBER () OVER (PARTITION BY session_facts.user_id ORDER BY MIN(session_start) desc) AS inverse_session_sequence_for_user
          , count(1) as events_in_session
          FROM ${session_facts.SQL_TABLE_NAME}
          INNER JOIN 
          events AS events_with_session_info
            ON
          events_with_session_info.created_at = session_facts.session_start
          AND events_with_session_info.unique_session_id = session_facts.unique_session_id
          GROUP BY 1,2,3,4,5,6
          ORDER BY session_start asc
   
 
  fields: 

  - dimension: unique_session_id
#     hidden: true
    primary_key: true
    type: number
    sql: ${TABLE}.unique_session_id     
    
#   - dimension_group: created_at
#     type: time
#     timeframes: [time, date, week, month]
#     sql: ${TABLE}.created_at   
#     
#   - dimension: user_id
#     type: number
#     sql: ${TABLE}.user_id  
#     
#   - dimension: event_id
#     type: number
#     sql: ${TABLE}.event_id
    
  - dimension_group: session_start_at
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.session_start

  - dimension_group: session_end_at
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.session_end

  - dimension: session_sequence_for_user
    type: number
    sql: ${TABLE}.session_sequence_for_user

  - dimension: inverse_session_sequence_for_user
    type: number
    sql: ${TABLE}.inverse_session_sequence_for_user

  - dimension: number_of_events_in_session
    type: number
    sql: ${TABLE}.number_of_events_in_session

  - dimension: session_landing_page
    type: string
    sql: ${TABLE}.session_landing_page

  - dimension: session_exit_page
    type: string
    sql: ${TABLE}.session_exit_page

  - dimension: session_length_seconds
    type: number
    sql: DATEDIFF('sec', ${TABLE}.session_start, ${TABLE}.session_end)
    
  - measure: average_session_length_seconds
    type: avg
    sql: ${session_length_seconds}
    

  sets:
    detail:
      - unique_session_id
      - session_start_at_time
      - session_end_at_time
      - session_sequence_for_user
      - inverse_session_sequence_for_user
      - number_of_events_in_session
      - session_landing_page
      - session_exit_page