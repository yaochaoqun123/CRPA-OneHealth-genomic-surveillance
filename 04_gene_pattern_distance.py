import csv
import os

INPUT_CSV = "temporal_patterns_summary_withType_revised_China_sortedbyyear_UNIFIED.csv"
OUTPUT_EDGE_LIST = "pairwise_distances_list.csv"
OUTPUT_MATRIX = "edit_distance_matrix.csv"

def parse_gene_string(gene_str):
    return [g.strip() for g in gene_str.replace('->', ' -> ').split('->') if g.strip()]

def calculate_jaccard(list1, list2):
    set1, set2 = set(list1), set(list2)
    intersection = len(set1.intersection(set2))
    union = len(set1.union(set2))
    return intersection / union if union != 0 else 0

def calculate_edit_distance(list1, list2):
    m, n = len(list1), len(list2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(m + 1):
        dp[i][0] = i
    for j in range(n + 1):
        dp[0][j] = j

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            cost = 0 if list1[i-1] == list2[j-1] else 1
            dp[i][j] = min(
                dp[i-1][j] + 1,
                dp[i][j-1] + 1,
                dp[i-1][j-1] + cost
            )
    return dp[m][n]

def main():
    if not os.path.exists(INPUT_CSV):
        print(f"错误：找不到文件 {INPUT_CSV}")
        return

    strains = []
    print(f"正在读取 {INPUT_CSV} ...")
    with open(INPUT_CSV, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        header = next(reader)
        idx_genome = header.index("Genome_ID")
        idx_contig = header.index("Contig_ID")
        idx_pattern = header.index("Pattern")

        for row in reader:
            if not row or len(row) <= idx_pattern:
                continue
            strain_id = f"{row[idx_genome]}_{row[idx_contig]}"
            gene_list = parse_gene_string(row[idx_pattern])
            strains.append({"id": strain_id, "genes": gene_list})

    n_strains = len(strains)
    print(f"共读取到 {n_strains} 条序列。正在计算距离...")
    distance_matrix = [[0] * n_strains for _ in range(n_strains)]

    with open(OUTPUT_EDGE_LIST, 'w', encoding='utf-8', newline='') as f_out:
        writer = csv.writer(f_out)
        writer.writerow(["Strain_A", "Strain_B", "Edit_Distance", "Jaccard_Similarity"])

        for i in range(n_strains):
            for j in range(i + 1, n_strains):
                id1, genes1 = strains[i]["id"], strains[i]["genes"]
                id2, genes2 = strains[j]["id"], strains[j]["genes"]
                edit_dist = calculate_edit_distance(genes1, genes2)
                jaccard_sim = calculate_jaccard(genes1, genes2)
                writer.writerow([id1, id2, edit_dist, round(jaccard_sim, 4)])
                distance_matrix[i][j] = edit_dist
                distance_matrix[j][i] = edit_dist

    with open(OUTPUT_MATRIX, 'w', encoding='utf-8', newline='') as f_mat:
        writer = csv.writer(f_mat)
        strain_ids = [s["id"] for s in strains]
        writer.writerow([""] + strain_ids)
        for i in range(n_strains):
            writer.writerow([strain_ids[i]] + distance_matrix[i])

    print("计算完成！")
    print(f"1. 两两比对详细结果已保存至: {OUTPUT_EDGE_LIST}")
    print(f"2. 聚类树距离矩阵已保存至: {OUTPUT_MATRIX}")

if __name__ == "__main__":
    main()
