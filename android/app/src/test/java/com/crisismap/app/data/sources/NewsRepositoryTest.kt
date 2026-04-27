package com.crisismap.app.data.sources

import com.crisismap.app.data.model.CrisisEvent
import com.crisismap.app.data.model.EventCategory
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

    private fun event(
        id: String,
        title: String
    ) = CrisisEvent(
        id = id,
        title = title,
        summary = "Fixture summary",
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
