package com.crisismap.app.domain.regions

import com.crisismap.app.data.model.NewsSourceKind
import com.crisismap.app.data.model.Region
import com.crisismap.app.data.model.ThinkTankArticle

data class NewsClusterSummary(
    val id: String,
    val title: String,
    val region: Region,
    val eventCount: Int,
    val sourceCount: Int,
    val score: Double,
    val topics: List<String>,
    val lastUpdatedAt: String,
    val sourceKinds: List<NewsSourceKind> = emptyList(),
    val directSourceCount: Int = 0,
    val derivedSourceCount: Int = 0
)

data class RegionMapCoordinate(
    val lat: Double,
    val lng: Double
)

data class RegionIntelligenceSummary(
    val region: Region,
    val coordinate: RegionMapCoordinate,
    val newsClusterCount: Int,
    val researchArticleCount: Int,
    val topNewsClusters: List<NewsClusterSummary>,
    val recentResearchArticles: List<ThinkTankArticle>,
    val lastUpdatedAt: String,
    val heatScore: Double
) {
    val totalCount: Int = newsClusterCount + researchArticleCount
}

fun buildRegionIntelligenceSummaries(
    newsClusters: List<NewsClusterSummary>,
    researchArticles: List<ThinkTankArticle>,
    lastUpdatedAt: String
): List<RegionIntelligenceSummary> {
    val base = mapMarkerRegions.map { region ->
        val regionClusters = newsClusters
            .filter { it.region == region }
            .sortedWith(compareByDescending<NewsClusterSummary> { it.score }.thenByDescending { it.lastUpdatedAt })

        val regionArticles = researchArticles
            .filter { region.matchesArticle(it) }
            .sortedByDescending { it.date }

        RegionIntelligenceSummary(
            region = region,
            coordinate = regionCoordinates.getValue(region),
            newsClusterCount = regionClusters.size,
            researchArticleCount = regionArticles.size,
            topNewsClusters = regionClusters.take(3),
            recentResearchArticles = regionArticles.take(3),
            lastUpdatedAt = lastUpdatedAt,
            heatScore = 0.0
        )
    }

    val maxCount = base.maxOfOrNull { it.totalCount } ?: 0
    if (maxCount == 0) return base

    return base.map { summary ->
        summary.copy(heatScore = summary.totalCount.toDouble() / maxCount.toDouble())
    }
}

private val regionCoordinates = mapOf(
    Region.MiddleEast to RegionMapCoordinate(lat = 29.5, lng = 44.0),
    Region.Europe to RegionMapCoordinate(lat = 50.0, lng = 10.0),
    Region.EastAsia to RegionMapCoordinate(lat = 34.0, lng = 110.0),
    Region.Africa to RegionMapCoordinate(lat = 1.5, lng = 20.0),
    Region.Americas to RegionMapCoordinate(lat = 15.0, lng = -75.0)
)
