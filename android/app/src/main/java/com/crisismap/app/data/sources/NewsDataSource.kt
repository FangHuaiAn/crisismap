package com.crisismap.app.data.sources

import com.crisismap.app.data.model.CrisisEvent
import com.crisismap.app.data.model.EventCategory
import com.crisismap.app.data.model.NewsSourceAttribution
import com.crisismap.app.data.model.NewsSourceDescriptor
import com.crisismap.app.data.model.NewsSourceKind
import com.crisismap.app.data.model.SourceTier
import com.crisismap.app.data.model.ThreatLevel

interface NewsDataSource {
    val id: String
    val name: String

    suspend fun fetch(): List<CrisisEvent>
}

class StaticNewsSource(
    private val events: List<CrisisEvent>,
    override val id: String = "fixture",
    override val name: String = "Fixture"
) : NewsDataSource {
    override suspend fun fetch(): List<CrisisEvent> = events
}

class FixtureNewsSource : NewsDataSource {
    override val id = "fixture"
    override val name = "Fixture"

    override suspend fun fetch(): List<CrisisEvent> = listOf(
        fixtureEvent(
            id = "fixture-east-asia",
            title = "Taiwan Strait patrols remain elevated",
            summary = "Regional reporting continues to track air and maritime activity around Taiwan.",
            category = EventCategory.Military,
            level = ThreatLevel.Medium
        ),
        fixtureEvent(
            id = "fixture-middle-east",
            title = "Middle East ceasefire diplomacy faces pressure",
            summary = "Diplomatic channels remain active as regional actors weigh security guarantees.",
            category = EventCategory.Diplomatic,
            level = ThreatLevel.Medium
        ),
        fixtureEvent(
            id = "fixture-europe",
            title = "NATO governments review Ukraine support timelines",
            summary = "European security planning remains focused on Russia and Ukraine.",
            category = EventCategory.Military,
            level = ThreatLevel.Medium
        )
    )

    private fun fixtureEvent(
        id: String,
        title: String,
        summary: String,
        category: EventCategory,
        level: ThreatLevel
    ) = CrisisEvent(
        id = id,
        title = title,
        summary = summary,
        category = category,
        level = level,
        timestamp = "2026-04-26T00:00:00Z",
        source = name,
        sourceTier = SourceTier.Public,
        newsSource = NewsSourceDescriptor(
            displayName = name,
            kind = NewsSourceKind.Aggregator,
            identity = id,
            group = "built-in",
            attribution = NewsSourceAttribution.Derived
        )
    )
}
