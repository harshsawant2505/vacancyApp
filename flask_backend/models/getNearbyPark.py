import pandas as pd



# Load the Excel file
try:

    df = pd.read_excel("models/city_excell.xlsx")
except FileNotFoundError:
    print("Error: 'city_excell.xlsx' file not found. Please check the file path.")
    df = None  # Set df to None if the file is not found to avoid further errors.

# Function to get data for a specific city from the DataFrame
def get_city_data(city):
    if df is None:
        return "Error: Data not available."

    # Ensure the column exists in the DataFrame
    if 'city' not in df.columns:
        return "Error: 'city' column not found in the data."

    # Handle missing values in the 'city' column
    if df['city'].isnull().any():
        print("Warning: Some rows in the 'city' column contain missing values.")

    # Search for the city, ignoring case
    city_data = df[df['city'].str.lower() == city.lower()]
    

 
    json_data = city_data.to_json(orient='records')
    return json_data

# Example usage

