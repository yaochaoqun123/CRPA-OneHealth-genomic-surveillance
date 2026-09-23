library(ggplot2)
library(reshape2)
library(cowplot)

theme_square_heatmap <- function() {
  list(
    theme_minimal(),
    theme(
      panel.grid = element_blank(),
      panel.border = element_blank(),
      axis.text.x = element_text(angle = 60, vjust = 1, hjust = 1, family = "Arial", color = "black", size = 12),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      legend.position = "none",
      plot.margin = margin(t = 5, r = 0, b = 5, l = 0)
    ),
    coord_fixed(ratio = 1),
    scale_x_discrete(expand = c(0, 0)),
    scale_y_discrete(expand = c(0, 0), drop = FALSE)
  )
}

df1 <- read.table("12data_sector.txt", header = TRUE, sep = "\t")
df1_long <- melt(df1, id.vars = "plasmid_id", variable.name = "Source", value.name = "Presence")
master_levels <- unique(df1_long$plasmid_id)
df1_long$plasmid_id <- factor(df1_long$plasmid_id, levels = master_levels)
n_col_p1 <- length(unique(df1_long$Source))

p1 <- ggplot(df1_long, aes(x = Source, y = plasmid_id)) +
  geom_tile(data = subset(df1_long, Presence == 0),
            fill = "white", color = "#8EB9D9", size = 0.6, width = 0.8, height = 0.8) +
  geom_tile(data = subset(df1_long, Presence == 1),
            fill = "#8EB9D9", color = "#8EB9D9", width = 0.8, height = 0.8) +
  theme_square_heatmap() +
  theme(
    axis.text.y = element_text(family = "Arial", color = "black", size = 12, margin = margin(r = 10)),
    plot.margin = margin(t = 5, r = 0, b = 5, l = 5)
  ) +
  labs(x = NULL, y = "Plasmid ID")
p1

df2 <- read.table("13data_habitat.txt", header = TRUE, sep = "\t")
df2_long <- melt(df2, id.vars = "plasmid_id", variable.name = "Source", value.name = "Presence")
df2_long$plasmid_id <- factor(df2_long$plasmid_id, levels = master_levels)
n_col_p2 <- length(unique(df2_long$Source))

p2 <- ggplot(df2_long, aes(x = Source, y = plasmid_id)) +
  geom_tile(data = subset(df2_long, Presence == 0),
            fill = "white", color = "#FFBD85", size = 0.6, width = 0.8, height = 0.8) +
  geom_tile(data = subset(df2_long, Presence == 1),
            fill = "#FFBD85", color = "#FFBD85", width = 0.8, height = 0.8) +
  theme_square_heatmap() +
  labs(x = NULL, y = NULL)
p2

df3 <- read.table("14data_province.txt", header = TRUE, sep = "\t")
df3_long <- melt(df3, id.vars = "plasmid_id", variable.name = "Source", value.name = "Presence")
df3_long$plasmid_id <- factor(df3_long$plasmid_id, levels = master_levels)
n_col_p3 <- length(unique(df3_long$Source))
color_p3 <- "#90CD97"

p3 <- ggplot(df3_long, aes(x = Source, y = plasmid_id)) +
  geom_tile(data = subset(df3_long, Presence == 0),
            fill = "white", color = color_p3, size = 0.6, width = 0.8, height = 0.8) +
  geom_tile(data = subset(df3_long, Presence == 1),
            fill = color_p3, color = color_p3, width = 0.8, height = 0.8) +
  theme_square_heatmap() +
  labs(x = NULL, y = NULL)
p3

df4 <- read.table("17data_mobility.txt", header = TRUE, sep = "\t")
df4_long <- melt(df4, id.vars = "plasmid_id", variable.name = "Source", value.name = "Presence")
df4_long$plasmid_id <- factor(df4_long$plasmid_id, levels = master_levels)
n_col_p4 <- length(unique(df4_long$Source))
color_p4 <- "#F897B0"

p4 <- ggplot(df4_long, aes(x = Source, y = plasmid_id)) +
  geom_tile(data = subset(df4_long, Presence == 0),
            fill = "white", color = color_p4, size = 0.6, width = 0.8, height = 0.8) +
  geom_tile(data = subset(df4_long, Presence == 1),
            fill = color_p4, color = color_p4, width = 0.8, height = 0.8) +
  theme_square_heatmap() +
  labs(x = NULL, y = NULL)
p4

df5 <- read.table("18data_cicularity.txt", header = TRUE, sep = "\t")
df5_long <- melt(df5, id.vars = "plasmid_id", variable.name = "Source", value.name = "Presence")
df5_long$plasmid_id <- factor(df5_long$plasmid_id, levels = master_levels)
n_col_p5 <- length(unique(df5_long$Source))
color_p5 <- "#B39AC4"

p5 <- ggplot(df5_long, aes(x = Source, y = plasmid_id)) +
  geom_tile(data = subset(df5_long, Presence == 0),
            fill = "white", color = color_p5, size = 0.6, width = 0.8, height = 0.8) +
  geom_tile(data = subset(df5_long, Presence == 1),
            fill = color_p5, color = color_p5, width = 0.8, height = 0.8) +
  theme_square_heatmap() +
  labs(x = NULL, y = NULL)
p5

df5_5 <- read.table("19data_KPC.txt", header = TRUE, sep = "\t")
df5_5_long <- melt(df5_5, id.vars = "plasmid_id", variable.name = "Source", value.name = "Presence")
df5_5_long$plasmid_id <- factor(df5_5_long$plasmid_id, levels = master_levels)
n_col_p5_5 <- length(unique(df5_5_long$Source))
color_p5_5 <- "#FFE200"

p5_5 <- ggplot(df5_5_long, aes(x = Source, y = plasmid_id)) +
  geom_tile(data = subset(df5_5_long, Presence == 0),
            fill = "white", color = color_p5_5, size = 0.6, width = 0.8, height = 0.8) +
  geom_tile(data = subset(df5_5_long, Presence == 1),
            fill = color_p5_5, color = color_p5_5, width = 0.8, height = 0.8) +
  theme_square_heatmap() +
  labs(x = NULL, y = NULL)
p5_5

df5_6 <- read.table("20data_rep.txt", header = TRUE, sep = "\t")
df5_6_long <- melt(df5_6, id.vars = "plasmid_id", variable.name = "Source", value.name = "Presence")
df5_6_long$plasmid_id <- factor(df5_6_long$plasmid_id, levels = master_levels)
n_col_p5_6 <- length(unique(df5_6_long$Source))
color_p5_6 <- "#FD9C76"

p5_6 <- ggplot(df5_6_long, aes(x = Source, y = plasmid_id)) +
  geom_tile(data = subset(df5_6_long, Presence == 0),
            fill = "white", color = color_p5_6, size = 0.6, width = 0.8, height = 0.8) +
  geom_tile(data = subset(df5_6_long, Presence == 1),
            fill = color_p5_6, color = color_p5_6, width = 0.8, height = 0.8) +
  theme_square_heatmap() +
  labs(x = NULL, y = NULL)
p5_6

df6 <- read.table("15data_length.txt", header = TRUE, sep = "\t")
df6$length <- as.numeric(as.character(df6$length))
df6$plasmid_id <- factor(df6$plasmid_id, levels = master_levels)

p6 <- ggplot(df6, aes(x = length, y = plasmid_id)) +
  geom_point(shape = 21, fill = "#945EC8", color = "#945EC8", size = 3) +
  theme_minimal() +
  labs(x = "Plasmid length", y = NULL) +
  theme(
    panel.grid = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, size = 1),
    axis.text.x = element_text(angle = 60, hjust = 1, family = "Arial", color = "black", size = 10),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    plot.margin = margin(t = 5, r = 10, b = 5, l = 0)
  ) +
  scale_y_discrete(expand = c(0, 0), drop = FALSE) +
  scale_x_continuous(expand = expansion(mult = c(0.05, 0.1))) +
  coord_cartesian(clip = "off")
p6

w1 <- n_col_p1 + 2
w2 <- n_col_p2
w3 <- n_col_p3
w4 <- n_col_p4
w5 <- n_col_p5
W5_5 <- n_col_p5_5
W5_6 <- n_col_p5_6
w6 <- 4

p_final <- plot_grid(
  p1, p2, p3, p4, p5, p5_5, p5_6, p6,
  ncol = 8,
  align = "h",
  axis = "bt",
  rel_widths = c(w1, w2, w3, w4, w5, W5_5, W5_6, w6)
)

ggsave("combined_heatmap_corrected.svg", p_final, width = 14, height = 10)
