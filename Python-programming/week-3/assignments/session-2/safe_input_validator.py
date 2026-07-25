def get_int(prompt, min_val = None, max_val = None):
    
    while True:
        
        try:
            val = int(input(prompt))
            if min_val and val < min_val:
                raise ValueError(f'Min: {min_val}')
            
            if max_val and val > max_val:
                raise ValueError(f'Max: {max_val}')
            return val
        
        except ValueError as e:
            print(f'Invalid: {e}')
            
get_int( 'enter value: ',30,90)
          