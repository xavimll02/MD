import pandas as pd
import numpy as np
from pandas.api.types import is_numeric_dtype
from pandas.api.types import is_categorical_dtype

df = pd.read_csv("dataset_preprocessed.csv", sep=',')

for column in df:
    if (is_numeric_dtype(df[column])):
        df.drop(df[(df[column] > df[column].mean()+2 *
                df[column].std()) & (df['hospital_death'] != 1.0)].index, inplace=True)

df.to_csv('dataset_preprocessed.csv')
df_des = df.describe(include='all')
df_des.transpose().to_csv('df_preprocessed_des.csv')
