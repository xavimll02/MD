import pandas as pd
from pandas.api.types import is_numeric_dtype

df = pd.read_csv("dataset_preprocessed.csv", sep=',')
nan_value = float("NaN")

df_corr = df.corr(method='pearson')

for column in df_corr:
    if (is_numeric_dtype(df_corr[column])):
        df_corr.loc[df_corr[column] < 0.80, column] = 0

for column in df_corr:
    if (is_numeric_dtype(df_corr[column]) and df_corr[column].sum() <= 1.0):
        df_corr.drop([column], axis=1, inplace=True)

df_corr = df_corr.transpose()

for column in df_corr:
    if (is_numeric_dtype(df_corr[column]) and df_corr[column].sum() <= 1.0):
        df_corr.drop([column], axis=1, inplace=True)

df_corr.to_csv('df_corr.csv')
