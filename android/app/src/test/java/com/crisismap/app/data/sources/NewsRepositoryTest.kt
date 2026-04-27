package com.crisismap.app.data.sources

import com.crisismap.app.data.model.CrisisEvent
import com.crisismap.app.data.model.EventCategory
import com.crisismap.app.data.model.Location
import com.crisismap.app.data.model.Region
import com.crisismap.app.data.model.SourceTier
import com.crisismap.app.data.model.ThreatLevel
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class NewsRepositoryTest {
    @Test
    fun fallsBackToFixtureWhenLiveSourcesFail() = runTest {
        val repository = NewsRepository(
            sources = listOf(FailingNewsSource),
            fallbackSource = StaticNewsSource(listOf(event("e1", "Taiwan Strait patrols continue")))
        )

        val result = repository.loadClusters()

        assertTrue(result is NewsLoadResult.Success)
        result as NewsLoadResult.Success
        assertEquals(1, result.clusters.size)
        assertEquals(Region.EastAsia, result.clusters.first().region)
        assertEquals(listOf("live"), result.failedSources)
    }

    @Test
    fun returnsEventsWithInferredLocations() = runTest {
        val repository = NewsRepository(
            sources = listOf(StaticNewsSource(listOf(event("mali", "Mali defence minister killed")))),
            fallbackSource = StaticNewsSource(emptyList())
        )

        val result = repository.loadClusters()

        assertTrue(result is NewsLoadResult.Success)
        result as NewsLoadResult.Success
        assertEquals("Mali", result.events.first().location?.name)
    }

    @Test
    fun returnsSuccessWhenLocatedEventsDoNotCluster() = runTest {
        val locatedEvent = event("port-vila", "Port Vila port resumes operations").copy(
            location = Location(
                lat = -17.7333,
                lng = 168.3273,
                name = "Port Vila",
                country = "VU"
            )
        )
        val repository = NewsRepository(
            sources = listOf(StaticNewsSource(listOf(locatedEvent))),
            fallbackSource = StaticNewsSource(emptyList())
        )

        val result = repository.loadClusters()

        assertTrue(result is NewsLoadResult.Success)
        result as NewsLoadResult.Success
        assertEquals(1, result.events.size)
        assertEquals(emptyList<com.crisismap.app.domain.regions.NewsClusterSummary>(), result.clusters)
    }

    @Test
    fun classifiesPhysicalLocationBeforeActorReferences() {
        val clusters = buildNewsClusters(
            listOf(
                event(
                    id = "mali-russia",
                    title = "What's driving attacks against gov't and Russian forces in Mali?",
                    summary = "Russian personnel remain exposed to attacks in Mali."
                )
            )
        )

        assertEquals(1, clusters.size)
        assertEquals(Region.Africa, clusters.first().region)
    }

    private fun event(
        id: String,
        title: String,
        summary: String = "Fixture summary"
    ) = CrisisEvent(
        id = id,
        title = title,
        summary = summary,
        category = EventCategory.Military,
        level = ThreatLevel.Medium,
        timestamp = "2026-04-26T00:00:00Z",
        source = "Fixture",
        sourceTier = SourceTier.Public,
        url = "https://example.com/$id"
    )
}

private object FailingNewsSource : NewsDataSource {
    override val id = "live"
    override val name = "Live"

    override suspend fun fetch(): List<CrisisEvent> {
        throw IllegalStateException("offline")
    }
}
