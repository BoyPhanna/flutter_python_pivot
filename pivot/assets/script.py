import sys
import pandas as pd
import json
import re



def convert_to_list(input_string):
    # Use regex to find words inside the brackets and add quotes around them
    quoted_string = re.sub(r'(\w+)', r'"\1"', input_string)
    
    # Now the string should look like valid JSON, e.g., '["region", "products"]'
    try:
        # Parse it as a JSON list
        return json.loads(quoted_string)
    except json.JSONDecodeError:
        print("Error: The input string is not in a valid list format")
        return []


jsonk = str(sys.argv[1])  # First argument
index_str=str(sys.argv[2])
column_str=str(sys.argv[3])
value=str(sys.argv[4])
print(column_str)

column=convert_to_list(column_str)
index=convert_to_list(index_str)
cleaned_json_string = jsonk.strip()
df=pd.read_json(cleaned_json_string)
df.pivot_table(index=index,columns=column,values=value,aggfunc='sum',margins=True,margins_name="Total").to_excel("output.xlsx"),
print("Success")
