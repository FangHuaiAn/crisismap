package com.crisismap.app.domain.regions

import com.crisismap.app.data.model.Region
import com.crisismap.app.data.model.ThinkTankArticle
import org.junit.Assert.assertEquals
import org.junit.Test

class RegionIntelligenceSummaryTest {
    @Test
    fun summariesIncludeExactlyFiveConcreteRegions() {
        val summaries = buildRegionIntelligenceSummaries(
            newsClusters = emptyList(),
            researchArticles = emptyList(),
            lastUpdatedAt = "2026-04-26T00:00:00Z"
        )

        assertEquals(mapMarkerRegions, summaries.map { it.region })
    }

    @Test
    fun summaryCountsNewsClustersAndResearchArticles() {
        val summaries = buildRegionIntelligenceSummaries(
            newsClusters = listOf(
                newsCluster(region = Region.EastAsia, id = "n1"),
                newsCluster(region = Region.EastAsia, id = "n2"),
                newsCluster(region = Region.Europe, id = "n3")
            ),
            researchArticles = listOf(
                article(category = "china_indopacific", topics = listOf("Taiwan")),
                article(category = "middle_east")
            ),
            lastUpdatedAt = "2026-04-26T00:00:00Z"
        )

        val eastAsia = summaries.first { it.region == Region.EastAsia }
        val middleEast = summaries.first { it.region == Region.MiddleEast }
        val europe = summaries.first { it.region == Region.Europe }

        assertEquals(2, eastAsia.newsClusterCount)
        assertEquals(1, eastAsia.researchArticleCount)
        assertEquals(3, eastAsia.totalCount)
        assertEquals(0, middleEast.newsClusterCount)
        assertEquals(1, middleEast.researchArticleCount)
        assertEquals(1, europe.newsClusterCount)
    }

    @Test
    fun heatScoreNormalizesAgainstLargestRegion() {
        val summaries = buildRegionIntelligenceSummaries(
            newsClusters = listOf(
                newsCluster(region = Region.EastAsia, id = "n1"),
                newsCluster(region = Region.EastAsia, id = "n2"),
                newsCluster(region = Region.Europe, id = "n3")
            ),
            researchArticles = listOf(article(category = "china_indopacific")),
            lastUpdatedAt = "2026-04-26T00:00:00Z"
        )

        assertEquals(1.0, summaries.first { it.region == Region.EastAsia }.heatScore, 0.0001)
        assertEquals(1.0 / 3.0, summaries.first { it.region == Region.Europe }.heatScore, 0.0001)
        assertEquals(0.0, summaries.first { it.region == Region.Africa }.heatScore, 0.0001)
    }

    private fun newsCluster(region: Region, id: String) = NewsClusterSummary(
        id = id,
        title = "Cluster $id",
        region = region,
        eventCount = 2,
        sourceCount = 2,
        score = 0.75,
        topics = listOf("Security"),
        lastUpdatedAt = "2026-04-26T00:00:00Z"
    )

    private fun article(
        category: String,
        topics: List<String> = emptyList()
    ) = ThinkTankArticle(
        id = "a-$category-${topics.joinToString()}",
        thinkTank = "RAND",
        title = "Report",
        url = "https://example.com",
        date = "2026-04-01",
        category = category,
        topics = topics
    )
}
