import csv
import os

def library_management():
    # data = [ 
    # { 'Title':'Python','Author':'Felix','ISBN':40006,'Year':2001,'Copies':100 },
    # { 'Title':'Java','Author':'James','ISBN':4306,'Year':2011,'Copies':120 },
    # { 'Title':'Physics','Author':'Alex','ISBN':40036,'Year':2001,'Copies':140 },
    # { 'Title':'Think Big','Author':'Loren','ISBN':43346,'Year':2011,'Copies':160 }
    # ]
    # new_data=[]
    # header_names= ['Title','Author','ISBN','Year','Copies']
    
    # # adding book
    # with open('library-record.csv', 'w', newline="", encoding= 'utf-8') as f:
    #     writer= csv.DictWriter(f, fieldnames=header_names)
    #     writer.writeheader()
    #     writer.writerows(data)
    #     print("added successfully!")
     
    # #  reading records from file in a tabular form   
    # with open('library-record.csv', 'r', newline="", encoding='utf-8') as f:
    #     reader = csv.DictReader(f)
    #     header_space = '{:<12} {:<8} {:<8} {:<8} {:<12}'
    #     print(header_space.format(*reader.fieldnames))
    #     print('-' * 50)
    #     for row in reader:
    #         print(header_space.format(row['Title'], row['Author'], row['ISBN'],row['Year'], row['Copies']))
        
    
    # def search_book(author):
    #     with open('library-record.csv', 'r', newline='' , encoding='utf-8') as f:
    #         reader = csv.DictReader(f)
    #         found = False
    #         for row in reader:
    #             if author.lower() in row['Author'].lower():
    #                 print(f'Author found {row['Title']} by {row['Author']}')
    #                 found = True
    #             if not found:
    #                 print('not found!')
    # search_book('Felix')
    
    # def update_copies(book,count: int):
    #     with open('library-record.csv', 'r' , newline='', encoding='utf-8') as f:
    #         reader = csv.DictReader(f)
    #         for row in reader:
    #             if book.lower() in row['Title'].lower():
    #                 if count >= 1:
    #                     print(f'There are {int(row['Copies']) + count} remaining in store after adding {count}')
    #                 elif count < 0:
    #                     print(f'There are {int(row['Copies']) - count} remaining in store')
    #                 else:
    #                     print(f'There are {int(row['Copies'])} remaining in store')
    # update_copies('python',1)
    
    
    def delete_item(book_ISBN):
        
        remaininng_rows = []
        fieldnames = []
        
        with open('library-record.csv','r',newline='',encoding='utf-8') as f:
            reader = csv.DictReader(f)
            fieldnames = reader.fieldnames
            
        new_data = [data for data in reader if book_ISBN not in data]
        
        
                
        with open('library-record.csv', 'w', newline='', encoding='utf-8') as f:
            writer= csv.DictWriter(f,fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(new_data)
        print('record removed successfully')
            
                
            
    delete_item(4306)
    
    with open('library-record.csv', 'r', newline="", encoding='utf-8') as f:
        reader = csv.DictReader(f)
        header_space = '{:<12} {:<8} {:<8} {:<8} {:<12}'
        print(header_space.format(*reader.fieldnames))
        print('-' * 50)
        for row in reader:
            print(header_space.format(row['Title'], row['Author'], row['ISBN'],row['Year'], row['Copies']))
    
        
    
            
            
            
        
            
            
                
                
   
            
                
            
        
        
library_management()