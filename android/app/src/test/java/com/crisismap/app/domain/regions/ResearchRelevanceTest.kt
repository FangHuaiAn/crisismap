package com.crisismap.app.domain.regions

import com.crisismap.app.data.model.CrisisEvent
import com.crisismap.app.data.model.EventCategory
import com.crisismap.app.data.model.Region
import com.crisismap.app.data.model.SourceTier
import com.crisismap.app.data.model.ThreatLevel
import com.crisismap.app.data.model.ThinkTankArticle
import org.junit.Assert.assertEquals
import org.junit.Test

class ResearchRelevanceTest {
    @Test
    fun relatedResearchUsesRegionAndActorTopics() {
        val result = relatedResearch(
            eventRegion = Region.Africa,
            entities = listOf("Russia", "Sahel"),
            articles = listOf(
                article(category = "africa", topics = listOf("Sahel")),
                article(id = "europe", category = "europe", topics = listOf("NATO"))
            )
        )

        assertEquals(listOf("africa"), result.map { it.id })
    }

    @Test
    fun relatedResearchForEventFallsBackToRegionText() {
        val result = relatedResearchForEvent(
            event = event(
                title = "Red Sea shipping disrupted by Houthi attacks",
                summary = "Commercial shipping remains exposed near Yemen.",
                actor = "Houthi",
                entities = listOf("Houthi")
            ),
            articles = listOf(article(id = "middle-east", category = "middle_east", topics = listOf("Houthi")))
        )

        assertEquals(listOf("middle-east"), result.map { it.id })
    }

    private fun article(
        id: String = "africa",
        category: String,
        topics: List<String>
    ) = ThinkTankArticle(
        id = id,
        thinkTank = "RAND",
        title = "Report $id",
        url = "https://example.com/$id",
        date = "2026-04-01",
        category = category,
        topics = topics
    )

    private fun event(
        title: String,
        summary: String,
        actor: String,
        entities: List<String>
    ) = CrisisEvent(
        id = "event",
        title = title,
        summary = summary,
        category = EventCategory.Military,
        level = ThreatLevel.High,
        timestamp = "2026-04-26T00:00:00Z",
        source = "Fixture",
        sourceTier = SourceTier.Public,
        actor = actor,
        entities = entities
    )
}
