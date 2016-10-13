- view: users_with_extensions
  extends: users

  fields:
  
  - dimension: name
    description: "The unique ID for each customer"
    type: string
    sql: CONCAT(SUBSTRING(${first_name}, 1, 2), HEX(${id}), SUBSTRING(${last_name}, 1, 2))
