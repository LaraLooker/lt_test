- view: products
  sql_table_name: demo_db.products
  fields:
  
######## Dimensions ######## 

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension: brand
    type: string
    sql: ${TABLE}.brand
    
    
  - dimension: is_facebook_enabled
    group_label: Outlets
    sql: ${brand} IS NOT NULL
    html: <center> <img src="https://cdn1.iconfinder.com/data/icons/logotypes/32/square-facebook-512.png" height = "50"> <b> <br> Facebook Enabled </b> </a>

  - dimension: is_twitter_enabled
    group_label: Outlets
    sql: ${brand} IS NOT NULL
    html: <center> <img src="https://cdn0.iconfinder.com/data/icons/social-flat-rounded-rects/512/twitter_letter-512.png" height = "50"> <b> <br> Twitter Enabled </b> </a>

  - dimension: is_tumblr_enabled
    group_label: Outlets
    sql: ${brand} IS NOT NULL
    html: <center> <img src="http://vignette1.wikia.nocookie.net/olympians/images/b/b5/Tumblr-icon.png/revision/latest?cb=20130701204200" height = "50"> <b> <br> Tumblr Enabled </b> </a>

  - dimension: is_googleplus_enabled
    group_label: Outlets
    sql: ${brand} IS NOT NULL
    html: <center> <img src="http://icons.iconarchive.com/icons/marcus-roberto/google-play/256/Google-plus-icon.png" height = "50"> <b> <br> Google Plus Enabled </b> </a>

  - dimension: is_instagram_enabled
    group_label: Outlets
    sql: ${brand} IS NOT NULL
    html: <center> <img src="http://3835642c2693476aa717-d4b78efce91b9730bcca725cf9bb0b37.r51.cf1.rackcdn.com/Instagram_App_Large_May2016_200.png" height = "50"> <b> <br> Instagram Enabled </b> </a>

  - dimension: is_flickr_enabled
    group_label: Outlets
    sql: ${brand} IS NOT NULL
    html: <center> <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Flickr_Faenza.svg/2000px-Flickr_Faenza.svg.png" height = "50"> <b> <br> Flickr Enabled </b> </a>

  - dimension: is_reddit_enabled
    group_label: Outlets
    sql: ${brand} IS NOT NULL
    html: <center> <img src="http://rawapk.com/wp-content/uploads/2016/04/Reddit-The-Official-App-Icon.png" height = "50"> <b> <br> Reddit Enabled </b> </a>

  - dimension: is_lexisnexis_enabled
    group_label: Outlets
    sql: ${brand} IS NOT NULL
    html: <center> <img src="http://www2.youseemore.com/culpeper/uploads/lexisnexisicon.png" height = "50"> <b> <br> LexisNexis Enabled </b> </a>


    
  - dimension: category
    type: string
    sql: ${TABLE}.category

  - dimension: department
    type: string
    sql: ${TABLE}.department

  - dimension: item_name
    type: string
    sql: ${TABLE}.item_name

  - dimension: rank
    type: number
    sql: ${TABLE}.rank

  - dimension: retail_price
    type: number
    sql: ${TABLE}.retail_price

  - dimension: sku
    type: string
    sql: ${TABLE}.sku

######## Measures ######## 

  - measure: count
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  
  - measure: number_of_brands
    type: count_distinct 
    sql: ${brand}
    drill_fields: [id, brand]


