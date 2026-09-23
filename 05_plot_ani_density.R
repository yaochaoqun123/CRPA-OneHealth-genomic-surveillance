library(ggplot2)

workdir <- "."

human_file <- file.path(workdir, "02_human_vs_human_ani.tsv")
nonhuman_file <- file.path(workdir, "02_nonhuman_vs_nonhuman_ani.tsv")
out_human <- file.path(workdir, "02_human_vs_human_ani_density.svg")
out_nonhuman <- file.path(workdir, "02_nonhuman_vs_nonhuman_ani_density.svg")

human_ani <- read.table(human_file, header = TRUE, sep = "\t",
                        stringsAsFactors = FALSE)$ANI
nonhuman_ani <- read.table(nonhuman_file, header = TRUE, sep = "\t",
                           stringsAsFactors = FALSE)$ANI

plot_density <- function(ani_vec, title_str, out_path) {
  df <- data.frame(ANI = ani_vec)

  p <- ggplot(df, aes(x = ANI)) +
    geom_density(colour = "black", fill = "#90EE90", size = 0.5) +
    labs(title = title_str, x = "ANI (%)", y = "Density") +
    theme_bw(base_family = "Arial") +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
      axis.title = element_text(size = 12),
      axis.text = element_text(size = 10),
      panel.grid.major = element_line(colour = "grey90"),
      panel.grid.minor = element_blank()
    )

  ggsave(filename = out_path, plot = p,
         width = 105, height = 148.5, units = "mm",
         device = "svg")
}

plot_density(human_ani, "Human vs Human ANI Density", out_human)
plot_density(nonhuman_ani, "Non-human vs Non-human ANI Density", out_nonhuman)

cat("Done.\n",
    "  ->", out_human, "\n",
    "  ->", out_nonhuman, "\n")
