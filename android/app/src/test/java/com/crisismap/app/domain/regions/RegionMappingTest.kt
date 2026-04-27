package com.crisismap.app.domain.regions

import com.crisismap.app.data.model.Region
import com.crisismap.app.data.model.ThinkTankArticle
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class RegionMappingTest {
    @Test
    fun matchesMiddleEastResearchCategory() {
        val article = article(category = "middle_east")

        assertTrue(Region.MiddleEast.matchesArticle(article))
        assertFalse(Region.Europe.matchesArticle(article))
    }

    @Test
    fun matchesEastAsiaTaiwanTopic() {
        val article = article(category = "general", topics = listOf("Taiwan"))

        assertTrue(Region.EastAsia.matchesArticle(article))
        assertFalse(Region.Africa.matchesArticle(article))
    }

    @Test
    fun mapMarkerRegionsExcludeAll() {
        assertEquals(
            listOf(
                Region.MiddleEast,
                Region.Europe,
                Region.EastAsia,
                Region.Africa,
                Region.Americas
            ),
            mapMarkerRegions
        )
    }

    private fun article(
        category: String,
        topics: List<String> = emptyList()
    ) = ThinkTankArticle(
        id = "a1",
        thinkTank = "RAND",
        title = "Report",
        url = "https://example.com",
        date = "2026-04-01",
        category = category,
        topics = topics
    )
}
