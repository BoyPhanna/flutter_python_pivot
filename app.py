# app.py
import pandas as pd
from flask import Flask, jsonify, request

app = Flask(__name__)

# Sample data for demonstration
data = [
    {"category": "Fruits", "region": "North", "year": 2023, "cost": 7000, "sales": 1200},
    {"category": "Fruits", "region": "South", "year": 2023, "cost": 7000, "sales": 1500},
    {"category": "Vegetables", "region": "North", "year": 2022, "cost": 7000, "sales": 1100},
    {"category": "Vegetables", "region": "GTA", "year": 2023, "cost": 7000, "sales": 900},
    {"category": "Fruits", "region": "GTA", "year": 2022, "cost": 7000, "sales": 1000},
    {"category": "Vegetables", "region": "South", "year": 2023, "cost": 7000, "sales": 900},
    {"category": "Vegetables", "region": "KSK", "year": 2022, "cost": 7000, "sales": 1000},
    {"category": "Vegetables", "region": "TK", "year": 2021, "cost": 9000, "sales": 1000},
]

df = pd.DataFrame(data)

@app.route('/pivot', methods=['GET'])
def generate_pivot():
    # Replace NaN with 0
    df_pivot = pd.pivot_table(df, values='cost', index=['category'], columns=['region'], aggfunc='sum', fill_value=0, margins=True, margins_name='Total')

    # Convert the pivot table to JSON
    result = df_pivot.to_json(orient='split')
    return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True)
