import pandas as pd

df = pd.read_csv("dataset.csv", sep=',')


df_des = df.describe(include='all').transpose()
df_des_top_freq = df_des.sort_values('freq', ascending=False).head()
df_des_top_unique = df_des.sort_values('unique', ascending=False).head()
df_des_top_std = df_des.sort_values('std', ascending=False).head()
df_des_bottom_std = df_des.sort_values('std', ascending=True).head()



print(df_des_top_freq)
print(df_des_top_unique)
print(df_des_top_std)
print(df_des_bottom_std)

