import pandas as pd



# Load the Excel file
try:

    df = pd.read_excel("models/city_excell.xlsx")
except FileNotFoundError:
    print("Error: 'city_excell.xlsx' file not found. Please check the file path.")
    df = None  # Set df to None if the file is not found to avoid further errors.

# Function to get data for a specific city from the DataFrame
def get_all_city_data():
    if df is None:
        return "Error: Data not available."

    # Ensure the column exists in the DataFrame
    

    # Handle missing values in the 'city' column
    
    # Search for the city, ignoring case
    df['gps'] = df['gps'].str.strip()
    df['gps'] = df['gps'].str.replace(r'\s{2,}', ' ', regex=True)
    df['type'] = df['type'].fillna("free").replace(r'^\s*$', 'free', regex=True)
    df['2w'] = df['2w'].fillna(0).replace(r'^\s*$', 0, regex=True)
    df['4w'] = df['4w'].fillna(0).replace(r'^\s*$', 0, regex=True)
    df['city'] = df['city'].fillna("").replace(r'^\s*$', "", regex=True)
    df['place'] = df['place'].fillna("").replace(r'^\s*$', "", regex=True)
    df['gps'] = df['gps'].fillna("").replace(r'^\s*$', "", regex=True)
    fields = df.to_dict(orient='records')
    

    print(fields)

    
    
    return fields

# Example usage

