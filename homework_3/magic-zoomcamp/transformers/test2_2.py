import re
import pandas as pd
from datetime import datetime

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):

    print(data.columns)
    data.columns = (data.columns
                        .str.replace('(?<=[a-z])(?=[A-Z])', '_', regex=True)
                        .str.lower()
        )
    #print(data.columns)

    #print("Preprocessing - rows with zero passengers:", data['passenger_count']
    #                                                    .isin([0])
    #                                                    .sum()
    #    )
    #print("Preprocessing - rows with zero passengers:", data['trip_distance']
    #                                                    .isin([0])
    #                                                    .sum()
    #    )
    #
    #df = data[data['passenger_count'] > 0]
    data.head()

    cleaned_df = data
    print(cleaned_df)
    #clean[["lpep_pickup_datetime", "lpep_dropoff_datetime"]] = data[["lpep_pickup_datetime", "lpep_dropoff_datetime"]].apply(pd.to_datetime())
    #cleaned_df = datetime.fromtimestamp(data['lpep_pickup_datetime'])
    #cleaned_df = datetime.fromtimestamp(data['lpep_dropoff_datetime'])
    return cleaned_df

@test
def test_output(output,  *args):
    #assert output['passenger_count'].isin([0]).sum() == 0, 'There are rides with 0 passengers.'
    #assert output['trip_distance'].isin([0]).sum() == 0, 'There are rides with 0 distance.'
    assert output['vendor_id'] is not None, 'The output is undefined'