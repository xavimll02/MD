import pandas as pd
import numpy as np
from scipy.optimize import curve_fit
pd.options.mode.chained_assignment = None  # default='warn'

df = pd.read_csv("dataset_preprocessed.csv", sep=',')

nan_value = float("NaN")
df.replace("", nan_value, inplace=True)

df_nona = df.dropna(axis=0)


def fit_func(x, a, b):
    return a*x+b


def bmi(a, b):
    return a / ((b/100)**2)


params = curve_fit(fit_func, df_nona.height, df_nona.weight)
print('a=', params[0][0], 'b=', params[0][1])
idx = df.weight.isnull()
df.weight[idx] = fit_func(df['height'][idx], params[0][0], params[0][1])
idx = df.weight.isnull()
df.weight[idx] = df.weight.mean()

params = curve_fit(fit_func, df_nona.weight, df_nona.height)
print('a=', params[0][0], 'b=', params[0][1])
idx = df.height.isnull()
df.height[idx] = fit_func(df['weight'][idx], params[0][0], params[0][1])
idx = df.height.isnull()
df.height[idx] = df.height.mean()

idx = df.bmi.isnull()
df.bmi[idx] = bmi(df['weight'][idx], df['height'])


# Transform 1/0 to True/False
df = df.astype({'elective_surgery': bool,
                'apache_post_operative': bool,
                'gcs_unable_apache': bool,
                'arf_apache': bool,
                'intubated_apache': bool,
                'ventilated_apache': bool,
                'cirrhosis': bool,
                'diabetes_mellitus': bool,
                'hepatic_failure': bool,
                'immunosuppression': bool,
                'solid_tumor_with_metastasis': bool,
                'leukemia': bool,
                'lymphoma': bool,
                'hospital_death': bool})


df.fillna(df.mean(), inplace=True)

df.to_csv('dataset_preprocessed.csv')
df_des = df.describe(include='all')
df_des.transpose().to_csv('df_preprocessed_des.csv')
