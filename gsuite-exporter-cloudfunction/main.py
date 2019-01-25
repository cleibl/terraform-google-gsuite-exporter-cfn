import os
from gsuite_exporter.cli import sync_all

def run (data, context):
    sync_all(
            admin_user=os.environ['GSUITE_ADMIN_USER'],
            api='reports_v1',
            applications=['login', 'admin', 'drive', 'mobile', 'token'],
            project_id=os.environ['PROJECT_ID'],
            exporter_cls='stackdriver_exporter.StackdriverExporter'
        )