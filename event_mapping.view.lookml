
- view: event_mapping
  derived_table:
    sql_trigger_value: SELECT DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', GETDATE()))
    indexes: [events.id]
#     sort_keys: [created_at]
    sql: |
      SELECT
          events.id AS event_id
        , events.user_id
        , sessions.unique_session_id
        , events.page_path
        , events.created_at AS created_at
        , ROW_NUMBER() OVER (PARTITION BY unique_session_id ORDER BY events.created_at) AS event_sequence_within_session
        , ROW_NUMBER() OVER (PARTITION BY unique_session_id ORDER BY events.created_at desc) AS inverse_event_sequence_within_session
      FROM events
      INNER JOIN ${sessions.SQL_TABLE_NAME} AS sessions
        ON events.user_id = sessions.user_id
        AND events.created_at >= sessions.session_start
        AND events.created_at < sessions.next_session_start
      WHERE 
        ((events.created_at) >= (DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ))  AND (events.created_at) < (DATEADD(day,30, DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ) )))
      
  fields:
  
  - measure: count
    type: count
    drill_fields: detail*

  - dimension: event_id
    primary_key: true
    hidden: true
    type: number
    sql: ${TABLE}.event_id

  - dimension: unique_session_id
    type: number
    hidden: true
    sql: ${TABLE}.unique_session_id

  - dimension: page_path
    hidden: true
    sql: ${TABLE}.page_path

  - dimension: event_sequence_within_session
    type: number
    sql: ${TABLE}.event_sequence_within_session

  - dimension: inverse_event_sequence_within_session
    type: number
    sql: ${TABLE}.inverse_event_sequence_within_session

  sets:
    detail:
    - event_id
    - unique_session_id
    - event_sequence_within_session
    - inverse_event_sequence_within_session
    - session_landing_page
    - session_exit_page
