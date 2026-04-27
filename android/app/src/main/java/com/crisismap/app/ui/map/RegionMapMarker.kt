package com.crisismap.app.ui.map

import com.crisismap.app.data.model.Region
import com.crisismap.app.domain.regions.RegionIntelligenceSummary
import com.crisismap.app.ui.regions.displayName

data class RegionMapMarker(
    val region: Region,
    val title: String,
    val snippet: String,
    val lat: Double,
    val lng: Double,
    val totalCount: Int
)

fun buildRegionMapMarkers(summaries: List<RegionIntelligenceSummary>): List<RegionMapMarker> =
    summaries
        .filter { it.region != Region.All && it.totalCount > 0 }
        .map { summary ->
            RegionMapMarker(
                region = summary.region,
                title = summary.region.displayName,
                snippet = "${summary.newsClusterCount} news | ${summary.researchArticleCount} research",
                lat = summary.coordinate.lat,
                lng = summary.coordinate.lng,
                totalCount = summary.totalCount
            )
        }
