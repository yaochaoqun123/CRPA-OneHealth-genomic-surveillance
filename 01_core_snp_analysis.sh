#!/usr/bin/env bash
#SBATCH -J snippy
#SBATCH --partition compute
#SBATCH --nodelist=node03
#SBATCH --ntasks-per-node=16
#SBATCH -a 1-1
#SBATCH --output=coreSNP.%j.out

workdir="."
reference="GCF_000006765.1_ASM676v1_genomic.fna"

# ==================== Step 1：单样本 SNP calling ====================

info=${info:-${table:-${list?'Require task list'}}}
prefix=$(awk -v i="$SLURM_ARRAY_TASK_ID" 'FNR==i{print $1}' "$info")
r1=$(awk -v i="$SLURM_ARRAY_TASK_ID" 'FNR==i{print $2}' "$info")
r2=$(awk -v i="$SLURM_ARRAY_TASK_ID" 'FNR==i{print $3}' "$info")

cd "$workdir"
cp "$r1" "./${prefix}.clean.r1.fq.gz"
cp "$r2" "./${prefix}.clean.r2.fq.gz"

snippy \
    --outdir "$prefix" \
    --R1 "./${prefix}.clean.r1.fq.gz" \
    --R2 "./${prefix}.clean.r2.fq.gz" \
    --ref "$reference" \
    --cpus 16

rm "./${prefix}.clean.r1.fq.gz" "./${prefix}.clean.r2.fq.gz"
echo "$prefix step1 done!"

# ==================== Step 2：核心 SNP 与去重组分析 ====================

core_info="info.rmnovel.txt"

mkdir -p rmNovelST
cd rmNovelST

SAMPLES=$(cut -f1 "$core_info" | paste -sd " " -)
snippy-core --ref "$reference" $SAMPLES
snippy-clean_full_aln core.full.aln > clean.full.aln
run_gubbins.py --threads 16 -v -t fasttree -p gubbins clean.full.aln
snp-sites -c gubbins.filtered_polymorphic_sites.fasta > coreSNP.rmnovelST.aln
