import os
from subprocess import call

# Define a post-save hook to auto-commit and push notebooks
def post_save_hook(model, os_path, contents_manager):
    # Only auto-commit Jupyter notebooks
    if model['type'] != 'notebook':
        return

    # Git commands for committing and pushing changes
    call(['git', 'add', os_path])
    call(['git', 'commit', '-m', f'Auto-commit: {os_path}'])
    call(['git', 'push'])

# Register the post-save hook in Jupyter
c = get_config()
c.FileContentsManager.post_save_hook = post_save_hook

# Allow access from all IPs (use cautiously for public deployments)
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.allow_remote_access = True
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888