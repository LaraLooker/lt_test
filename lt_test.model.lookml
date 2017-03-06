- connection: thelook

- include: "*.view.lookml"       # include all the views
- include: "*.dashboard.lookml"  # include all the dashboards

- explore: events
  joins:
    - join: users
      type: left_outer 
      sql_on: ${events.user_id} = ${users.id}
      relationship: many_to_one


- explore: inventory_items
  joins:
    - join: products
      type: left_outer 
      sql_on: ${inventory_items.product_id} = ${products.id}
      relationship: many_to_one


- explore: order_items
  access_filter_fields: [users.access]
  joins:
    - join: orders
      type: left_outer 
      sql_on: ${order_items.order_id} = ${orders.id}
      relationship: many_to_one

    - join: inventory_items
      type: left_outer 
      sql_on: ${order_items.inventory_item_id} = ${inventory_items.id}
      relationship: many_to_one

    - join: users
      type: left_outer 
      sql_on: ${orders.user_id} = ${users.id}
      relationship: many_to_one

    - join: products
      type: left_outer 
      sql_on: ${inventory_items.product_id} = ${products.id}
      relationship: many_to_one

# 
# - explore: order_items_with_extensions
#   access_filter_fields: [users_with_extensions.name]
#   label: order_items_with_extensions
#   extends: order_items
#   view: order_items
# #   from: order_items
#   joins:
#     - join: users_with_extensions
#       from: users_with_extensions

    
- explore: orders
  joins:
    - join: users
      type: left_outer 
      sql_on: ${orders.user_id} = ${users.id}
      relationship: many_to_one

- explore: products


- explore: Customer_Purchase_History
  joins:
    - join: users
      type: left_outer 
      sql_on: ${Customer_Purchase_History.user_id} = ${Customer_Purchase_History.id}
      relationship: many_to_one


- explore: users
  hidden: true
  
- explore: session_facts

- explore: sessions

