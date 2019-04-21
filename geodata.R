

library(osmdata)
q <- opq ("copenhagen") %>%
add_osm_feature(key = "public_transport", value = "stop_position")

d=osmdata_xml(q)

a=xmlParse(d)

recs <- xml_find_all(d, "//node")

vals <- trimws(xml_text(recs))

getbb(place_name = "copenhagen", format_out = "data.frame")

dk <- c(54.540,7.843,57.823,15.278)
dk2 <- "54.36775852406841,7.03125,57.75107598132104,15.4248046875"
dk3 <- c(55.850,7.843,56.823,11.075)
stops_dk <- opq(bbox = dk3, timeout = 1020,memsize = 1000000000000000000000000000000000) %>%
  add_osm_feature(key = "public_transport", value = "stop_position")

s <- osmdata_sf(stops_dk)
s

d=osmdata_xml(stops_dk)

a=xmlParse(d)

recs <- xml_find_all(d, "//node")
vals <- trimws(xml_text(recs))

cinema <- osmdata_sf(stops_dk)
cinema

a=getbb(display_name_contains = ", Danmark")

