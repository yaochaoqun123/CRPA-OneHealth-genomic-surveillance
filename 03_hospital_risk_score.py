import pandas as pd

def calculate_hospital_risk(input_file, output_file):
    df = pd.read_csv(input_file, sep='\t')

    weights = {
        'high_risk_ratio': 10,
        'Shannon_diveristy': 10,
        'wastewater_high_risk_score': 10,
        'Spill_over_risk': 10,
        'non_cp_CRPA_ratio': 10,
        'cp_CRPA_ratio': 20,
        'VF_CRPA': 10,
        'Persistance': 20
    }

    normalized_df = pd.DataFrame()
    normalized_df['Hospital_code'] = df['Hospital_code']
    total_score = pd.Series(0.0, index=df.index)

    for col, weight in weights.items():
        if col in df.columns:
            col_min = df[col].min()
            col_max = df[col].max()

            if col_max == col_min:
                normalized_col = pd.Series(0.0, index=df.index)
            else:
                normalized_col = (df[col] - col_min) / (col_max - col_min) * 10

            norm_col_name = f"{col}_norm"
            normalized_df[norm_col_name] = normalized_col.round(2)
            total_score += (normalized_col / 10) * weight
        else:
            print(f"警告: 列名 '{col}' 不在数据文件中，请检查表头拼写。")

    normalized_df['Total_Score_100'] = total_score.round(2)
    normalized_df.to_csv(output_file, index=False, encoding='utf-8-sig')
    print(f"处理完成！结果已保存至: {output_file}")

if __name__ == "__main__":
    input_filename = 'data.txt'
    output_filename = 'hospital_risk_scores.csv'
    calculate_hospital_risk(input_filename, output_filename)
