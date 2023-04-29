import pandas as pd

df = pd.read_csv("dataset.csv", sep=',')
df_des = df.describe(include='all')
df_des.transpose().to_csv('df_des.csv')