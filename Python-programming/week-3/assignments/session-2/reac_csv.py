def read_cxv_safe(filepath):
    try:
        with open(filepath, 'r') as f:
            return 