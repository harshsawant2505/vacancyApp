import pandas as pd

df = pd.read_excel('/City_excell.xlsx')

def get_city_data(city):
    return df[df['city'].str.lower() == city.lower()]
