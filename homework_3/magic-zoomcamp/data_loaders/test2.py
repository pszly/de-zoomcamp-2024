import io
import pandas as pd
import requests
from pandas import DataFrame

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):

    year = 2022
    month = ['01']
    source_url = 'https://d37ci6vzurychx.cloudfront.net/trip-data/'
    
    taxi_dtypes = {
                    'VendorID': pd.Int64Dtype(),
                    'passenger_count': pd.Int64Dtype(),
                    'trip_distance': float,
                    'RatecodeID':pd.Int64Dtype(),
                    'store_and_fwd_flag':str,
                    'PULocationID':pd.Int64Dtype(),
                    'DOLocationID':pd.Int64Dtype(),
                    'payment_type': pd.Int64Dtype(),
                    'fare_amount': float,
                    'extra':float,
                    'mta_tax':float,
                    'tip_amount':float,
                    'tolls_amount':float,
                    'improvement_surcharge':float,
                    'total_amount':float,
                    'congestion_surcharge':float
                }
    dataset = []
    for m in month:

        filename = f'green_tripdata_{year}-{m}.parquet'
        url = f'{source_url}{filename}'
        print(f'Source downloaded {url}')

        #parse_dates = ['lpep_pickup_datetime', 'lpep_dropoff_datetime']

        df = pd.read_parquet(url, engine='pyarrow')
        dataset.append(df)
        
    result_dataset = pd.concat(dataset, ignore_index=True)
    return result_dataset


@test
def test_output(output, *args) -> None:
    assert output is not None, 'The output is undefined'