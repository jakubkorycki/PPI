import pandas as pd

# Load the CSV file without headers
file_path = 'raw_gsh.csv'
df = pd.read_csv(file_path, header=None)

# Drop the first row
df = df.iloc[1:].reset_index(drop=True)

# Set the column headers to the new first row
df.columns = df.iloc[0]
df = df[1:]

# Clean the number formatting by converting all columns to numeric
df = df.apply(pd.to_numeric, errors='coerce')

# Save the cleaned dataframe as a CSV file
output_path = 'cleaned_gsh.csv'
df.to_csv(output_path, index=False)
