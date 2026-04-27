package com.crisismap.app.ui.research

import com.crisismap.app.data.model.Region
import com.crisismap.app.data.model.ThinkTankArticle
import org.junit.Assert.assertEquals
import org.junit.Test

class ResearchRegionRowsTest {
    @Test
    fun countsAllAndConcreteRegions() {
        val rows = buildResearchRegionRows(
            listOf(
                article("a1", category = "middle_east"),
                article("a2", category = "china_indopacific", topics = listOf("Taiwan")),
                article("a3", category = "general", topics = listOf("NATO"))
            )
        )

        assertEquals(
            listOf(
                Region.All to 3,
                Region.MiddleEast to 1,
                Region.Europe to 1,
                Region.EastAsia to 1,
                Region.Africa to 0,
                Region.Americas to 0
            ),
            rows.map { it.region to it.count }
        )
    }

    private fun article(
        id: String,
        category: String,
        topics: List<String> = emptyList()
    ) = ThinkTankArticle(
        id = id,
        thinkTank = "RAND",
        title = "Report $id",
        url = "https://example.com/$id",
        date = "2026-04-01",
        category = category,
        topics = topics
    )
}
