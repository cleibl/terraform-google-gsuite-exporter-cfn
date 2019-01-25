## Pre-req
1. The following APIs need to be enabled
    1. App-Engine API
    2. Pub/Sub API
    3. Cloudfunctions
    4. 

2. We had to update the python in /gsuite-exporter/exporter/stackdriver_exporter.py to work with Python 3.7.  We wrapped the list() function around current code


```python
return list(map(lambda i: self.__convert(i), records))
```


3.  We had to use local exec and the gcloud beta commands due to limited terraform support

4. Create Service Account with Domain Wide Delegation and authorize it within the Gsuite Admin Console

