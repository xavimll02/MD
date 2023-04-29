import pandas as pd
from pandas.api.types import is_numeric_dtype

df = pd.read_csv("dataset.csv", sep=',')
print(df.shape[0])
nan_value = float("NaN")

# delete empty columns
df.replace("", nan_value, inplace=True)
df.dropna(how='all', axis=1, inplace=True)
df.drop(['encounter_id', 'patient_id'], axis=1, inplace=True)

# delete columns with few occurences
for column in df:
    if (is_numeric_dtype(df[column]) and df[column].sum() < 100):
        df.drop([column], axis=1, inplace=True)


df.to_csv('dataset_preprocessed.csv')
df_des = df.describe(include='all')
df_des.transpose().to_csv('df_preprocessed_des.csv')
