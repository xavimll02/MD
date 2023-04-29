import pandas as pd
import numpy as np                    
import matplotlib.pyplot as plt       
import sklearn                        
import sklearn.model_selection as cv  
from sklearn import tree
from sklearn.utils import shuffle
from statsmodels.stats.proportion import proportion_confint
from scipy.stats import binomtest
from sklearn.model_selection import GridSearchCV



data = pd.read_csv("/home/mario/mario/uni/md/dataset_preprocessed.csv")
data.head()
data.drop_duplicates()

### Show target variable balance
import seaborn as sns

target_variable_balance = data['hospital_death'].value_counts().reset_index()
sns.barplot(x = "index", y = "hospital_death", data=target_variable_balance)


### Balance dataset
X=data.drop(['hospital_death'], axis=1)
y=data['hospital_death']
### Transform to numerical dataset
Xn = pd.get_dummies(X)

### Balance dataset
from imblearn.over_sampling import SMOTE    

smote = SMOTE()
Xn, y = smote.fit_resample(Xn, y)

data = pd.concat([pd.DataFrame(Xn), pd.DataFrame(y)], axis=1)




## Split into training and test
Xn, y = shuffle(Xn, y)

(X_train, X_test,  y_train, y_test) = cv.train_test_split(Xn, y, test_size=.3, random_state=10)


## Selecting parameters for the decision tree
# params = {
#     'criterion': ['entropy','gini'],
#     'min_impurity_decrease': list(np.linspace(0.001,0.5,40)),
#     'min_samples_split': list(range(2,15,2)),
#     'min_samples_leaf': list(range(1,5))
#     }

# clf = GridSearchCV(tree.DecisionTreeClassifier(), param_grid=params,cv=10,n_jobs=-1)
# clf.fit(X_train, y_train) 
# print("Best Parameters=", clf.best_params_, "Accuracy=", clf.best_score_)



clf = tree.DecisionTreeClassifier(
    criterion='entropy', 
    min_samples_split=2, 
    min_impurity_decrease=0.00, 
    min_samples_leaf=0.05,
)
pred = clf.fit(X_train, y_train).predict(X_test)
# heatmap = sns.heatmap(sklearn.metrics.confusion_matrix(y_test,pred),annot = True,  fmt = ".0f")
# heatmap_fig = heatmap.get_figure()
# heatmap_fig.savefig("heatmap.png")
print(sklearn.metrics.confusion_matrix(y_test, pred))
print()
print("Accuracy on test set:", sklearn.metrics.accuracy_score(y_test, pred))
print()
print(sklearn.metrics.classification_report(y_test, pred))
epsilon = sklearn.metrics.accuracy_score(y_test, pred)
#print("Confidence interval: ",proportion_confint(count=epsilon*X_test.shape[0], nobs=X_test.shape[0], alpha=0.05, method='binom_test'))


result = binomtest(k=int(epsilon*X_test.shape[0]), n=int(X_test.shape[0]), p=0.05)
print("Confidence interval: ", result.proportion_ci())


# ## Print tree
fig = plt.gcf()
fig.set_size_inches(200, 100)

tree.plot_tree(clf, filled=True,rounded=True,feature_names=list(Xn.columns.values))
fig.savefig('decision_tree.png')
plt.show()
# text_representation = tree.export_text(clf)
# print(text_representation)


scores = sklearn.model_selection.cross_val_score(clf, Xn, y, cv=10)
print("scores: ")
print(scores)
print(np.mean(scores))
