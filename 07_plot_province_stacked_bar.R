library(ggplot2)
library(dplyr)

data <- read.table("data.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)

data$Province <- factor(
  data$Province,
  levels = names(sort(table(data$Province), decreasing = TRUE))
)

totals <- data %>%
  group_by(Province) %>%
  summarise(Total = n())

p <- ggplot(data, aes(x = Province, fill = Clinical_or_Environmental)) +
  geom_text(
    data = totals,
    aes(x = Province, y = Total, label = Total),
    inherit.aes = FALSE,
    vjust = -0.5,
    size = 6,
    family = "Arial"
  ) +
  geom_bar(position = "stack", width = 0.5, color = "white", linewidth = 0.2) +
  scale_fill_manual(values = c(
    "Clinical" = "#66C2A3",
    "Environmental" = "#FC8C62"
  )) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +
  theme_linedraw() +
  theme(
    panel.background = element_rect(fill = rgb(252/255, 248/255, 246/255)),
    plot.background = element_rect(fill = "transparent", color = NA),
    legend.background = element_rect(fill = "transparent", color = NA),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
    legend.position = "right",
    text = element_text(family = "Arial"),
    legend.title = element_text(size = 16, family = "Arial"),
    legend.text = element_text(size = 16, family = "Arial"),
    axis.title.x = element_text(size = 16, color = "black"),
    axis.title.y = element_text(size = 16, color = "black"),
    axis.text.x = element_text(size = 15, color = "black"),
    axis.text.y = element_text(size = 15, color = "black")
  ) +
  labs(
    x = "Province",
    y = "Number of isolates",
    fill = "Environmental vs. Clinical"
  )

ggsave(
  "province_stack_bar.svg", plot = p, bg = "transparent",
  width = 24, height = 12, units = "cm", limitsize = FALSE
)
ggsave(
  "province_stack_bar.png", plot = p, bg = "transparent",
  width = 30, height = 20, units = "cm", dpi = 300
)

print("绘图完成，文件已保存。")
