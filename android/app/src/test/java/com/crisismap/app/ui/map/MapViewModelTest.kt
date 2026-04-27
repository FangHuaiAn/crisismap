package com.crisismap.app.ui.map

import com.crisismap.app.data.model.CrisisEvent
import com.crisismap.app.data.model.EventCategory
import com.crisismap.app.data.model.Location
import com.crisismap.app.data.model.Region
import com.crisismap.app.data.model.SourceTier
import com.crisismap.app.data.model.ThreatLevel
import com.crisismap.app.data.model.ThinkTankWeekly
import com.crisismap.app.data.model.TopicsIndex
import com.crisismap.app.data.model.WeekIndex
import com.crisismap.app.data.sources.NewsRepository
import com.crisismap.app.data.sources.ResearchRepository
import com.crisismap.app.data.sources.StaticNewsSource
import com.crisismap.app.data.sources.ThinkTankApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.resetMain
import kotlinx.coroutines.test.runTest
import kotlinx.coroutines.test.setMain
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

@OptIn(kotlinx.coroutines.ExperimentalCoroutinesApi::class)
class MapViewModelTest {
    @Test
    fun mapStateIncludesLocatedEventsAndRegionSummaries() = runTest {
        val dispatcher = StandardTestDispatcher(testScheduler)
        Dispatchers.setMain(dispatcher)

        try {
            val viewModel = MapViewModel(
                newsRepository = NewsRepository(
                    sources = listOf(StaticNewsSource(listOf(locatedEvent(id = "mali")))),
                    fallbackSource = StaticNewsSource(emptyList())
                ),
                researchRepository = ResearchRepository(EmptyThinkTankApi)
            )

            advanceUntilIdle()

            assertEquals(listOf("mali"), viewModel.uiState.eventMarkers.map { it.eventId })
            assertTrue(viewModel.uiState.summaries.any { it.region == Region.Africa })
        } finally {
            Dispatchers.resetMain()
        }
    }

    private fun locatedEvent(id: String) = CrisisEvent(
        id = id,
        title = "Mali defence minister killed",
        summary = "Mali faces a wave of rebel attacks.",
        category = EventCategory.Military,
        level = ThreatLevel.High,
        location = Location(lat = 17.57, lng = -3.99, name = "Mali", country = "ML"),
        timestamp = "2026-04-26T00:00:00Z",
        source = "Fixture",
        sourceTier = SourceTier.Public,
        url = "https://example.com/$id"
    )
}

private object EmptyThinkTankApi : ThinkTankApi {
    override suspend fun fetchWeekIndex(): WeekIndex = WeekIndex(weeks = emptyList())
    override suspend fun fetchTopicsIndex(): TopicsIndex = TopicsIndex(topics = emptyList())
    override suspend fun fetchWeekly(week: String): ThinkTankWeekly {
        error("No weekly research should be fetched when the week index is empty.")
    }
}
