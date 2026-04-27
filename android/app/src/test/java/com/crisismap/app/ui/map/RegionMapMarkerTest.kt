package com.crisismap.app.ui.map

import com.crisismap.app.data.model.Region
import com.crisismap.app.domain.regions.RegionIntelligenceSummary
import com.crisismap.app.domain.regions.RegionMapCoordinate
import org.junit.Assert.assertEquals
import org.junit.Test

class RegionMapMarkerTest {
    @Test
    fun buildsMarkersFromRegionCoordinates() {
        val markers = buildRegionMapMarkers(
            listOf(
                summary(
                    region = Region.MiddleEast,
                    coordinate = RegionMapCoordinate(lat = 29.5, lng = 44.0),
                    newsClusterCount = 2,
                    researchArticleCount = 3
                )
            )
        )

        assertEquals(1, markers.size)
        assertEquals(Region.MiddleEast, markers.first().region)
        assertEquals("Middle East", markers.first().title)
        assertEquals("2 news | 3 research", markers.first().snippet)
        assertEquals(29.5, markers.first().lat, 0.0001)
        assertEquals(44.0, markers.first().lng, 0.0001)
        assertEquals(5, markers.first().totalCount)
    }

    @Test
    fun omitsRegionsWithoutRelatedIntelligence() {
        val markers = buildRegionMapMarkers(
            listOf(
                summary(
                    region = Region.Europe,
                    coordinate = RegionMapCoordinate(lat = 50.0, lng = 10.0),
                    newsClusterCount = 0,
                    researchArticleCount = 0
                )
            )
        )

        assertEquals(emptyList<RegionMapMarker>(), markers)
    }

    private fun summary(
        region: Region,
        coordinate: RegionMapCoordinate,
        newsClusterCount: Int,
        researchArticleCount: Int
    ) = RegionIntelligenceSummary(
        region = region,
        coordinate = coordinate,
        newsClusterCount = newsClusterCount,
        researchArticleCount = researchArticleCount,
        topNewsClusters = emptyList(),
        recentResearchArticles = emptyList(),
        lastUpdatedAt = "2026-04-26T00:00:00Z",
        heatScore = 1.0
    )
}
