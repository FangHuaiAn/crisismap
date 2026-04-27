package com.crisismap.app.data.sources

import com.crisismap.app.data.model.ThinkTankArticle
import com.crisismap.app.data.model.ThinkTankWeekly
import com.crisismap.app.data.model.WeekEntry
import com.crisismap.app.data.model.WeekIndex
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class ResearchRepositoryTest {
    @Test
    fun fetchesWeekIndexAndWeeklyFiles() = runTest {
        val api = FakeThinkTankApi(
            weeks = listOf("2026-W01", "2026-W02"),
            weekly = mapOf(
                "2026-W01" to weekly("2026-W01", article("a1")),
                "2026-W02" to weekly("2026-W02", article("a2"))
            )
        )

        val result = ResearchRepository(api).loadArticles()

        assertTrue(result is ResearchLoadResult.Success)
        result as ResearchLoadResult.Success
        assertEquals(listOf("weeks", "2026-W01", "2026-W02"), api.calls)
        assertEquals(listOf("a1", "a2"), result.articles.map { it.id }.sorted())
        assertEquals(emptyList<String>(), result.failedWeeks)
    }

    @Test
    fun partialWeeklyFailuresStillReturnSuccessfulArticles() = runTest {
        val api = FakeThinkTankApi(
            weeks = listOf("2026-W01", "2026-W02"),
            weekly = mapOf("2026-W01" to weekly("2026-W01", article("a1"))),
            failingWeeks = setOf("2026-W02")
        )

        val result = ResearchRepository(api).loadArticles()

        assertTrue(result is ResearchLoadResult.Success)
        result as ResearchLoadResult.Success
        assertEquals(listOf("a1"), result.articles.map { it.id })
        assertEquals(listOf("2026-W02"), result.failedWeeks)
    }

    @Test
    fun allWeeksFailingReturnsFailure() = runTest {
        val api = FakeThinkTankApi(
            weeks = listOf("2026-W01", "2026-W02"),
            failingWeeks = setOf("2026-W01", "2026-W02")
        )

        val result = ResearchRepository(api).loadArticles()

        assertTrue(result is ResearchLoadResult.Failure)
        result as ResearchLoadResult.Failure
        assertEquals(listOf("2026-W01", "2026-W02"), result.failedWeeks)
    }

    private fun article(id: String) = ThinkTankArticle(
        id = id,
        thinkTank = "RAND",
        title = "Report $id",
        url = "https://example.com/$id",
        date = "2026-04-01"
    )

    private fun weekly(
        week: String,
        vararg articles: ThinkTankArticle
    ) = ThinkTankWeekly(
        week = week,
        startDate = "2026-04-01",
        endDate = "2026-04-07",
        generatedAt = "2026-04-08T00:00:00Z",
        articles = articles.toList()
    )
}

private class FakeThinkTankApi(
    private val weeks: List<String>,
    private val weekly: Map<String, ThinkTankWeekly> = emptyMap(),
    private val failingWeeks: Set<String> = emptySet()
) : ThinkTankApi {
    val calls = mutableListOf<String>()

    override suspend fun fetchWeekIndex(): WeekIndex {
        calls += "weeks"
        return WeekIndex(weeks.map { WeekEntry(week = it, uploaded = "2026-04-08T00:00:00Z") })
    }

    override suspend fun fetchTopicsIndex() = throw UnsupportedOperationException("Unused in repository tests")

    override suspend fun fetchWeekly(week: String): ThinkTankWeekly {
        calls += week
        if (week in failingWeeks) throw IllegalStateException("failed $week")
        return weekly.getValue(week)
    }
}
