import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("dataset.csv", sep=',')
smpl = df.sample(1000)

#pd.plotting.scatter_matrix(smpl[['weight', 'd1_glucose_max', 'heart_rate_apache', 'd1_sysbp_max', 'h1_diasbp_max']])
pd.plotting.scatter_matrix(smpl[['d1_heartrate_max','d1_heartrate_min', 'heart_rate_apache']])


plt.show()