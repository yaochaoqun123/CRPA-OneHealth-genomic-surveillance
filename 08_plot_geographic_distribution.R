library(ggplot2)
library(tidyverse)
library(readxl)
library(scatterpie)
library(sf)

df_raw <- read_excel("data.xlsx")

plot_data <- df_raw %>%
  group_by(Province, Habitat) %>%
  summarise(count = n(), .groups = 'drop') %>%
  pivot_wider(names_from = Habitat, values_from = count, values_fill = 0)

plot_data$sum <- rowSums(plot_data[, -1])

province_coords <- data.frame(
  Province = c("Anhui", "Beijing", "Chongqing", "Fujian", "Gansu", "Guangdong",
               "Guangxi", "Guizhou", "Hainan", "Hebei", "Heilongjiang", "Henan",
               "Hubei", "Hunan", "Jiangsu", "Jiangxi", "Jilin", "Liaoning",
               "Inner Mongolia", "Ningxia", "Qinghai", "Shaanxi", "Shandong",
               "Shanghai", "Shanxi", "Sichuan", "Tianjin", "Tibet", "Xinjiang",
               "Yunnan", "Zhejiang"),
  lon = c(117.28304, 116.40529, 106.50496, 119.30624, 103.82356, 113.28064,
          108.32000, 106.71348, 110.33119, 114.50246, 126.64246, 113.66541,
          114.29857, 112.98228, 118.76741, 115.89215, 125.32450, 123.42909,
          111.67080, 106.27818, 101.77892, 108.94802, 117.00092, 121.47264,
          112.54925, 104.06574, 117.19018, 91.13221, 87.61773,
          102.71225, 120.15358),
  lat = c(31.86119, 39.90499, 29.53316, 26.07530, 36.05804, 23.12518,
          22.82402, 26.57834, 20.03197, 38.04547, 45.75697, 34.75798,
          30.58435, 28.11244, 32.04154, 28.67649, 43.88684, 41.79677,
          40.81831, 38.46637, 36.62318, 34.26316, 36.67581, 31.23171,
          37.85701, 30.65946, 39.12560, 29.66036, 43.79282,
          25.04061, 30.28746)
)

final_df <- left_join(plot_data, province_coords, by = "Province")

target_crs <- "+proj=aea +lat_1=25 +lat_2=47 +lat_0=0 +lon_0=105 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"

china_pro <- sf::read_sf("China.geojson")
china_pro_proj <- sf::st_transform(china_pro, crs = target_crs)

points_sf <- st_as_sf(final_df, coords = c("lon", "lat"), crs = 4326)
points_sf_proj <- st_transform(points_sf, crs = target_crs)
coords_proj <- st_coordinates(points_sf_proj)
final_df$lon_proj <- coords_proj[, 1]
final_df$lat_proj <- coords_proj[, 2]

habitat_cols <- colnames(final_df)[!colnames(final_df) %in% c(
  "Province", "sum", "lon", "lat", "lon_proj", "lat_proj", "geometry"
)]

radius_scale <- 13000

p <- ggplot() +
  geom_sf(
    data = china_pro_proj,
    fill = rgb(252/255, 248/255, 246/255),
    size = 0.4,
    color = "#000000"
  ) +
  scatterpie::geom_scatterpie(
    data = final_df,
    aes(x = lon_proj, y = lat_proj, group = Province, r = sqrt(sum) * radius_scale),
    cols = habitat_cols,
    color = "black",
    size = 0.1,
    alpha = 0.9
  ) +
  geom_scatterpie_legend(
    sqrt(final_df$sum) * radius_scale,
    x = 2200000,
    y = 2000000,
    labeller = function(x) round((x/radius_scale)^2)
  ) +
  scale_fill_manual(values = c(
    "hospital_E" = "#66C2A3",
    "hospital_C" = "#FC8C62",
    "farm" = "#8EA0CC",
    "WWTP" = "#A6D953"
  )) +
  labs(fill = "Habitat") +
  theme_bw() +
  theme(
    panel.background = element_rect(fill = "transparent", color = NA),
    plot.background = element_rect(fill = "transparent", color = NA),
    legend.background = element_rect(fill = "transparent", color = NA),
    legend.box.background = element_rect(fill = "transparent", color = NA),
    legend.title = element_text(family = "Arial"),
    legend.text = element_text(family = "Arial"),
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank()
  )

ggsave(
  "figure_map_pie_circle.svg", plot = p, device = "svg",
  width = 12, height = 8, bg = "transparent"
)
ggsave(
  "figure_map_pie_circle.png", plot = p,
  width = 12, height = 8, bg = "transparent", dpi = 300
)

print("绘图完成。如果饼图太大或太小，请调整 radius_scale 参数。")
