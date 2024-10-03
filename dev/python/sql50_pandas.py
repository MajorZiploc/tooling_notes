import pandas as pd

# https://leetcode.com/problems/recyclable-and-low-fat-products/?envType=study-plan-v2&envId=top-sql-50
def find_products(products: pd.DataFrame) -> pd.DataFrame:
   return products.loc[(products['low_fats'] == 'Y') & (products['recyclable'] == 'Y')][['product_id']].drop_duplicates(subset=['product_id'])

# EQUALS:

# select
#    p.product_id
# from Products as p
# where
#    p.low_fats = 'Y'
#    and p.recyclable = 'Y'
# ;

# https://leetcode.com/problems/find-customer-referee/submissions/?envType=study-plan-v2&envId=top-sql-50

def find_customer_referee(customer: pd.DataFrame) -> pd.DataFrame:
    return customer.loc[(customer['referee_id'].isna()) | ~(customer['referee_id'] == 2)][['name']]

# select
#    c.name
# from Customer as c
# where
#    c.referee_id is null
#    or c.referee_id <> 2
# ;

# https://leetcode.com/problems/big-countries/submissions/?envType=study-plan-v2&envId=top-sql-50

def big_countries(world: pd.DataFrame) -> pd.DataFrame:
    return world.loc[(world['area'] > 3000000) | (world['population'] > 25000000)][['name', 'population', 'area']]

# select
#    w.name
#    , w.population
#    , w.area
# from World as w
# where
#    w.area >= 3000000
#    or w.population >= 25000000
# ;

# https://leetcode.com/problems/article-views-i/?envType=study-plan-v2&envId=top-sql-50

def article_views(views: pd.DataFrame) -> pd.DataFrame:
    vs = views.loc[(views['author_id'] == views['viewer_id'])]
    vs['id'] = vs['viewer_id']
    return vs[['id']].drop_duplicates(subset=['id']).sort_values(by=['id'])

# select distinct
#    v.viewer_id as id
# from Views as v
# where
#    v.author_id = v.viewer_id
# order by v.viewer_id
# ;

# https://leetcode.com/problems/invalid-tweets/submissions/?envType=study-plan-v2&envId=top-sql-50

def invalid_tweets(tweets: pd.DataFrame) -> pd.DataFrame:
   return tweets.loc[tweets.content.str.len() > 15][['tweet_id']]

# select
#     t.tweet_id
# from Tweets as t
# where
#     length(t.content) > 15
# ;

# https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier/?envType=study-plan-v2&envId=top-sql-50

def replace_employee_id(employees: pd.DataFrame, employee_uni: pd.DataFrame) -> pd.DataFrame:
    return pd.merge(employees, employee_uni, on='id', how='left')[['unique_id', 'name']]

# select
#     eu.unique_id
#     , e.name
# from Employees as e
# left join EmployeeUNI as eu using(id)
# ;


# https://leetcode.com/problems/product-sales-analysis-i/submissions/?envType=study-plan-v2&envId=top-sql-50

def sales_analysis(sales: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    return pd.merge(sales, product, on='product_id', how='inner')[['product_name', 'year', 'price']]

# select
#     p.product_name
#     , s.year
#     , s.price
# from Sales as s
# inner join Product as p on p.product_id = s.product_id
# ;

# https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/submissions/?envType=study-plan-v2&envId=top-sql-50

def find_customers(visits: pd.DataFrame, transactions: pd.DataFrame) -> pd.DataFrame:
    merged_data = pd.merge(visits, transactions, on='visit_id', how='left')
    filtered_data: pd.DataFrame = merged_data[merged_data['transaction_id'].isna()]
    return filtered_data.groupby('customer_id').agg(count_no_trans=('visit_id', 'count')).reset_index()

# select
#     v.customer_id
#     , count(v.visit_id) as count_no_trans
# from Visits as v
# left join Transactions as t on t.visit_id = v.visit_id
# where
#     t.transaction_id is null
# group by v.customer_id
# ;
