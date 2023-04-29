import matplotlib.pyplot as plt
import pandas as pd

df = pd.read_csv("dataset.csv", sep=',')

# df.boxplot(column=['weight'],meanline=False,showmeans=True)
# df.hist(column=['age', 'bmi', 'height','weight'],  bins=10, figsize=[7,7])
# df.gender.value_counts().plot(kind='bar')
df.hospital_death.value_counts().plot(kind='bar')

plt.show()