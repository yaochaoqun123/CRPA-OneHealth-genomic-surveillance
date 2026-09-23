import pandas as pd
import networkx as nx

SNP_MATRIX_FILE = 'coreSNP.distance.csv'
METADATA_FILE = 'data.csv'
OUTPUT_FILE = 'data_with_clusters_detailed.csv'
SNP_THRESHOLD = 10

def main():
    print(f"--- 开始分析 (阈值: {SNP_THRESHOLD} SNPs) ---")

    try:
        snp_df = pd.read_csv(SNP_MATRIX_FILE, index_col=0)
        meta_df = pd.read_csv(METADATA_FILE, sep='\t')
        meta_df['Strain_ID'] = meta_df['Strain_ID'].astype(str)
        snp_df.index = snp_df.index.astype(str)
        snp_df.columns = snp_df.columns.astype(str)
        print("数据读取成功。")
    except Exception as e:
        print(f"读取失败: {e}")
        return

    print("正在计算聚类...")
    stacked_matrix = snp_df.stack()
    edges = stacked_matrix[stacked_matrix <= SNP_THRESHOLD].reset_index()
    edges.columns = ['Source', 'Target', 'Distance']
    edges = edges[edges['Source'] != edges['Target']]

    G = nx.from_pandas_edgelist(edges, 'Source', 'Target')
    G.add_nodes_from(set(snp_df.index))
    clusters = list(nx.connected_components(G))

    cluster_results = {}
    cluster_count = 0

    print("正在分析每个 Cluster 的内部结构...")
    for cluster_nodes in clusters:
        nodes_list = list(cluster_nodes)

        if len(nodes_list) > 1:
            cluster_count += 1
            cluster_id = f"Cluster_{cluster_count}"
            sub_matrix = snp_df.loc[nodes_list, nodes_list]
            avg_distances = sub_matrix.mean(axis=1)
            ref_strain = avg_distances.idxmin()

            for strain in nodes_list:
                dist_to_ref = snp_df.loc[strain, ref_strain]
                cluster_results[strain] = {
                    'Cluster_ID': cluster_id,
                    'Reference_Strain': ref_strain,
                    'SNP_Distance_to_Ref': dist_to_ref
                }
        else:
            strain = nodes_list[0]
            cluster_results[strain] = {
                'Cluster_ID': 'Singleton',
                'Reference_Strain': strain,
                'SNP_Distance_to_Ref': 0
            }

    print("正在合并结果...")
    results_df = pd.DataFrame.from_dict(cluster_results, orient='index')
    final_df = meta_df.merge(results_df, left_on='Strain_ID', right_index=True, how='left')
    final_df['Cluster_ID'] = final_df['Cluster_ID'].fillna('Not_in_SNP_Matrix')

    cols = list(final_df.columns)
    new_cols = ['Cluster_ID', 'Reference_Strain', 'SNP_Distance_to_Ref']
    for col in new_cols:
        if col in cols:
            cols.remove(col)

    final_cols = ['Strain_ID'] + new_cols + [c for c in cols if c != 'Strain_ID']
    final_df = final_df[final_cols]
    final_df.to_csv(OUTPUT_FILE, index=False)

    print("--- 完成 ---")
    print(f"共发现 {cluster_count} 个传播簇。")
    print(f"结果已保存至: {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
