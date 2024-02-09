from sqlalchemy import create_engine
from time import time
import pandas as pd
import argparse
import os



def main(params):


    user = params.user 
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table = params.table
    url = params.url

    target_file = 'dataset.csv'

    #  download the source
    if str(url).endswith('.csv'):

        os.system(f'wget {url} -O {target_file}')
        df = pd.read_csv(target_file, engine='pyarrow')

    else:

        os.system(f'wget {url} -O {target_file}')
        df = pd.read_csv(target_file, engine='pyarrow', compression='gzip')
        df.to_csv(target_file)


    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    print(pd.io.sql.get_schema(df, name=table, con=engine))

    df_iter = pd.read_csv(target_file, iterator=True, chunksize=100000)
    df = next(df_iter)

    df.head(n=0).to_sql(name=table, con=engine, if_exists='replace')

    while True: 
        t_start = time()
        
        df.to_sql(name=table, con=engine, if_exists='append')
        df = next(df_iter)
        t_end = time()

        print('inserted another chunk, took %.3f second' % (t_end - t_start))


if __name__== '__main__':

    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres.')

    # user
    # password
    # host
    # port
    # database name
    # table name
    # url of the csv

    parser.add_argument('--user', help='user name for postgres')
    parser.add_argument('--password', help='password for postgres')
    parser.add_argument('--host', help='host for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='DB name for postgres')
    parser.add_argument('--table', help='target table in postgres')
    parser.add_argument('--url', help='url of the source csv file') 

    parser.add_argument('--sum', dest='accumulate', action='store_const',
                        const=sum, default=max,
                        help='sum the integers (default: find the max)')

    args = parser.parse_args()

    main(args)