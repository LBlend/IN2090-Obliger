import psycopg2

# MERK: Må kjøres med Python 3!

# Login details for database user
dbname = "leanderf" #Set in your UiO-username
user = "leanderf_priv" # Set in your priv-user (UiO-username + _priv)

# Fjernet av åpenbare grunner.
pwd = "" # Set inn the password for the _priv-user you got in a mail


# Gather all connection info into one string
connection = \
    "host='dbpg-ifi-kurs01.uio.no' " + \
    "dbname='" + dbname + "' " + \
    "user='" + user + "' " + \
    "port='5432' " + \
    "password='" + pwd + "'"

def administrator():
    conn = psycopg2.connect(connection)
    
    ch = 0
    while (ch != 3):
        print("-- ADMINISTRATOR --")
        print("Please choose an option:\n 1. Create bills\n 2. Insert new product\n 3. Exit")
        ch = get_int_from_user("Option: ", True)

        if (ch == 1):
            make_bills(conn)
        elif (ch == 2):
            insert_product(conn)
    
def make_bills(conn):
    with conn.cursor() as cursor:

        # Select statement without aggregation
        # cursor.execute(
        #     """
        #     SELECT orders.pid, ws.orders.uid, payed, ws.users.name, address, price*num AS total 
        #     FROM ws.orders 
        #     JOIN ws.users ON ws.orders.uid=users.uid 
        #     JOIN ws.products ON ws.orders.pid=products.pid 
        #     WHERE payed=0 AND price > 0;
        #     """
        # )
        cursor.execute(
            """
            SELECT uid, name, address, SUM(total) AS total 
            FROM (
                SELECT orders.uid, orders.pid, payed, ws.users.name, address, price*num AS total 
                FROM ws.orders 
                JOIN ws.users ON ws.orders.uid=users.uid 
                JOIN ws.products ON ws.orders.pid=products.pid 
                WHERE payed=0 AND price > 0
            ) AS orders 
            GROUP BY uid, name, address;
            """
        )
        result = cursor.fetchall()
    
    print("-- BILLS --\n")
    for order in result:
        _, name, address, total = order
        print(f"---Bill---\nName: {name}\nAddress: {address}\nTotal due: {total}\n\n")

def insert_product(conn):
    product_name = take_input("Product name: ")
    price = take_number_input("Price: ")
    category = take_input("Category: ")
    description = take_input("Description: ")

    info = (product_name, price, category, description)

    with conn.cursor() as cursor:
        # Does not take whether the input category is valid or not into account
        cursor.execute("INSERT INTO ws.products (name, price, cid, description) VALUES (%s, %s, (SELECT cid FROM ws.categories WHERE name = %s), %s)", info)
        conn.commit()
        

def take_input(input_msg: str) -> str:
    while True:
        user_input = input(input_msg)
        if not user_input:
            print("You need to enter something")
            continue
        break
    return user_input

def take_number_input(input_msg: str) -> float:
    while True:
        user_input = take_input(input_msg)
        try:
            return float(user_input)
        except ValueError:
            print("Please provide a number.")

def get_int_from_user(msg, needed):
    # Utility method that gets an int from the user with the first argument as message
    # Second argument is boolean, and if false allows user to not give input, and will then
    # return None
    while True:
        numStr = input(msg)
        if (numStr == "" and not needed):
            return None;
        try:
            return int(numStr)
        except:
            print("Please provide an integer or leave blank.");


if __name__ == "__main__":
    administrator()
